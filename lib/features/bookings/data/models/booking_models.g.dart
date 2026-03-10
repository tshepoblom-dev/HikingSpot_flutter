// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingRequestImpl _$$BookingRequestImplFromJson(Map<String, dynamic> json) =>
    _$BookingRequestImpl(
      tripId: (json['tripId'] as num).toInt(),
      seatsRequested: (json['seatsRequested'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$BookingRequestImplToJson(
        _$BookingRequestImpl instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'seatsRequested': instance.seatsRequested,
    };

_$BookingResponseImpl _$$BookingResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$BookingResponseImpl(
      bookingId: (json['bookingId'] as num).toInt(),
      tripId: (json['tripId'] as num).toInt(),
      passengerName: json['passengerName'] as String,
      departureCity: json['departureCity'] as String,
      destinationCity: json['destinationCity'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      seatsRequested: (json['seatsRequested'] as num).toInt(),
      status: const BookingStatusConverter().fromJson(json['status'] as String),
      requestedAt: DateTime.parse(json['requestedAt'] as String),
    );

Map<String, dynamic> _$$BookingResponseImplToJson(
        _$BookingResponseImpl instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'tripId': instance.tripId,
      'passengerName': instance.passengerName,
      'departureCity': instance.departureCity,
      'destinationCity': instance.destinationCity,
      'departureTime': instance.departureTime.toIso8601String(),
      'seatsRequested': instance.seatsRequested,
      'status': const BookingStatusConverter().toJson(instance.status),
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
