// lib/core/maps/google_maps_service.dart
//
// Location services backed entirely by OpenStreetMap / Nominatim.
// No API key required.
//
// Nominatim usage policy: https://operations.osmfoundation.org/policies/nominatim/
//   • Max 1 request/second — the 350 ms debounce in HsCityField satisfies this.
//   • Must send a valid User-Agent identifying your app.
//
// Public API is identical to the old Google Maps implementation so no
// other files need updating.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

// ── Data models ───────────────────────────────────────────────────────────────

/// A city suggestion returned by the Nominatim search endpoint.
/// Unlike the old Google implementation, Nominatim returns coordinates
/// directly in the search response, so [getPlaceDetails] is a no-op
/// (instant resolution, zero extra network calls).
class PlaceSuggestion {
  final String placeId;       // Nominatim place_id as string
  final String mainText;      // e.g. "Johannesburg"
  final String secondaryText; // e.g. "Gauteng, South Africa"
  final String fullText;      // display_name from Nominatim
  // Coordinates pre-fetched from the search result
  final double latitude;
  final double longitude;

  const PlaceSuggestion({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
    required this.fullText,
    required this.latitude,
    required this.longitude,
  });
}

/// A fully resolved location: display name + coordinates.
class ResolvedLocation {
  final String cityName;    // Short city name shown in the form field
  final String fullAddress; // Full display_name shown in the map picker
  final double latitude;
  final double longitude;

  const ResolvedLocation({
    required this.cityName,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() => cityName;
}

// ── Service ───────────────────────────────────────────────────────────────────

class GoogleMapsService {
  static const _nominatimBase = 'https://nominatim.openstreetmap.org';
  static const _userAgent     = 'HikingSpotApp/1.0';

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      // Nominatim requires a descriptive User-Agent.
      'User-Agent': _userAgent,
      'Accept-Language': 'en',
    },
  ));

  // ── City autocomplete ──────────────────────────────────────────────────────
  // Maps to Nominatim /search with featuretype=city.
  // [countryCode] is an ISO 3166-1 alpha-2 code (e.g. 'ZA') to bias results.

  Future<List<PlaceSuggestion>> autocomplete(
    String query, {
    String? sessionToken, // kept for API compatibility, not used by Nominatim
    String? countryCode,
  }) async {
    if (query.trim().length < 2) return [];

    try {
      final response = await _dio.get(
        '$_nominatimBase/search',
        queryParameters: {
          'q':              query,
          'format':         'json',
          'addressdetails': 1,
          'featuretype':    'city',
          'limit':          7,
          if (countryCode != null) 'countrycodes': countryCode.toLowerCase(),
        },
      );

      final results = response.data as List<dynamic>;
      return results.map((r) {
        final address = r['address'] as Map<String, dynamic>? ?? {};
        final city = _extractCity(address) ??
            (r['display_name'] as String).split(',').first.trim();
        final secondary = _buildSecondary(address);

        return PlaceSuggestion(
          placeId:       r['place_id'].toString(),
          mainText:      city,
          secondaryText: secondary,
          fullText:      r['display_name'] as String? ?? city,
          latitude:      double.parse(r['lat'] as String),
          longitude:     double.parse(r['lon'] as String),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Place details ──────────────────────────────────────────────────────────
  // Nominatim returns coordinates directly in the search response, so this
  // is a synchronous wrap — no extra HTTP call needed.

  Future<ResolvedLocation?> getPlaceDetails(
    PlaceSuggestion suggestion, {
    String? sessionToken, // kept for API compatibility
  }) async {
    return ResolvedLocation(
      cityName:    suggestion.mainText,
      fullAddress: suggestion.fullText,
      latitude:    suggestion.latitude,
      longitude:   suggestion.longitude,
    );
  }

  // ── Reverse geocoding (lat/lng → address) ──────────────────────────────────
  // Used when the user drags the pin on the full-screen map picker.

  Future<ResolvedLocation?> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      final response = await _dio.get(
        '$_nominatimBase/reverse',
        queryParameters: {
          'lat':            latitude,
          'lon':            longitude,
          'format':         'json',
          'addressdetails': 1,
        },
      );

      final data = response.data as Map<String, dynamic>;
      if (data['error'] != null) return null;

      final address     = data['address'] as Map<String, dynamic>? ?? {};
      final displayName = data['display_name'] as String? ?? '';
      final city        = _extractCity(address) ??
          displayName.split(',').first.trim();

      return ResolvedLocation(
        cityName:    city,
        fullAddress: displayName,
        latitude:    latitude,
        longitude:   longitude,
      );
    } catch (_) {
      return null;
    }
  }

  // ── Current device location ────────────────────────────────────────────────

  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (_) {
      return null;
    }
  }

  /// Gets the current device position then reverse geocodes it.
  Future<ResolvedLocation?> getCurrentLocation() async {
    final pos = await getCurrentPosition();
    if (pos == null) return null;
    return reverseGeocode(pos.latitude, pos.longitude);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Extract the best city-level name from a Nominatim address object.
  String? _extractCity(Map<String, dynamic> address) {
    for (final key in [
      'city', 'town', 'village', 'municipality',
      'suburb', 'county', 'state_district',
    ]) {
      final val = address[key];
      if (val is String && val.isNotEmpty) return val;
    }
    return null;
  }

  /// Build a readable secondary line, e.g. "Gauteng, South Africa".
  String _buildSecondary(Map<String, dynamic> address) {
    final parts = <String>[];
    for (final key in ['state', 'country']) {
      final val = address[key];
      if (val is String && val.isNotEmpty) parts.add(val);
    }
    return parts.join(', ');
  }
}

// ── Riverpod provider ─────────────────────────────────────────────────────────
// Provider name kept identical so all existing consumers compile unchanged.

final googleMapsServiceProvider = Provider<GoogleMapsService>(
  (_) => GoogleMapsService(),
);
