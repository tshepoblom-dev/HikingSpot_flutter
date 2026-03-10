// lib/features/trips/presentation/providers/trips_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/trips_api_service.dart';
import '../../data/models/trip_models.dart';

part 'trips_provider.g.dart';

// ── Trip Search State ─────────────────────────────────────────────────────────

@riverpod
class TripSearchState extends _$TripSearchState {
  @override
  TripSearchParams build() => const TripSearchParams();

  void updateParams(TripSearchParams params) => state = params;
  void reset() => state = const TripSearchParams();
}

// ── Trip Results ──────────────────────────────────────────────────────────────

@riverpod
class TripResults extends _$TripResults {
  @override
  AsyncValue<PagedResult<TripResponse>> build() => const AsyncData(
    PagedResult(items: [], totalCount: 0, page: 1, pageSize: 20, totalPages: 0, hasPrevious: false, hasNext: false),
  );

  Future<void> search(TripSearchParams params) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(tripsApiServiceProvider).searchTrips(params),
    );
  }

  Future<void> loadMore(TripSearchParams params) async {
    final current = state.valueOrNull;
    if (current == null || !current.hasNext) return;

    final next = await ref.read(tripsApiServiceProvider)
        .searchTrips(params.copyWith(page: current.page + 1));

    state = AsyncData(next.copyWith(items: [...current.items, ...next.items]));
  }

  // ── Real-time mutations (called by AppHubService) ─────────────────────────

  /// Insert a newly posted trip at the top of search results.
  /// No-ops if the results aren't loaded yet or the trip is already present.
  void insertTrip(TripResponse trip) {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.items.any((t) => t.tripId == trip.tripId)) return;
    state = AsyncData(current.copyWith(
      items:      [trip, ...current.items],
      totalCount: current.totalCount + 1,
    ));
  }

  /// Replace an existing trip card in-place (edit or status change).
  void updateTrip(TripResponse updated) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      items: current.items
          .map((t) => t.tripId == updated.tripId ? updated : t)
          .toList(),
    ));
  }

  /// Remove a cancelled trip from the results list.
  void removeTrip(int tripId) {
    final current = state.valueOrNull;
    if (current == null) return;
    final filtered = current.items.where((t) => t.tripId != tripId).toList();
    state = AsyncData(current.copyWith(
      items:      filtered,
      totalCount: current.totalCount > 0 ? current.totalCount - 1 : 0,
    ));
  }

  /// Patch only the available-seat count for one trip.
  /// Fires on every booking request / approval / cancellation.
  void updateSeatCount(int tripId, int availableSeats) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(
      items: current.items
          .map((t) => t.tripId == tripId
              ? t.copyWith(availableSeats: availableSeats)
              : t)
          .toList(),
    ));
  }
}

// ── Trip Details ──────────────────────────────────────────────────────────────

@riverpod
Future<TripResponse> tripDetails(TripDetailsRef ref, int tripId) async {
  return ref.read(tripsApiServiceProvider).getTripById(tripId);
}

// ── My Trips ──────────────────────────────────────────────────────────────────

@riverpod
class MyTrips extends _$MyTrips {
  @override
  Future<List<TripResponse>> build() async {
    return ref.read(tripsApiServiceProvider).getMyTrips();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(tripsApiServiceProvider).getMyTrips(),
    );
  }

  Future<void> cancelTrip(int tripId) async {
    await ref.read(tripsApiServiceProvider).cancelTrip(tripId);
    await refresh();
  }

  // ── Real-time mutations ────────────────────────────────────────────────────

  /// Prepend the trip the driver just created (MyTripPosted event).
  void prepend(TripResponse trip) {
    state = state.whenData((list) {
      if (list.any((t) => t.tripId == trip.tripId)) return list;
      return [trip, ...list];
    });
  }

  /// Update an existing trip in the driver's own list (TripUpdated event).
  void updateTrip(TripResponse updated) {
    state = state.whenData((list) =>
      list.map((t) => t.tripId == updated.tripId ? updated : t).toList(),
    );
  }

  /// Remove a cancelled trip (TripCancelled event).
  void removeTrip(int tripId) {
    state = state.whenData((list) =>
      list.where((t) => t.tripId != tripId).toList(),
    );
  }
}

// ── Create Trip ───────────────────────────────────────────────────────────────

@riverpod
class CreateTripVM extends _$CreateTripVM {
  @override
  AsyncValue<TripResponse?> build() => const AsyncData(null);

  Future<TripResponse?> createTrip(TripCreateRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(tripsApiServiceProvider).createTrip(request),
    );
    return state.valueOrNull;
  }
}
