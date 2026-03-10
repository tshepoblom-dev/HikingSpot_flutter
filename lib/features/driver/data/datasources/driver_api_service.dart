// lib/features/driver/data/datasources/driver_api_service.dart

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../models/driver_models.dart';

part 'driver_api_service.g.dart';

@riverpod
DriverApiService driverApiService(DriverApiServiceRef ref) =>
    DriverApiService(ref.watch(dioClientProvider));

class DriverApiService {
  final Dio _dio;
  DriverApiService(this._dio);

  Future<DriverResponse> getDriverById(int driverProfileId) async {
    try {
      final res = await _dio.get('/api/drivers/$driverProfileId');
      return DriverResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<DriverResponse?> getMyProfile() async {
    try {
      final res = await _dio.get('/api/drivers/me');
      return DriverResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw AppException.fromDioError(e);
    }
  }

  Future<DriverResponse> createProfile(DriverProfileRequest request) async {
    try {
      final res = await _dio.post('/api/drivers', data: request.toJson());
      return DriverResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<DriverResponse> updateProfile(DriverProfileRequest request) async {
    try {
      final res = await _dio.put('/api/drivers', data: request.toJson());
      return DriverResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// lib/features/notifications/data/datasources/notifications_api_service.dart
// ─────────────────────────────────────────────────────────────────────────────

