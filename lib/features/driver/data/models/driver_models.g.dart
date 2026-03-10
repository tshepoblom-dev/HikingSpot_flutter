// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DriverProfileRequestImpl _$$DriverProfileRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$DriverProfileRequestImpl(
      vehicleMake: json['vehicleMake'] as String,
      vehicleModel: json['vehicleModel'] as String,
      registration: json['registration'] as String,
      seatCapacity: (json['seatCapacity'] as num).toInt(),
    );

Map<String, dynamic> _$$DriverProfileRequestImplToJson(
        _$DriverProfileRequestImpl instance) =>
    <String, dynamic>{
      'vehicleMake': instance.vehicleMake,
      'vehicleModel': instance.vehicleModel,
      'registration': instance.registration,
      'seatCapacity': instance.seatCapacity,
    };

_$DriverResponseImpl _$$DriverResponseImplFromJson(Map<String, dynamic> json) =>
    _$DriverResponseImpl(
      driverProfileId: (json['driverProfileId'] as num).toInt(),
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      vehicleMake: json['vehicleMake'] as String,
      vehicleModel: json['vehicleModel'] as String,
      vehicleRegistration: json['vehicleRegistration'] as String,
      seatCapacity: (json['seatCapacity'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      totalRatings: (json['totalRatings'] as num).toInt(),
      isVerified: json['isVerified'] as bool,
    );

Map<String, dynamic> _$$DriverResponseImplToJson(
        _$DriverResponseImpl instance) =>
    <String, dynamic>{
      'driverProfileId': instance.driverProfileId,
      'userId': instance.userId,
      'fullName': instance.fullName,
      'vehicleMake': instance.vehicleMake,
      'vehicleModel': instance.vehicleModel,
      'vehicleRegistration': instance.vehicleRegistration,
      'seatCapacity': instance.seatCapacity,
      'rating': instance.rating,
      'totalRatings': instance.totalRatings,
      'isVerified': instance.isVerified,
    };
