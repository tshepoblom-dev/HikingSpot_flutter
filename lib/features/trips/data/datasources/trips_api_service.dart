// lib/features/trips/data/datasources/trips_api_service.dart

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/mappers.dart';
import '../models/trip_models.dart';

part 'trips_api_service.g.dart';

@riverpod
TripsApiService tripsApiService(TripsApiServiceRef ref) {
  return TripsApiService(ref.watch(dioClientProvider));
}

class TripsApiService {
  final Dio _dio;
  TripsApiService(this._dio);

  Future<PagedResult<TripResponse>> searchTrips(TripSearchParams params) async {
    try {
      final queryParams = <String, dynamic>{
        if (params.from.isNotEmpty)   'From':         params.from,
        if (params.to.isNotEmpty)     'To':           params.to,
        if (params.date != null)      'Date':         DateFormat('yyyy-MM-dd').format(params.date!),
        if (params.latitude != null)  'Latitude':     params.latitude,
        if (params.longitude != null) 'Longitude':    params.longitude,
        'RadiusKm':    params.radiusKm,
        'Page':        params.page,
        'PageSize':    params.pageSize,
        'SeatsNeeded': params.seatsNeeded,
      };

      final res = await _dio.get('/api/trips/search', queryParameters: queryParams);

      // ── Uses shared mapper — no inline duplication ─────────────────────
      return PagedResultMapper.fromJson<TripResponse>(
        res.data as Map<String, dynamic>,
        (e) => TripResponse.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<TripResponse> getTripById(int tripId) async {
    try {
      final res = await _dio.get('/api/trips/$tripId');
      return TripResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<TripResponse> createTrip(TripCreateRequest request) async {
    try {
      final res = await _dio.post('/api/trips', data: request.toJson());
      return TripResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<List<TripResponse>> getMyTrips() async {
    try {
      final res = await _dio.get('/api/trips/my');
      return (res.data as List)
          .map((e) => TripResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<bool> cancelTrip(int tripId) async {
    try {
      await _dio.delete('/api/trips/$tripId');
      return true;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
