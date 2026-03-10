// lib/core/network/dio_client.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/app_constants.dart';
import '../storage/local_storage.dart';

part 'dio_client.g.dart';

@riverpod
Dio dioClient(DioClientRef ref) {
  final storage = ref.watch(localStorageProvider);
  return _buildDio(storage);
}

Dio _buildDio(LocalStorage storage) {
  final dio = Dio(
    BaseOptions(
      baseUrl:        AppConstants.devUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept':       'application/json',
      },
    ),
  );

  // ── JWT Interceptor ────────────────────────────────────────────────────────
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await storage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401) {
        await storage.clearAll();
        // Caller should navigate to login on 401
      }
      handler.next(error);
    },
  ));

  // ── Logger (dev only) ──────────────────────────────────────────────────────
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: false,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
  ));

  return dio;
}

// ── App Exception ─────────────────────────────────────────────────────────────

class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const AppException({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  factory AppException.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const AppException(message: 'Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const AppException(message: 'No internet connection. Please check your network.');
      case DioExceptionType.badResponse:
        return _handleResponse(e.response);
      default:
        return AppException(message: e.message ?? 'An unexpected error occurred.');
    }
  }

  static AppException _handleResponse(Response? response) {
    final code = response?.statusCode ?? 0;
    final data = response?.data;
    String msg  = 'Something went wrong.';

    if (data is String)               { msg = data; }
    else if (data is Map)             { msg = data['message'] ?? data['title'] ?? msg; }
    else if (data is List<dynamic>)   { msg = data.join('\n'); }

    return AppException(message: msg, statusCode: code);
  }

  @override
  String toString() => message;
}
