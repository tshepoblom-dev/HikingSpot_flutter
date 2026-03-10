// lib/features/bookings/presentation/providers/bookings_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/bookings_api_service.dart';
import '../../data/models/booking_models.dart';

part 'bookings_provider.g.dart';

@riverpod
class MyBookings extends _$MyBookings {
  @override
  Future<List<BookingResponse>> build() =>
      ref.read(bookingsApiServiceProvider).getMyBookings();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(bookingsApiServiceProvider).getMyBookings());
  }

  Future<void> cancelBooking(int bookingId) async {
    await ref.read(bookingsApiServiceProvider).cancelBooking(bookingId);
    await refresh();
  }

  // ── Real-time mutations (called by AppHubService) ─────────────────────────

  /// Insert or replace a booking in the passenger's list.
  /// Handles: BookingStatusChanged, BookingRequestConfirmed.
  void upsert(BookingResponse booking) {
    state = state.whenData((list) {
      final idx = list.indexWhere((b) => b.bookingId == booking.bookingId);
      if (idx == -1) return [booking, ...list]; // new booking
      final updated = [...list];
      updated[idx] = booking;
      return updated;
    });
  }
}

@riverpod
class DriverBookings extends _$DriverBookings {
  @override
  Future<List<BookingResponse>> build() =>
      ref.read(bookingsApiServiceProvider).getDriverBookings();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(bookingsApiServiceProvider).getDriverBookings());
  }

  Future<void> approve(int bookingId) async {
    await ref.read(bookingsApiServiceProvider).approveBooking(bookingId);
    await refresh();
  }

  Future<void> reject(int bookingId) async {
    await ref.read(bookingsApiServiceProvider).rejectBooking(bookingId);
    await refresh();
  }

  // ── Real-time mutations (called by AppHubService) ─────────────────────────

  /// Insert or replace a booking in the driver's manage list.
  /// Handles: NewBookingRequest, ManageBookingUpdated, BookingCancelled.
  void upsert(BookingResponse booking) {
    state = state.whenData((list) {
      final idx = list.indexWhere((b) => b.bookingId == booking.bookingId);
      if (idx == -1) return [booking, ...list]; // new request from passenger
      final updated = [...list];
      updated[idx] = booking;
      return updated;
    });
  }
}

@riverpod
class RequestBookingVM extends _$RequestBookingVM {
  @override
  AsyncValue<BookingResponse?> build() => const AsyncData(null);

  Future<BookingResponse?> request(int tripId, {int seats = 1}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
      ref.read(bookingsApiServiceProvider).requestBooking(
        BookingRequest(tripId: tripId, seatsRequested: seats),
      ));
    return state.valueOrNull;
  }
}
