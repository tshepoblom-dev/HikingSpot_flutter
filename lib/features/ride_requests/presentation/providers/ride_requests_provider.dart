// lib/features/ride_requests/presentation/providers/ride_requests_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../trips/data/models/trip_models.dart';
import '../../data/datasources/ride_requests_api_service.dart';
import '../../data/models/ride_request_models.dart';

// ── My Ride Requests (passenger) ──────────────────────────────────────────────

final myRideRequestsProvider =
    AsyncNotifierProvider.autoDispose<MyRideRequests, List<RideRequestResponse>>(
  MyRideRequests.new,
);

class MyRideRequests extends AutoDisposeAsyncNotifier<List<RideRequestResponse>> {
  @override
  Future<List<RideRequestResponse>> build() async {
    return ref.read(rideRequestsApiServiceProvider).getMyRequests();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(rideRequestsApiServiceProvider).getMyRequests(),
    );
  }

  Future<void> acceptOffer(int requestId) async {
    final updated =
        await ref.read(rideRequestsApiServiceProvider).acceptOffer(requestId);
    final current = state.valueOrNull ?? [];
    state = AsyncData(current.map((r) => r.id == requestId ? updated : r).toList());
  }

  Future<void> cancelRequest(int requestId) async {
    await ref.read(rideRequestsApiServiceProvider).cancelRequest(requestId);
    await refresh();
  }

  Future<bool> createRequest(RideRequestCreateRequest request) async {
    try {
      final created =
          await ref.read(rideRequestsApiServiceProvider).createRequest(request);
      final current = state.valueOrNull ?? [];
      state = AsyncData([created, ...current]);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Real-time mutation (called by AppHubService) ───────────────────────────

  /// Insert or replace a ride request in the passenger's own list.
  /// Handles: RideOfferReceived, RideRequestCancelled.
  void upsert(RideRequestResponse req) {
    state = state.whenData((list) {
      final idx = list.indexWhere((r) => r.id == req.id);
      if (idx == -1) return [req, ...list];
      final updated = [...list];
      updated[idx] = req;
      return updated;
    });
  }
}

// ── Driver: Browse Passenger Requests ─────────────────────────────────────────

final rideRequestSearchStateProvider =
    StateProvider.autoDispose<RideRequestSearchParams>(
  (ref) => const RideRequestSearchParams(),
);

final rideRequestResultsProvider =
    AsyncNotifierProvider.autoDispose<RideRequestResults,
        PagedResult<RideRequestResponse>>(
  RideRequestResults.new,
);

class RideRequestResults
    extends AutoDisposeAsyncNotifier<PagedResult<RideRequestResponse>> {
  @override
  PagedResult<RideRequestResponse> build() => const PagedResult(
        items: [],
        totalCount: 0,
        page: 1,
        pageSize: 20,
        totalPages: 0,
        hasPrevious: false,
        hasNext: false,
      );

  Future<void> search(RideRequestSearchParams params) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(rideRequestsApiServiceProvider).searchRequests(params),
    );
  }

  Future<void> loadMore(RideRequestSearchParams params) async {
    final current = state.valueOrNull;
    if (current == null || !current.hasNext) return;
    final next = await ref
        .read(rideRequestsApiServiceProvider)
        .searchRequests(params.copyWith(page: current.page + 1));
    state = AsyncData(
      next.copyWith(items: [...current.items, ...next.items]),
    );
  }

  // ── Real-time mutations (called by AppHubService) ─────────────────────────

  /// Insert a brand-new open request at the top of the driver browse list.
  /// Handles: RideRequestPosted.
  /// No-ops if the list hasn't been loaded yet or the item is already present.
  void insertRequest(RideRequestResponse req) {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.items.any((r) => r.id == req.id)) return;
    state = AsyncData(current.copyWith(
      items:      [req, ...current.items],
      totalCount: current.totalCount + 1,
    ));
  }

  /// Replace an existing request in-place, or append if not found.
  /// Handles: RideRequestUpdated, RideOfferAccepted, RideRequestCancelled.
  void upsertRequest(RideRequestResponse req) {
    final current = state.valueOrNull;
    if (current == null) return;
    final idx = current.items.indexWhere((r) => r.id == req.id);
    if (idx == -1) {
      // Not in the current page — append so the driver can see it without
      // having to trigger a manual search.
      state = AsyncData(current.copyWith(
        items: [...current.items, req],
      ));
    } else {
      final updated = [...current.items];
      updated[idx] = req;
      state = AsyncData(current.copyWith(items: updated));
    }
  }
}

// ── Driver: Make an Offer ─────────────────────────────────────────────────────

final makeOfferVMProvider =
    AsyncNotifierProvider.autoDispose<MakeOfferVM, RideRequestResponse?>(
  MakeOfferVM.new,
);

class MakeOfferVM extends AutoDisposeAsyncNotifier<RideRequestResponse?> {
  @override
  RideRequestResponse? build() => null;

  Future<bool> makeOffer(RideOfferRequest offer) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(rideRequestsApiServiceProvider).makeOffer(offer),
    );
    return state.hasValue && !state.hasError;
  }
}

// ── Create Ride Request VM ────────────────────────────────────────────────────

final createRideRequestVMProvider =
    AsyncNotifierProvider.autoDispose<CreateRideRequestVM, RideRequestResponse?>(
  CreateRideRequestVM.new,
);

class CreateRideRequestVM
    extends AutoDisposeAsyncNotifier<RideRequestResponse?> {
  @override
  RideRequestResponse? build() => null;

  Future<RideRequestResponse?> submit(RideRequestCreateRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(rideRequestsApiServiceProvider).createRequest(request),
    );
    return state.valueOrNull;
  }
}
