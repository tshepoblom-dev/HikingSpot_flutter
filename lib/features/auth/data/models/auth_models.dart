// lib/features/auth/data/models/auth_models.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

// ── Login Request ─────────────────────────────────────────────────────────────

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);
}

// ── Register Request ──────────────────────────────────────────────────────────

@freezed
class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String fullName,
    required String email,
    required String password,
    @Default('Passenger') String role,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);
}

// ── Auth Response ─────────────────────────────────────────────────────────────

@freezed
class AuthResponse with _$AuthResponse {
  const factory AuthResponse({
    required String token,
    required String userId,
    required String fullName,
    required String email,
    required List<String> roles,
    required DateTime expiresAt,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
}

// ── Auth State ────────────────────────────────────────────────────────────────

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    AuthResponse? authResponse,
  }) = _AuthState;

  const AuthState._();

  bool get isDriver    => authResponse?.roles.contains('Driver')    ?? false;
  bool get isPassenger => authResponse?.roles.contains('Passenger') ?? false;
  bool get isAdmin     => authResponse?.roles.contains('Admin')     ?? false;
  String get userId    => authResponse?.userId    ?? '';
  String get fullName  => authResponse?.fullName  ?? '';
  String get email     => authResponse?.email     ?? '';
  String get token     => authResponse?.token     ?? '';
}
