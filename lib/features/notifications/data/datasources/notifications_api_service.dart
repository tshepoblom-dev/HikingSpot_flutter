// lib/features/notifications/data/datasources/notifications_api_service.dart

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../models/notification_models.dart';

part 'notifications_api_service.g.dart';

@riverpod
NotificationsApiService notificationsApiService(NotificationsApiServiceRef ref) =>
    NotificationsApiService(ref.watch(dioClientProvider));

class NotificationsApiService {
  final Dio _dio;
  NotificationsApiService(this._dio);

  Future<List<NotificationItem>> getNotifications() async {
    try {
      final res = await _dio.get('/api/notifications');
      return (res.data as List).map((e) => NotificationItem.fromJson(e)).toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final res = await _dio.get('/api/notifications/unread-count');
      return (res.data as int?) ?? 0;
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<void> markAsRead(int id) async {
    try {
      await _dio.patch('/api/notifications/$id/read');
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _dio.patch('/api/notifications/read-all');
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // ── FCM token registration ────────────────────────────────────────────────

  /// Registers the device's FCM token with the backend so the server can
  /// send targeted push notifications via Firebase Cloud Messaging.
  Future<void> registerFcmToken(String token) async {
    try {
      await _dio.post('/api/notifications/register-token', data: {
        'token':    token,
        'platform': _platform(),
      });
    } on DioException catch (e) {
      // Non-fatal — log but don't crash the login flow
      throw AppException.fromDioError(e);
    }
  }

  /// Removes the token from the backend on logout so the user stops receiving
  /// push notifications on this device.
  Future<void> unregisterFcmToken(String token) async {
    try {
      await _dio.delete('/api/notifications/register-token', data: {
        'token': token,
      });
    } on DioException catch (_) {
      // Non-fatal
    }
  }

  String _platform() {
    // Use dart:io for runtime detection — kept simple to avoid extra imports
    try {
      // ignore: do_not_use_environment
      const bool isAndroid = bool.fromEnvironment('dart.library.io');
      return isAndroid ? 'android' : 'ios';
    } catch (_) {
      return 'unknown';
    }
  }
}
