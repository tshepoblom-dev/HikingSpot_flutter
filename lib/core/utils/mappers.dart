// lib/core/utils/mappers.dart
//
// Targeted mapping utilities — NOT a full mapper layer.
// The app uses Freezed DTOs end-to-end, so only these edge cases need help:
//   1. Backend enum strings (Pascal case) → Dart enums (camel case)
//   2. Generic PagedResult<T> deserialization helper
//   3. TripSearchParams round-trip through GoRouter extras

import 'package:json_annotation/json_annotation.dart';

import '../../features/bookings/data/models/booking_models.dart';
import '../../features/trips/data/models/trip_models.dart';

// ── 1. Enum Converters ────────────────────────────────────────────────────────
//
// The ASP.NET backend serializes enums as Pascal-case strings:
//   "Scheduled", "Pending", "Approved" …
// json_serializable by default matches lowercase names, so we provide
// explicit converters that are case-insensitive.

class TripStatusConverter implements JsonConverter<TripStatus, String> {
  const TripStatusConverter();

  @override
  TripStatus fromJson(String json) {
    return switch (json.toLowerCase()) {
      'scheduled'  => TripStatus.scheduled,
      'completed'  => TripStatus.completed,
      'cancelled'  => TripStatus.cancelled,
      _            => TripStatus.scheduled, // safe fallback
    };
  }

  @override
  String toJson(TripStatus status) => status.name; // "scheduled"
}

class BookingStatusConverter implements JsonConverter<BookingStatus, String> {
  const BookingStatusConverter();

  @override
  BookingStatus fromJson(String json) {
    return switch (json.toLowerCase()) {
      'pending'   => BookingStatus.pending,
      'approved'  => BookingStatus.approved,
      'rejected'  => BookingStatus.rejected,
      'cancelled' => BookingStatus.cancelled,
      _           => BookingStatus.pending, // safe fallback
    };
  }

  @override
  String toJson(BookingStatus status) => status.name;
}

// ── 2. Generic PagedResult Deserializer ───────────────────────────────────────
//
// Centralises the paged-list mapping that was duplicated in TripsApiService.
// Usage:
//   final result = PagedResultMapper.fromJson(
//     response.data,
//     (e) => TripResponse.fromJson(e as Map<String, dynamic>),
//   );

class PagedResultMapper {
  PagedResultMapper._();

  static PagedResult<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(Object?) fromItem,
  ) {
    return PagedResult<T>(
      items:      (json['items'] as List<dynamic>).map(fromItem).toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      page:       (json['page']       as num).toInt(),
      pageSize:   (json['pageSize']   as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasPrevious:(json['hasPrevious'] as bool?) ?? false,
      hasNext:    (json['hasNext']     as bool?) ?? false,
    );
  }
}

// ── 3. TripSearchParams GoRouter Helper ───────────────────────────────────────
//
// GoRouter passes `extra` as Object? — type info is lost on hot-restart and
// between route rebuilds. This extension provides a safe round-trip.

extension TripSearchParamsRouterExt on TripSearchParams {
  /// Converts only the fields that survive JSON serialisation through GoRouter.
  Map<String, dynamic> toRouterExtra() => {
    'from':        from,
    'to':          to,
    'date':        date?.toIso8601String(),
    'latitude':    latitude,
    'longitude':   longitude,
    'radiusKm':    radiusKm,
    'page':        page,
    'pageSize':    pageSize,
    'seatsNeeded': seatsNeeded,
  };

  static TripSearchParams fromRouterExtra(Map<String, dynamic> extra) {
    return TripSearchParams(
      from:        extra['from']        as String?  ?? '',
      to:          extra['to']          as String?  ?? '',
      date:        extra['date'] != null
                     ? DateTime.tryParse(extra['date'] as String)
                     : null,
      latitude:    (extra['latitude']  as num?)?.toDouble(),
      longitude:   (extra['longitude'] as num?)?.toDouble(),
      radiusKm:    (extra['radiusKm']  as num?)?.toDouble() ?? 50.0,
      page:        (extra['page']      as num?)?.toInt()    ?? 1,
      pageSize:    (extra['pageSize']  as num?)?.toInt()    ?? 20,
      seatsNeeded: (extra['seatsNeeded'] as num?)?.toInt() ?? 1,
    );
  }
}
