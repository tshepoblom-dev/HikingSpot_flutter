// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripResponseImpl _$$TripResponseImplFromJson(Map<String, dynamic> json) =>
    _$TripResponseImpl(
      tripId: (json['tripId'] as num).toInt(),
      driverName: json['driverName'] as String,
      driverId: json['driverId'] as String,
      vehicle: json['vehicle'] as String,
      departureCity: json['departureCity'] as String,
      destinationCity: json['destinationCity'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
      availableSeats: (json['availableSeats'] as num).toInt(),
      driverRating: (json['driverRating'] as num).toDouble(),
      pickupLocation: json['pickupLocation'] as String,
      pickupLatitude: (json['pickupLatitude'] as num?)?.toDouble() ?? 0.0,
      pickupLongitude: (json['pickupLongitude'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] == null
          ? TripStatus.scheduled
          : const TripStatusConverter().fromJson(json['status'] as String),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TripResponseImplToJson(_$TripResponseImpl instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'driverName': instance.driverName,
      'driverId': instance.driverId,
      'vehicle': instance.vehicle,
      'departureCity': instance.departureCity,
      'destinationCity': instance.destinationCity,
      'departureTime': instance.departureTime.toIso8601String(),
      'pricePerSeat': instance.pricePerSeat,
      'availableSeats': instance.availableSeats,
      'driverRating': instance.driverRating,
      'pickupLocation': instance.pickupLocation,
      'pickupLatitude': instance.pickupLatitude,
      'pickupLongitude': instance.pickupLongitude,
      'status': const TripStatusConverter().toJson(instance.status),
      'distanceKm': instance.distanceKm,
    };

_$TripCreateRequestImpl _$$TripCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$TripCreateRequestImpl(
      departureCity: json['departureCity'] as String,
      destinationCity: json['destinationCity'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      seats: (json['seats'] as num).toInt(),
      pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
      pickupLocation: json['pickupLocation'] as String? ?? '',
      pickupLatitude: (json['pickupLatitude'] as num?)?.toDouble() ?? 0.0,
      pickupLongitude: (json['pickupLongitude'] as num?)?.toDouble() ?? 0.0,
      destinationLatitude:
          (json['destinationLatitude'] as num?)?.toDouble() ?? 0.0,
      destinationLongitude:
          (json['destinationLongitude'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$TripCreateRequestImplToJson(
        _$TripCreateRequestImpl instance) =>
    <String, dynamic>{
      'departureCity': instance.departureCity,
      'destinationCity': instance.destinationCity,
      'departureTime': instance.departureTime.toIso8601String(),
      'seats': instance.seats,
      'pricePerSeat': instance.pricePerSeat,
      'pickupLocation': instance.pickupLocation,
      'pickupLatitude': instance.pickupLatitude,
      'pickupLongitude': instance.pickupLongitude,
      'destinationLatitude': instance.destinationLatitude,
      'destinationLongitude': instance.destinationLongitude,
    };

_$TripSearchParamsImpl _$$TripSearchParamsImplFromJson(
        Map<String, dynamic> json) =>
    _$TripSearchParamsImpl(
      from: json['from'] as String? ?? '',
      to: json['to'] as String? ?? '',
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      radiusKm: (json['radiusKm'] as num?)?.toDouble() ?? 50.0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
      seatsNeeded: (json['seatsNeeded'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$TripSearchParamsImplToJson(
        _$TripSearchParamsImpl instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'date': instance.date?.toIso8601String(),
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusKm': instance.radiusKm,
      'page': instance.page,
      'pageSize': instance.pageSize,
      'seatsNeeded': instance.seatsNeeded,
    };
