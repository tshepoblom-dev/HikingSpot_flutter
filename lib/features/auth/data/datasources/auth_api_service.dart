// lib/features/auth/data/datasources/auth_api_service.dart

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../models/auth_models.dart';

part 'auth_api_service.g.dart';

@riverpod
AuthApiService authApiService(AuthApiServiceRef ref) {
  return AuthApiService(ref.watch(dioClientProvider));
}

class AuthApiService {
  final Dio _dio;
  AuthApiService(this._dio);

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final res = await _dio.post('/api/auth/login', data: request.toJson());
      return AuthResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final res = await _dio.post('/api/auth/register', data: request.toJson());
      return AuthResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
