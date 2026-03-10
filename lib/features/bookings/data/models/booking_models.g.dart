// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingRequestImpl _$$BookingRequestImplFromJson(Map<String, dynamic> json) =>
    _$BookingRequestImpl(
      tripId: (json['tripId'] as num).toInt(),
      seatsRequested: (json['seatsRequested'] as num?)?.toInt() ?? 1,
      paymentMethod: (json['paymentMethod'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$BookingRequestImplToJson(
        _$BookingRequestImpl instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'seatsRequested': instance.seatsRequested,
      'paymentMethod': instance.paymentMethod,
    };

_$BookingResponseImpl _$$BookingResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingResponseImpl(
      bookingId: (json['bookingId'] as num).toInt(),
      tripId: (json['tripId'] as num).toInt(),
      passengerId: json['passengerId'] as String? ?? '',
      passengerName: json['passengerName'] as String,
      departureCity: json['departureCity'] as String,
      destinationCity: json['destinationCity'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      seatsRequested: (json['seatsRequested'] as num).toInt(),
      status: const BookingStatusConverter().fromJson(json['status'] as String),
      paymentMethod: (json['paymentMethod'] as num?)?.toInt() ?? 0,
      commissionCharged: json['commissionCharged'] as bool? ?? false,
      requestedAt: DateTime.parse(json['requestedAt'] as String),
    );

Map<String, dynamic> _$$BookingResponseImplToJson(
        _$BookingResponseImpl instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'tripId': instance.tripId,
      'passengerId': instance.passengerId,
      'passengerName': instance.passengerName,
      'departureCity': instance.departureCity,
      'destinationCity': instance.destinationCity,
      'departureTime': instance.departureTime.toIso8601String(),
      'seatsRequested': instance.seatsRequested,
      'status': const BookingStatusConverter().toJson(instance.status),
      'paymentMethod': instance.paymentMethod,
      'commissionCharged': instance.commissionCharged,
      'requestedAt': instance.requestedAt.toIso8601String(),
    };

_$BookingActionImpl _$$BookingActionImplFromJson(Map<String, dynamic> json) =>
    _$BookingActionImpl(
      bookingId: (json['bookingId'] as num).toInt(),
    );

Map<String, dynamic> _$$BookingActionImplToJson(_$BookingActionImpl instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
    };
