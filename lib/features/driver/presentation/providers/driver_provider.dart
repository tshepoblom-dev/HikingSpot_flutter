// lib/features/driver/presentation/providers/driver_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/driver_api_service.dart';
import '../../data/models/driver_models.dart';

part 'driver_provider.g.dart';

@riverpod
Future<DriverResponse?> myDriverProfile(MyDriverProfileRef ref) =>
    ref.read(driverApiServiceProvider).getMyProfile();

@riverpod
Future<DriverResponse> publicDriverProfile(PublicDriverProfileRef ref, int driverProfileId) =>
    ref.read(driverApiServiceProvider).getDriverById(driverProfileId);

@riverpod
class DriverProfileVM extends _$DriverProfileVM {
  @override
  AsyncValue<DriverResponse?> build() => const AsyncData(null);

  Future<DriverResponse?> createProfile(DriverProfileRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(driverApiServiceProvider).createProfile(request));
    return state.valueOrNull;
  }

  Future<DriverResponse?> updateProfile(DriverProfileRequest request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(driverApiServiceProvider).updateProfile(request));
    ref.invalidate(myDriverProfileProvider);
    return state.valueOrNull;
  }
}

// ── lib/features/notifications/presentation/providers/notifications_provider.dart ──

