// lib/core/signalr/app_hub_service.dart
//
// Single long-lived SignalR connection for the whole app session.
//
// The existing SignalRHub in chat_provider.dart handles one specific
// booking-chat room (the booking-{id} group joined via JoinBookingChat).
// This service handles every other event the server broadcasts.
//
// Server groups this client is added to on connect (ChatHub.OnConnectedAsync):
//   user-{userId}   — personal events pushed to this specific user
//   role-drivers    — if the user is a Driver or Admin
//
// ─────────────────────────────────────────────────────────────────────────────
// Full event → provider mutation table
// ─────────────────────────────────────────────────────────────────────────────
// Event                  Payload                      Mutates
// ─────────────────────────────────────────────────────────────────────────────
// TripPosted             {trip: TripResponseDto}      TripResults.insertTrip
// MyTripPosted           TripResponseDto              MyTrips.prepend
// TripUpdated            TripResponseDto              TripResults.updateTrip
//                                                     MyTrips.updateTrip
// TripCancelled          {tripId,depCity,destCity}    TripResults.removeTrip
//                                                     MyTrips.removeTrip
// TripSeatUpdated        {tripId,availableSeats}      TripResults.updateSeatCount
// ─────────────────────────────────────────────────────────────────────────────
// NewBookingRequest      BookingResponseDto           DriverBookings.upsert
// ManageBookingUpdated   BookingResponseDto           DriverBookings.upsert
// BookingCancelled       BookingResponseDto           DriverBookings.upsert
// BookingStatusChanged   BookingResponseDto           MyBookings.upsert
// BookingRequestConfirmed BookingResponseDto          MyBookings.upsert
// ─────────────────────────────────────────────────────────────────────────────
// RideRequestPosted      RideRequestResponseDto       RideRequestResults.insertReq
// RideRequestUpdated     RideRequestResponseDto       RideRequestResults.upsertReq
// RideOfferAccepted      RideRequestResponseDto       RideRequestResults.upsertReq
// RideOfferReceived      RideRequestResponseDto       MyRideRequests.upsert
// RideRequestCancelled   RideRequestResponseDto       MyRideRequests.upsert
//                                                     RideRequestResults.upsertReq
// ─────────────────────────────────────────────────────────────────────────────
// ReceiveNotification    {notification,unreadCount}   NotificationsVM.prepend
//                                                     unreadBadgeCountProvider
// UnreadCountChanged     int                          unreadBadgeCountProvider
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../constants/app_constants.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/bookings/data/models/booking_models.dart';
import '../../features/bookings/presentation/providers/bookings_provider.dart';
import '../../features/notifications/data/datasources/notifications_api_service.dart';
import '../../features/notifications/data/models/notification_models.dart';
import '../../features/notifications/presentation/providers/notifications_provider.dart';
import '../../features/ride_requests/data/models/ride_request_models.dart';
import '../../features/ride_requests/presentation/providers/ride_requests_provider.dart';
import '../../features/trips/data/models/trip_models.dart';
import '../../features/trips/presentation/providers/trips_provider.dart';

// ── Badge count state ─────────────────────────────────────────────────────────
// Replaces the old 60-second polling StreamProvider in app_router.dart.
// The hub pushes real-time updates; the badge reflects them instantly.

final unreadBadgeCountProvider = StateProvider<int>((ref) => 0);

// ── Hub service provider ──────────────────────────────────────────────────────
// Not autoDispose — lives for the full app session alongside the auth state.

final appHubServiceProvider =
    NotifierProvider<AppHubService, HubConnectionState>(AppHubService.new);

// ── AppHubService ─────────────────────────────────────────────────────────────

class AppHubService extends Notifier<HubConnectionState> {
  HubConnection? _connection;

  @override
  HubConnectionState build() => HubConnectionState.Disconnected;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Connect (or no-op if already connected). Called after login /
  /// session restore from auth_provider.dart.
  Future<void> connect() async {
    if (_connection?.state == HubConnectionState.Connected) return;
    await _teardown();

    final token = ref.read(authStateProvider).valueOrNull?.token ?? '';
    if (token.isEmpty) {
      debugPrint('[AppHub] No token — skipping connect');
      return;
    }

    _connection = HubConnectionBuilder()
        .withUrl(
          '${AppConstants.hubUrl}?access_token=$token',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token,
            transport: HttpTransportType.WebSockets,
          ),
        )
        .withAutomaticReconnect()
        .build();

    _registerHandlers();

    _connection!.onclose(({error}) {
      state = HubConnectionState.Disconnected;
      debugPrint('[AppHub] Closed${error != null ? ": $error" : ""}');
    });
    _connection!.onreconnecting(({error}) {
      state = HubConnectionState.Reconnecting;
      debugPrint('[AppHub] Reconnecting…');
    });
    _connection!.onreconnected(({connectionId}) {
      state = HubConnectionState.Connected;
      debugPrint('[AppHub] Reconnected');
      syncBadgeCount(); // re-sync badge after reconnect gap
    });

    try {
      await _connection!.start();
      state = HubConnectionState.Connected;
      debugPrint('[AppHub] Connected');
      await syncBadgeCount();
    } catch (e) {
      debugPrint('[AppHub] Connect failed: $e');
      state = HubConnectionState.Disconnected;
    }
  }

  /// Disconnect cleanly. Called on logout from auth_provider.dart.
  Future<void> disconnect() async {
    await _teardown();
    debugPrint('[AppHub] Disconnected (logout)');
  }

  /// Fetch current unread count from the API and push it into the badge
  /// provider. Called on first connect, reconnect, and when NotificationsScreen
  /// opens so the badge always reflects the true server value.
  Future<void> syncBadgeCount() async {
    try {
      final count =
          await ref.read(notificationsApiServiceProvider).getUnreadCount();
      ref.read(unreadBadgeCountProvider.notifier).state = count;
    } catch (e) {
      debugPrint('[AppHub] syncBadgeCount failed: $e');
    }
  }

  // ── Event handlers ─────────────────────────────────────────────────────────

  void _registerHandlers() {
    final c = _connection!;

    // ── Trip events ──────────────────────────────────────────────────────────

    // Broadcast to ALL clients when any driver posts a new trip.
    // The search-results screen inserts the card live without a refresh.
    c.on('TripPosted', (args) => _map(args, (raw) {
      final trip = TripResponse.fromJson(raw['trip'] as Map<String, dynamic>);
      ref.read(tripResultsProvider.notifier).insertTrip(trip);
    }));

    // Sent only to the posting driver's personal group.
    // Their "My Trips" list prepends the new trip immediately.
    c.on('MyTripPosted', (args) => _map(args, (raw) {
      ref.read(myTripsProvider.notifier).prepend(TripResponse.fromJson(raw));
    }));

    // Broadcast to ALL when a driver edits their trip.
    c.on('TripUpdated', (args) => _map(args, (raw) {
      final trip = TripResponse.fromJson(raw);
      ref.read(tripResultsProvider.notifier).updateTrip(trip);
      ref.read(myTripsProvider.notifier).updateTrip(trip);
    }));

    // Broadcast to ALL when a driver cancels a trip.
    // Removes the card from search results and the driver's own list.
    // Note: the server also sends BookingStatusChanged to each affected
    // passenger — those are handled in the Booking handlers below.
    c.on('TripCancelled', (args) => _map(args, (raw) {
      final tripId = (raw['tripId'] as num).toInt();
      ref.read(tripResultsProvider.notifier).removeTrip(tripId);
      ref.read(myTripsProvider.notifier).removeTrip(tripId);
    }));

    // Broadcast to ALL on any booking request, approval, or cancellation.
    // Keeps the "seats left" counter accurate in real time.
    c.on('TripSeatUpdated', (args) => _map(args, (raw) {
      final tripId = (raw['tripId']         as num).toInt();
      final seats  = (raw['availableSeats'] as num).toInt();
      ref.read(tripResultsProvider.notifier).updateSeatCount(tripId, seats);
    }));

    // ── Booking events ───────────────────────────────────────────────────────

    // Sent to the driver's personal group when a passenger requests a booking.
    c.on('NewBookingRequest', (args) => _map(args, (raw) {
      ref.read(driverBookingsProvider.notifier)
          .upsert(BookingResponse.fromJson(raw));
    }));

    // Sent to the driver after they approve or reject — their manage screen
    // card flips status without requiring a pull-to-refresh.
    c.on('ManageBookingUpdated', (args) => _map(args, (raw) {
      ref.read(driverBookingsProvider.notifier)
          .upsert(BookingResponse.fromJson(raw));
    }));

    // Sent to the driver when a passenger cancels their booking.
    c.on('BookingCancelled', (args) => _map(args, (raw) {
      ref.read(driverBookingsProvider.notifier)
          .upsert(BookingResponse.fromJson(raw));
    }));

    // Sent to the passenger when their booking status changes
    // (approved / rejected / trip cancelled by driver).
    c.on('BookingStatusChanged', (args) => _map(args, (raw) {
      ref.read(myBookingsProvider.notifier)
          .upsert(BookingResponse.fromJson(raw));
    }));

    // Sent to the passenger confirming their booking request was received.
    c.on('BookingRequestConfirmed', (args) => _map(args, (raw) {
      ref.read(myBookingsProvider.notifier)
          .upsert(BookingResponse.fromJson(raw));
    }));

    // ── Ride Request events ──────────────────────────────────────────────────

    // Broadcast to role-drivers group when any passenger posts a request.
    c.on('RideRequestPosted', (args) => _map(args, (raw) {
      ref.read(rideRequestResultsProvider.notifier)
          .insertRequest(RideRequestResponse.fromJson(raw));
    }));

    // Sent to all drivers when a request's status changes (offered, expired…).
    c.on('RideRequestUpdated', (args) => _map(args, (raw) {
      ref.read(rideRequestResultsProvider.notifier)
          .upsertRequest(RideRequestResponse.fromJson(raw));
    }));

    // Sent to the driver whose offer was accepted — updates their browse list.
    c.on('RideOfferAccepted', (args) => _map(args, (raw) {
      ref.read(rideRequestResultsProvider.notifier)
          .upsertRequest(RideRequestResponse.fromJson(raw));
    }));

    // Sent to the passenger when a driver makes them an offer.
    c.on('RideOfferReceived', (args) => _map(args, (raw) {
      ref.read(myRideRequestsProvider.notifier)
          .upsert(RideRequestResponse.fromJson(raw));
    }));

    // Sent when either party cancels — both views need to reflect this.
    c.on('RideRequestCancelled', (args) => _map(args, (raw) {
      final req = RideRequestResponse.fromJson(raw);
      ref.read(myRideRequestsProvider.notifier).upsert(req);
      ref.read(rideRequestResultsProvider.notifier).upsertRequest(req);
    }));

    // ── Notification events ──────────────────────────────────────────────────

    // Payload: { notification: NotificationDto, unreadCount: int }
    // Prepend the item to the notification list and update the nav badge.
    c.on('ReceiveNotification', (args) => _map(args, (raw) {
      final notifRaw = raw['notification'] as Map<String, dynamic>;
      final count    = (raw['unreadCount'] as num).toInt();
      ref.read(notificationsVMProvider.notifier)
          .prepend(NotificationItem.fromJson(notifRaw));
      ref.read(unreadBadgeCountProvider.notifier).state = count;
    }));

    // Sent after mark-as-read / mark-all-read so the badge drops instantly.
    c.on('UnreadCountChanged', (args) {
      if (args == null || args.isEmpty) return;
      try {
        final count = (args[0] as num).toInt();
        ref.read(unreadBadgeCountProvider.notifier).state = count;
      } catch (e) {
        debugPrint('[AppHub] UnreadCountChanged parse error: $e');
      }
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Unwrap args[0] as a Map and call [handler].
  /// Swallows parse errors so a single bad payload never crashes the hub.
  void _map(List<Object?>? args, void Function(Map<String, dynamic>) handler) {
    if (args == null || args.isEmpty) return;
    try {
      handler(args[0] as Map<String, dynamic>);
    } catch (e) {
      debugPrint('[AppHub] Handler error: $e');
    }
  }

  Future<void> _teardown() async {
    try { await _connection?.stop(); } catch (_) {}
    _connection = null;
    state = HubConnectionState.Disconnected;
  }
}
