// lib/features/auth/presentation/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/firebase/firebase_service.dart';
import '../../../../core/signalr/app_hub_service.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../notifications/data/datasources/notifications_api_service.dart';
import '../../data/datasources/auth_api_service.dart';
import '../../data/models/auth_models.dart';

part 'auth_provider.g.dart';

// ── Auth State Notifier ───────────────────────────────────────────────────────

@riverpod
class AuthState extends _$AuthState {
  @override
  Future<AuthStateModel> build() async {
    return _restoreSession();
  }

  Future<AuthStateModel> _restoreSession() async {
    final storage = ref.read(localStorageProvider);
    final isValid = await storage.isTokenValid();
    if (!isValid) {
      await storage.clearAll();
      return const AuthStateModel(isAuthenticated: false);
    }

    final data  = await storage.getUserData();
    final token = await storage.getToken();
    if (data == null || token == null) {
      return const AuthStateModel(isAuthenticated: false);
    }

    final model = AuthStateModel(
      isAuthenticated: true,
      authResponse: AuthResponse(
        token:     token,
        userId:    data['userId'] as String,
        fullName:  data['fullName'] as String,
        email:     data['email'] as String,
        roles:     List<String>.from(data['roles'] as List),
        expiresAt: DateTime.tryParse(data['expiresAt'] as String) ?? DateTime.now(),
      ),
    );

    await _setFirebaseUser(model);
    await _registerFcmToken();

    // Connect the app-level SignalR hub so real-time events start flowing.
    _connectHub();

    return model;
  }

  // ── Login ────────────────────────────────────────────────────────────────

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api      = ref.read(authApiServiceProvider);
      final storage  = ref.read(localStorageProvider);
      final request  = LoginRequest(email: email, password: password);
      final response = await api.login(request);

      await storage.saveToken(response.token);
      await storage.saveUserData(
        userId:    response.userId,
        fullName:  response.fullName,
        email:     response.email,
        roles:     response.roles,
        expiresAt: response.expiresAt,
      );

      final model = AuthStateModel(isAuthenticated: true, authResponse: response);

      await _setFirebaseUser(model);
      await _registerFcmToken();
      FirebaseService.logLogin('email');

      // Connect hub after a successful login so events start flowing.
      _connectHub();

      return model;
    });
  }

  // ── Register ─────────────────────────────────────────────────────────────

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api      = ref.read(authApiServiceProvider);
      final storage  = ref.read(localStorageProvider);
      final request  = RegisterRequest(
          fullName: fullName, email: email, password: password, role: role);
      final response = await api.register(request);

      await storage.saveToken(response.token);
      await storage.saveUserData(
        userId:    response.userId,
        fullName:  response.fullName,
        email:     response.email,
        roles:     response.roles,
        expiresAt: response.expiresAt,
      );

      final model = AuthStateModel(isAuthenticated: true, authResponse: response);

      await _setFirebaseUser(model);
      await _registerFcmToken();
      FirebaseService.logSignUp('email');

      // Connect hub after a successful registration.
      _connectHub();

      return model;
    });
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    // Disconnect the hub before clearing credentials so any in-flight
    // reconnect attempts don't pick up a stale token.
    await ref.read(appHubServiceProvider.notifier).disconnect();

    await _unregisterFcmToken();
    await FirebaseService.clearUser();

    await ref.read(localStorageProvider).clearAll();
    state = const AsyncData(AuthStateModel(isAuthenticated: false));
  }

  // ── Hub helper ────────────────────────────────────────────────────────────

  /// Fire-and-forget hub connect. Errors are handled inside AppHubService.
  void _connectHub() {
    ref.read(appHubServiceProvider.notifier).connect().ignore();
  }

  // ── Firebase helpers ──────────────────────────────────────────────────────

  Future<void> _setFirebaseUser(AuthStateModel model) async {
    if (model.authResponse == null) return;
    try {
      await FirebaseService.setUser(
        model.authResponse!.userId,
        model.authResponse!.email,
      );
    } catch (e) {
      debugPrint('[Auth] setFirebaseUser failed: $e');
    }
  }

  Future<void> _registerFcmToken() async {
    try {
      final token = await FirebaseService.getToken();
      if (token == null) return;

      await ref
          .read(notificationsApiServiceProvider)
          .registerFcmToken(token);

      FirebaseService.onTokenRefresh.listen((newToken) {
        ref
            .read(notificationsApiServiceProvider)
            .registerFcmToken(newToken)
            .ignore();
      });
    } catch (e) {
      debugPrint('[Auth] FCM token registration failed: $e');
    }
  }

  Future<void> _unregisterFcmToken() async {
    try {
      final token = await FirebaseService.getToken();
      if (token == null) return;
      await ref
          .read(notificationsApiServiceProvider)
          .unregisterFcmToken(token);
    } catch (e) {
      debugPrint('[Auth] FCM token unregister failed: $e');
    }
  }
}

// ── Model ─────────────────────────────────────────────────────────────────────

class AuthStateModel {
  final bool isAuthenticated;
  final AuthResponse? authResponse;

  const AuthStateModel({
    required this.isAuthenticated,
    this.authResponse,
  });

  bool get isDriver    => authResponse?.roles.contains('Driver')    ?? false;
  bool get isPassenger => authResponse?.roles.contains('Passenger') ?? false;
  bool get isAdmin     => authResponse?.roles.contains('Admin')     ?? false;
  String get userId    => authResponse?.userId   ?? '';
  String get fullName  => authResponse?.fullName ?? '';
  String get token     => authResponse?.token    ?? '';
}
