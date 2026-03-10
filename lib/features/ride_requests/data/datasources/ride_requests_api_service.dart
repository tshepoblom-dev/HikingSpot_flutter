// lib/features/ride_requests/data/datasources/ride_requests_api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/mappers.dart';
import '../../../trips/data/models/trip_models.dart';
import '../models/ride_request_models.dart';

// Manual provider — no @riverpod annotation, no .g.dart needed
final rideRequestsApiServiceProvider = Provider.autoDispose<RideRequestsApiService>((ref) {
  return RideRequestsApiService(ref.watch(dioClientProvider));
});

class RideRequestsApiService {
  final Dio _dio;
  RideRequestsApiService(this._dio);

  // ── Passenger: create a ride request ────────────────────────────────────
  Future<RideRequestResponse> createRequest(RideRequestCreateRequest request) async {
    try {
      final res = await _dio.post('/api/ride-requests', data: request.toJson());
      return RideRequestResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // ── Passenger: my posted requests ────────────────────────────────────────
  Future<List<RideRequestResponse>> getMyRequests() async {
    try {
      final res = await _dio.get('/api/ride-requests/my');
      return (res.data as List)
          .map((e) => RideRequestResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // ── Driver: browse open passenger requests ────────────────────────────────
  Future<PagedResult<RideRequestResponse>> searchRequests(
      RideRequestSearchParams params) async {
    try {
      final query = <String, dynamic>{
        if (params.fromCity.isNotEmpty) 'FromCity': params.fromCity,
        if (params.toCity.isNotEmpty)   'ToCity':   params.toCity,
        if (params.date != null)        'Date':     DateFormat('yyyy-MM-dd').format(params.date!),
        'Page':     params.page,
        'PageSize': params.pageSize,
      };
      final res = await _dio.get('/api/ride-requests/search', queryParameters: query);
      return PagedResultMapper.fromJson<RideRequestResponse>(
        res.data as Map<String, dynamic>,
        (e) => RideRequestResponse.fromJson(e as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // ── Driver: offer to take a passenger ────────────────────────────────────
  Future<RideRequestResponse> makeOffer(RideOfferRequest offer) async {
    try {
      final res = await _dio.post(
        '/api/ride-requests/${offer.rideRequestId}/offer',
        data: offer.toJson(),
      );
      return RideRequestResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // ── Passenger: accept a driver's offer ───────────────────────────────────
  Future<RideRequestResponse> acceptOffer(int requestId) async {
    try {
      final res = await _dio.put('/api/ride-requests/$requestId/accept');
      return RideRequestResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // ── Passenger/Driver: cancel ──────────────────────────────────────────────
  Future<void> cancelRequest(int requestId) async {
    try {
      await _dio.put('/api/ride-requests/$requestId/cancel');
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
