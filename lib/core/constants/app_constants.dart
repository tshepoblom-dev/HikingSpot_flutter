// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // ── API ───────────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://hikingspot.ipzoticluxury.co.za';
  static const String devUrl  = 'https://hikingspot.ipzoticluxury.co.za';
  static const String hubUrl  = '$devUrl/chatHub';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ── Storage Keys ──────────────────────────────────────────────────────────
  static const String accessTokenKey = 'hs_access_token';
  static const String userIdKey      = 'hs_user_id';
  static const String userNameKey    = 'hs_user_name';
  static const String userEmailKey   = 'hs_user_email';
  static const String userRolesKey   = 'hs_user_roles';
  static const String tokenExpiryKey = 'hs_token_expiry';
  static const String themeKey       = 'hs_theme';

  // ── Pagination ────────────────────────────────────────────────────────────
  static const int defaultPageSize = 20;

  // ── Booking ───────────────────────────────────────────────────────────────
  static const int reservationWindowMinutes = 10;

  // ── Roles ─────────────────────────────────────────────────────────────────
  static const String roleDriver    = 'Driver';
  static const String rolePassenger = 'Passenger';
  static const String roleAdmin     = 'Admin';
}
