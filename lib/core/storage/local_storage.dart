// lib/core/storage/local_storage.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

part 'local_storage.g.dart';

@riverpod
LocalStorage localStorage(LocalStorageRef ref) => LocalStorage();

class LocalStorage {
  static const _secure = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ── Token ──────────────────────────────────────────────────────────────────

  Future<void> saveToken(String token) =>
      _secure.write(key: AppConstants.accessTokenKey, value: token);

  Future<String?> getToken() =>
      _secure.read(key: AppConstants.accessTokenKey);

  Future<void> deleteToken() =>
      _secure.delete(key: AppConstants.accessTokenKey);

  // ── User ───────────────────────────────────────────────────────────────────

  Future<void> saveUserData({
    required String userId,
    required String fullName,
    required String email,
    required List<String> roles,
    required DateTime expiresAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.userIdKey,    userId);
    await prefs.setString(AppConstants.userNameKey,  fullName);
    await prefs.setString(AppConstants.userEmailKey, email);
    await prefs.setStringList(AppConstants.userRolesKey, roles);
    await prefs.setString(AppConstants.tokenExpiryKey, expiresAt.toIso8601String());
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(AppConstants.userIdKey);
    if (userId == null) return null;

    return {
      'userId':   userId,
      'fullName': prefs.getString(AppConstants.userNameKey)  ?? '',
      'email':    prefs.getString(AppConstants.userEmailKey) ?? '',
      'roles':    prefs.getStringList(AppConstants.userRolesKey) ?? [],
      'expiresAt':prefs.getString(AppConstants.tokenExpiryKey) ?? '',
    };
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _secure.deleteAll();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Future<bool> isTokenValid() async {
    final token   = await getToken();
    if (token == null) return false;
    final prefs   = await SharedPreferences.getInstance();
    final expiry  = prefs.getString(AppConstants.tokenExpiryKey);
    if (expiry == null) return false;
    final expires = DateTime.tryParse(expiry);
    return expires != null && expires.isAfter(DateTime.now());
  }
}
