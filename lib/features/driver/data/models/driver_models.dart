// lib/features/driver/data/models/driver_models.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_models.freezed.dart';
part 'driver_models.g.dart';

@freezed
class DriverProfileRequest with _$DriverProfileRequest {
  const factory DriverProfileRequest({
    required String vehicleMake,
    required String vehicleModel,
    required String registration,
    required int seatCapacity,
  }) = _DriverProfileRequest;

  factory DriverProfileRequest.fromJson(Map<String, dynamic> json) => _$DriverProfileRequestFromJson(json);
}

@freezed
class DriverResponse with _$DriverResponse {
  const factory DriverResponse({
    required int driverProfileId,
    required String userId,
    required String fullName,
    required String vehicleMake,
    required String vehicleModel,
    required String vehicleRegistration,
    required int seatCapacity,
    required double rating,
    required int totalRatings,
    required bool isVerified,
  }) = _DriverResponse;

  factory DriverResponse.fromJson(Map<String, dynamic> json) => _$DriverResponseFromJson(json);
}
