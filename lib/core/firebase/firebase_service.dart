// lib/core/firebase/firebase_service.dart
//
// Handles:
//  • FCM token lifecycle (get, refresh, register with backend, unregister)
//  • Foreground push notification display via flutter_local_notifications
//  • Background / terminated message handling (top-level handler)
//  • Notification tap → deep-link payload surfaced through a Riverpod provider
//  • Firebase Analytics helper wrappers
//  • Firebase Crashlytics error recording

import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Background handler (must be a top-level function) ─────────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase is already initialised by the time this runs.
  // We just need to surface the data — FCM shows the notification automatically
  // for data-only messages when the app is killed.
  debugPrint('[FCM Background] ${message.messageId}: ${message.data}');
}

// ── Notification tap payload ──────────────────────────────────────────────────

/// Carried in every push notification's `data` map.
/// The router / screens listen to this to perform deep navigation.
class NotificationPayload {
  final String type;   // 'booking' | 'ride_request' | 'chat' | 'general'
  final String? id;    // related entity id (bookingId, requestId, …)
  final String? extra; // arbitrary extra string

  const NotificationPayload({
    required this.type,
    this.id,
    this.extra,
  });

  factory NotificationPayload.fromMap(Map<String, dynamic> map) {
    return NotificationPayload(
      type:  map['type']  as String? ?? 'general',
      id:    map['id']    as String?,
      extra: map['extra'] as String?,
    );
  }

  @override
  String toString() => 'NotificationPayload(type: $type, id: $id)';
}

// ── Riverpod provider for the latest tapped notification ─────────────────────

final notificationTapProvider =
    StateProvider<NotificationPayload?>((ref) => null);

// ── Local notifications channel setup ─────────────────────────────────────────

const _androidChannelId   = 'hikingspot_high';
const _androidChannelName = 'HikingSpot Alerts';
const _androidChannelDesc = 'Trip, booking and chat notifications';

final FlutterLocalNotificationsPlugin _localNotifs =
    FlutterLocalNotificationsPlugin();

// ── Firebase Service ──────────────────────────────────────────────────────────

class FirebaseService {
  FirebaseService._();

  static final FirebaseMessaging   _fcm       = FirebaseMessaging.instance;
  static final FirebaseAnalytics   _analytics = FirebaseAnalytics.instance;
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  // Injected after init so service can update the tap provider
  static ProviderContainer? _container;

  // ── Initialise everything ────────────────────────────────────────────────

  static Future<void> init(ProviderContainer container) async {
    _container = container;

    await _initCrashlytics();
    await _initLocalNotifications();
    await _initFCM();
  }

  // ── Crashlytics ──────────────────────────────────────────────────────────

  static Future<void> _initCrashlytics() async {
    // Pass Flutter errors to Crashlytics
    FlutterError.onError = _crashlytics.recordFlutterFatalError;

    // Pass async / platform errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };

    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);
  }

  /// Call after successful login so crash reports are attributed to the user.
  static Future<void> setUser(String userId, String email) async {
    await _crashlytics.setUserIdentifier(userId);
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(name: 'email_domain',
        value: email.contains('@') ? email.split('@').last : 'unknown');
  }

  /// Clear user identity on logout.
  static Future<void> clearUser() async {
    await _crashlytics.setUserIdentifier('');
    await _analytics.setUserId(id: null);
  }

  /// Record a non-fatal error (call from catch blocks you want tracked).
  static void recordError(Object error, StackTrace? stack,
      {String? reason, bool fatal = false}) {
    _crashlytics.recordError(error, stack, reason: reason, fatal: fatal);
  }

  // ── Local Notifications ──────────────────────────────────────────────────

  static Future<void> _initLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios     = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifs.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: _onLocalNotifTap,
    );

    // Create high-importance Android channel
    await _localNotifs
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _androidChannelId,
            _androidChannelName,
            description: _androidChannelDesc,
            importance: Importance.high,
          ),
        );
  }

  static void _onLocalNotifTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final map  = jsonDecode(payload) as Map<String, dynamic>;
      final data = NotificationPayload.fromMap(map);
      _container?.read(notificationTapProvider.notifier).state = data;
    } catch (_) {}
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    final android = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final ios = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifs.show(
      message.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(android: android, iOS: ios),
      payload: jsonEncode(message.data),
    );
  }

  // ── FCM ──────────────────────────────────────────────────────────────────

  static Future<void> _initFCM() async {
    // Request permission (iOS / web)
    await _fcm.requestPermission(
      alert:       true,
      badge:       true,
      sound:       true,
      provisional: false,
    );

    // Tell FCM which channel to use on Android for high-priority messages
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ── Handlers ──────────────────────────────────────────────────────────

    // Foreground: show a local notification ourselves
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('[FCM Foreground] ${message.data}');
      _showLocalNotification(message);
    });

    // App opened from background notification tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // App launched from terminated state via notification tap
    final initial = await _fcm.getInitialMessage();
    if (initial != null) _handleMessageTap(initial);

    // Background handler (registered at app startup in main.dart)
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static void _handleMessageTap(RemoteMessage message) {
    if (message.data.isEmpty) return;
    final payload = NotificationPayload.fromMap(
        Map<String, dynamic>.from(message.data));
    debugPrint('[FCM Tap] $payload');
    _container?.read(notificationTapProvider.notifier).state = payload;
  }

  // ── Token helpers ─────────────────────────────────────────────────────────

  /// Returns the current FCM token. May be null if permission denied.
  static Future<String?> getToken() => _fcm.getToken();

  /// Listen for token refreshes — caller should re-register with backend.
  static Stream<String> get onTokenRefresh => _fcm.onTokenRefresh;

  // ── Analytics helpers ────────────────────────────────────────────────────

  static Future<void> logLogin(String method) =>
      _analytics.logLogin(loginMethod: method);

  static Future<void> logSignUp(String method) =>
      _analytics.logSignUp(signUpMethod: method);

  static Future<void> logTripSearch({
    required String from,
    required String to,
  }) =>
      _analytics.logSearch(searchTerm: '$from → $to');

 static Future<void> logTripView(int tripId, String route) =>
    _analytics.logViewItem(
      items: [
        AnalyticsEventItem(
          itemId: tripId.toString(),
          itemName: route,
          itemCategory: 'trip',
        ),
      ],
    );
  static Future<void> logBookingCreated(int tripId) =>
      _analytics.logEvent(
        name: 'booking_created',
        parameters: {'trip_id': tripId},
      );

  static Future<void> logRideRequestPosted() =>
      _analytics.logEvent(name: 'ride_request_posted');

  static Future<void> logScreen(String screenName) =>
      _analytics.logScreenView(screenName: screenName);
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// Convenience provider so widgets can access the service if needed.
final firebaseServiceProvider = Provider<FirebaseService>((_) {
  throw StateError('FirebaseService not initialised — call FirebaseService.init() first');
});
