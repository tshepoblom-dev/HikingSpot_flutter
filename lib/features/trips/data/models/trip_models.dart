// lib/features/trips/data/models/trip_models.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/mappers.dart';

part 'trip_models.freezed.dart';
part 'trip_models.g.dart';

enum TripStatus { scheduled, completed, cancelled }

// ── Trip Response ─────────────────────────────────────────────────────────────

@freezed
class TripResponse with _$TripResponse {
  const factory TripResponse({
    required int tripId,
    required String driverName,
    required String driverId,
    required String vehicle,
    required String departureCity,
    required String destinationCity,
    required DateTime departureTime,
    required double pricePerSeat,
    required int availableSeats,
    required double driverRating,
    required String pickupLocation,
    @Default(0.0) double pickupLatitude,
    @Default(0.0) double pickupLongitude,
    @TripStatusConverter()
    @Default(TripStatus.scheduled) TripStatus status,
    double? distanceKm,
  }) = _TripResponse;

  factory TripResponse.fromJson(Map<String, dynamic> json) => _$TripResponseFromJson(json);
}

// ── Trip Create ───────────────────────────────────────────────────────────────

@freezed
class TripCreateRequest with _$TripCreateRequest {
  const factory TripCreateRequest({
    required String departureCity,
    required String destinationCity,
    required DateTime departureTime,
    required int seats,
    required double pricePerSeat,
    @Default('') String pickupLocation,
    @Default(0.0) double pickupLatitude,
    @Default(0.0) double pickupLongitude,
    @Default(0.0) double destinationLatitude,
    @Default(0.0) double destinationLongitude,
  }) = _TripCreateRequest;

  factory TripCreateRequest.fromJson(Map<String, dynamic> json) => _$TripCreateRequestFromJson(json);
}

// ── Trip Search ───────────────────────────────────────────────────────────────

@freezed
class TripSearchParams with _$TripSearchParams {
  const factory TripSearchParams({
    @Default('') String from,
    @Default('') String to,
    DateTime? date,
    double? latitude,
    double? longitude,
    @Default(50.0) double radiusKm,
    @Default(1) int page,
    @Default(20) int pageSize,
    @Default(1) int seatsNeeded,
  }) = _TripSearchParams;

  factory TripSearchParams.fromJson(Map<String, dynamic> json) => _$TripSearchParamsFromJson(json);
}

// ── Paged Result ──────────────────────────────────────────────────────────────
// ── Paged Result ──────────────────────────────────────────────────────────────
// Plain Dart class — NOT Freezed. Freezed ignores genericArgumentFactories,
// so PagedResult handles its own serialisation.

class PagedResult<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasPrevious;
  final bool hasNext;

  const PagedResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasPrevious,
    required this.hasNext,
  });

  PagedResult<T> copyWith({
    List<T>? items,
    int? totalCount,
    int? page,
    int? pageSize,
    int? totalPages,
    bool? hasPrevious,
    bool? hasNext,
  }) =>
      PagedResult<T>(
        items:       items       ?? this.items,
        totalCount:  totalCount  ?? this.totalCount,
        page:        page        ?? this.page,
        pageSize:    pageSize    ?? this.pageSize,
        totalPages:  totalPages  ?? this.totalPages,
        hasPrevious: hasPrevious ?? this.hasPrevious,
        hasNext:     hasNext     ?? this.hasNext,
      );

  factory PagedResult.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      PagedResult<T>(
        items:       (json['items'] as List<dynamic>).map(fromJsonT).toList(),
        totalCount:  (json['totalCount'] as num).toInt(),
        page:        (json['page']       as num).toInt(),
        pageSize:    (json['pageSize']   as num).toInt(),
        totalPages:  (json['totalPages'] as num).toInt(),
        hasPrevious: (json['hasPrevious'] as bool?) ?? false,
        hasNext:     (json['hasNext']     as bool?) ?? false,
      );
}
