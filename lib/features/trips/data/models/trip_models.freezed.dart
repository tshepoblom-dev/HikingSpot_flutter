// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TripResponse _$TripResponseFromJson(Map<String, dynamic> json) {
  return _TripResponse.fromJson(json);
}

/// @nodoc
mixin _$TripResponse {
  int get tripId => throw _privateConstructorUsedError;
  String get driverName => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  String get vehicle => throw _privateConstructorUsedError;
  String get departureCity => throw _privateConstructorUsedError;
  String get destinationCity => throw _privateConstructorUsedError;
  DateTime get departureTime => throw _privateConstructorUsedError;
  double get pricePerSeat => throw _privateConstructorUsedError;
  int get availableSeats => throw _privateConstructorUsedError;
  double get driverRating => throw _privateConstructorUsedError;
  String get pickupLocation => throw _privateConstructorUsedError;
  double get pickupLatitude => throw _privateConstructorUsedError;
  double get pickupLongitude => throw _privateConstructorUsedError;
  @TripStatusConverter()
  TripStatus get status => throw _privateConstructorUsedError;
  double? get distanceKm => throw _privateConstructorUsedError;

  /// Serializes this TripResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripResponseCopyWith<TripResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripResponseCopyWith<$Res> {
  factory $TripResponseCopyWith(
          TripResponse value, $Res Function(TripResponse) then) =
      _$TripResponseCopyWithImpl<$Res, TripResponse>;
  @useResult
  $Res call(
      {int tripId,
      String driverName,
      String driverId,
      String vehicle,
      String departureCity,
      String destinationCity,
      DateTime departureTime,
      double pricePerSeat,
      int availableSeats,
      double driverRating,
      String pickupLocation,
      double pickupLatitude,
      double pickupLongitude,
      @TripStatusConverter() TripStatus status,
      double? distanceKm});
}

/// @nodoc
class _$TripResponseCopyWithImpl<$Res, $Val extends TripResponse>
    implements $TripResponseCopyWith<$Res> {
  _$TripResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? driverName = null,
    Object? driverId = null,
    Object? vehicle = null,
    Object? departureCity = null,
    Object? destinationCity = null,
    Object? departureTime = null,
    Object? pricePerSeat = null,
    Object? availableSeats = null,
    Object? driverRating = null,
    Object? pickupLocation = null,
    Object? pickupLatitude = null,
    Object? pickupLongitude = null,
    Object? status = null,
    Object? distanceKm = freezed,
  }) {
    return _then(_value.copyWith(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as int,
      driverName: null == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicle: null == vehicle
          ? _value.vehicle
          : vehicle // ignore: cast_nullable_to_non_nullable
              as String,
      departureCity: null == departureCity
          ? _value.departureCity
          : departureCity // ignore: cast_nullable_to_non_nullable
              as String,
      destinationCity: null == destinationCity
          ? _value.destinationCity
          : destinationCity // ignore: cast_nullable_to_non_nullable
              as String,
      departureTime: null == departureTime
          ? _value.departureTime
          : departureTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pricePerSeat: null == pricePerSeat
          ? _value.pricePerSeat
          : pricePerSeat // ignore: cast_nullable_to_non_nullable
              as double,
      availableSeats: null == availableSeats
          ? _value.availableSeats
          : availableSeats // ignore: cast_nullable_to_non_nullable
              as int,
      driverRating: null == driverRating
          ? _value.driverRating
          : driverRating // ignore: cast_nullable_to_non_nullable
              as double,
      pickupLocation: null == pickupLocation
          ? _value.pickupLocation
          : pickupLocation // ignore: cast_nullable_to_non_nullable
              as String,
      pickupLatitude: null == pickupLatitude
          ? _value.pickupLatitude
          : pickupLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      pickupLongitude: null == pickupLongitude
          ? _value.pickupLongitude
          : pickupLongitude // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TripStatus,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripResponseImplCopyWith<$Res>
    implements $TripResponseCopyWith<$Res> {
  factory _$$TripResponseImplCopyWith(
          _$TripResponseImpl value, $Res Function(_$TripResponseImpl) then) =
      __$$TripResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int tripId,
      String driverName,
      String driverId,
      String vehicle,
      String departureCity,
      String destinationCity,
      DateTime departureTime,
      double pricePerSeat,
      int availableSeats,
      double driverRating,
      String pickupLocation,
      double pickupLatitude,
      double pickupLongitude,
      @TripStatusConverter() TripStatus status,
      double? distanceKm});
}

/// @nodoc
class __$$TripResponseImplCopyWithImpl<$Res>
    extends _$TripResponseCopyWithImpl<$Res, _$TripResponseImpl>
    implements _$$TripResponseImplCopyWith<$Res> {
  __$$TripResponseImplCopyWithImpl(
      _$TripResponseImpl _value, $Res Function(_$TripResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? driverName = null,
    Object? driverId = null,
    Object? vehicle = null,
    Object? departureCity = null,
    Object? destinationCity = null,
    Object? departureTime = null,
    Object? pricePerSeat = null,
    Object? availableSeats = null,
    Object? driverRating = null,
    Object? pickupLocation = null,
    Object? pickupLatitude = null,
    Object? pickupLongitude = null,
    Object? status = null,
    Object? distanceKm = freezed,
  }) {
    return _then(_$TripResponseImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as int,
      driverName: null == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      vehicle: null == vehicle
          ? _value.vehicle
          : vehicle // ignore: cast_nullable_to_non_nullable
              as String,
      departureCity: null == departureCity
          ? _value.departureCity
          : departureCity // ignore: cast_nullable_to_non_nullable
              as String,
      destinationCity: null == destinationCity
          ? _value.destinationCity
          : destinationCity // ignore: cast_nullable_to_non_nullable
              as String,
      departureTime: null == departureTime
          ? _value.departureTime
          : departureTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      pricePerSeat: null == pricePerSeat
          ? _value.pricePerSeat
          : pricePerSeat // ignore: cast_nullable_to_non_nullable
              as double,
      availableSeats: null == availableSeats
          ? _value.availableSeats
          : availableSeats // ignore: cast_nullable_to_non_nullable
              as int,
      driverRating: null == driverRating
          ? _value.driverRating
          : driverRating // ignore: cast_nullable_to_non_nullable
              as double,
      pickupLocation: null == pickupLocation
          ? _value.pickupLocation
          : pickupLocation // ignore: cast_nullable_to_non_nullable
              as String,
      pickupLatitude: null == pickupLatitude
          ? _value.pickupLatitude
          : pickupLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      pickupLongitude: null == pickupLongitude
          ? _value.pickupLongitude
          : pickupLongitude // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TripStatus,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripResponseImpl implements _TripResponse {
  const _$TripResponseImpl(
      {required this.tripId,
      required this.driverName,
      required this.driverId,
      required this.vehicle,
      required this.departureCity,
      required this.destinationCity,
      required this.departureTime,
      required this.pricePerSeat,
      required this.availableSeats,
      required this.driverRating,
      required this.pickupLocation,
      this.pickupLatitude = 0.0,
      this.pickupLongitude = 0.0,
      @TripStatusConverter() this.status = TripStatus.scheduled,
      this.distanceKm});

  factory _$TripResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripResponseImplFromJson(json);

  @override
  final int tripId;
  @override
  final String driverName;
  @override
  final String driverId;
  @override
  final String vehicle;
  @override
  final String departureCity;
  @override
  final String destinationCity;
  @override
  final DateTime departureTime;
  @override
  final double pricePerSeat;
  @override
  final int availableSeats;
  @override
  final double driverRating;
  @override
  final String pickupLocation;
  @override
  @JsonKey()
  final double pickupLatitude;
  @override
  @JsonKey()
  final double pickupLongitude;
  @override
  @JsonKey()
  @TripStatusConverter()
  final TripStatus status;
  @override
  final double? distanceKm;

  @override
  String toString() {
    return 'TripResponse(tripId: $tripId, driverName: $driverName, driverId: $driverId, vehicle: $vehicle, departureCity: $departureCity, destinationCity: $destinationCity, departureTime: $departureTime, pricePerSeat: $pricePerSeat, availableSeats: $availableSeats, driverRating: $driverRating, pickupLocation: $pickupLocation, pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, status: $status, distanceKm: $distanceKm)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripResponseImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.vehicle, vehicle) || other.vehicle == vehicle) &&
            (identical(other.departureCity, departureCity) ||
                other.departureCity == departureCity) &&
            (identical(other.destinationCity, destinationCity) ||
                other.destinationCity == destinationCity) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.pricePerSeat, pricePerSeat) ||
                other.pricePerSeat == pricePerSeat) &&
            (identical(other.availableSeats, availableSeats) ||
                other.availableSeats == availableSeats) &&
            (identical(other.driverRating, driverRating) ||
                other.driverRating == driverRating) &&
            (identical(other.pickupLocation, pickupLocation) ||
                other.pickupLocation == pickupLocation) &&
            (identical(other.pickupLatitude, pickupLatitude) ||
                other.pickupLatitude == pickupLatitude) &&
            (identical(other.pickupLongitude, pickupLongitude) ||
                other.pickupLongitude == pickupLongitude) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      tripId,
      driverName,
      driverId,
      vehicle,
      departureCity,
      destinationCity,
      departureTime,
      pricePerSeat,
      availableSeats,
      driverRating,
      pickupLocation,
      pickupLatitude,
      pickupLongitude,
      status,
      distanceKm);

  /// Create a copy of TripResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripResponseImplCopyWith<_$TripResponseImpl> get copyWith =>
      __$$TripResponseImplCopyWithImpl<_$TripResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripResponseImplToJson(
      this,
    );
  }
}

abstract class _TripResponse implements TripResponse {
  const factory _TripResponse(
      {required final int tripId,
      required final String driverName,
      required final String driverId,
      required final String vehicle,
      required final String departureCity,
      required final String destinationCity,
      required final DateTime departureTime,
      required final double pricePerSeat,
      required final int availableSeats,
      required final double driverRating,
      required final String pickupLocation,
      final double pickupLatitude,
      final double pickupLongitude,
      @TripStatusConverter() final TripStatus status,
      final double? distanceKm}) = _$TripResponseImpl;

  factory _TripResponse.fromJson(Map<String, dynamic> json) =
      _$TripResponseImpl.fromJson;

  @override
  int get tripId;
  @override
  String get driverName;
  @override
  String get driverId;
  @override
  String get vehicle;
  @override
  String get departureCity;
  @override
  String get destinationCity;
  @override
  DateTime get departureTime;
  @override
  double get pricePerSeat;
  @override
  int get availableSeats;
  @override
  double get driverRating;
  @override
  String get pickupLocation;
  @override
  double get pickupLatitude;
  @override
  double get pickupLongitude;
  @override
  @TripStatusConverter()
  TripStatus get status;
  @override
  double? get distanceKm;

  /// Create a copy of TripResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripResponseImplCopyWith<_$TripResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TripCreateRequest _$TripCreateRequestFromJson(Map<String, dynamic> json) {
  return _TripCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$TripCreateRequest {
  String get departureCity => throw _privateConstructorUsedError;
  String get destinationCity => throw _privateConstructorUsedError;
  DateTime get departureTime => throw _privateConstructorUsedError;
  int get seats => throw _privateConstructorUsedError;
  double get pricePerSeat => throw _privateConstructorUsedError;
  String get pickupLocation => throw _privateConstructorUsedError;
  double get pickupLatitude => throw _privateConstructorUsedError;
  double get pickupLongitude => throw _privateConstructorUsedError;
  double get destinationLatitude => throw _privateConstructorUsedError;
  double get destinationLongitude => throw _privateConstructorUsedError;

  /// Serializes this TripCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripCreateRequestCopyWith<TripCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCreateRequestCopyWith<$Res> {
  factory $TripCreateRequestCopyWith(
          TripCreateRequest value, $Res Function(TripCreateRequest) then) =
      _$TripCreateRequestCopyWithImpl<$Res, TripCreateRequest>;
  @useResult
  $Res call(
      {String departureCity,
      String destinationCity,
      DateTime departureTime,
      int seats,
      double pricePerSeat,
      String pickupLocation,
      double pickupLatitude,
      double pickupLongitude,
      double destinationLatitude,
      double destinationLongitude});
}

/// @nodoc
class _$TripCreateRequestCopyWithImpl<$Res, $Val extends TripCreateRequest>
    implements $TripCreateRequestCopyWith<$Res> {
  _$TripCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? departureCity = null,
    Object? destinationCity = null,
    Object? departureTime = null,
    Object? seats = null,
    Object? pricePerSeat = null,
    Object? pickupLocation = null,
    Object? pickupLatitude = null,
    Object? pickupLongitude = null,
    Object? destinationLatitude = null,
    Object? destinationLongitude = null,
  }) {
    return _then(_value.copyWith(
      departureCity: null == departureCity
          ? _value.departureCity
          : departureCity // ignore: cast_nullable_to_non_nullable
              as String,
      destinationCity: null == destinationCity
          ? _value.destinationCity
          : destinationCity // ignore: cast_nullable_to_non_nullable
              as String,
      departureTime: null == departureTime
          ? _value.departureTime
          : departureTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      seats: null == seats
          ? _value.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerSeat: null == pricePerSeat
          ? _value.pricePerSeat
          : pricePerSeat // ignore: cast_nullable_to_non_nullable
              as double,
      pickupLocation: null == pickupLocation
          ? _value.pickupLocation
          : pickupLocation // ignore: cast_nullable_to_non_nullable
              as String,
      pickupLatitude: null == pickupLatitude
          ? _value.pickupLatitude
          : pickupLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      pickupLongitude: null == pickupLongitude
          ? _value.pickupLongitude
          : pickupLongitude // ignore: cast_nullable_to_non_nullable
              as double,
      destinationLatitude: null == destinationLatitude
          ? _value.destinationLatitude
          : destinationLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      destinationLongitude: null == destinationLongitude
          ? _value.destinationLongitude
          : destinationLongitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripCreateRequestImplCopyWith<$Res>
    implements $TripCreateRequestCopyWith<$Res> {
  factory _$$TripCreateRequestImplCopyWith(_$TripCreateRequestImpl value,
          $Res Function(_$TripCreateRequestImpl) then) =
      __$$TripCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String departureCity,
      String destinationCity,
      DateTime departureTime,
      int seats,
      double pricePerSeat,
      String pickupLocation,
      double pickupLatitude,
      double pickupLongitude,
      double destinationLatitude,
      double destinationLongitude});
}

/// @nodoc
class __$$TripCreateRequestImplCopyWithImpl<$Res>
    extends _$TripCreateRequestCopyWithImpl<$Res, _$TripCreateRequestImpl>
    implements _$$TripCreateRequestImplCopyWith<$Res> {
  __$$TripCreateRequestImplCopyWithImpl(_$TripCreateRequestImpl _value,
      $Res Function(_$TripCreateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? departureCity = null,
    Object? destinationCity = null,
    Object? departureTime = null,
    Object? seats = null,
    Object? pricePerSeat = null,
    Object? pickupLocation = null,
    Object? pickupLatitude = null,
    Object? pickupLongitude = null,
    Object? destinationLatitude = null,
    Object? destinationLongitude = null,
  }) {
    return _then(_$TripCreateRequestImpl(
      departureCity: null == departureCity
          ? _value.departureCity
          : departureCity // ignore: cast_nullable_to_non_nullable
              as String,
      destinationCity: null == destinationCity
          ? _value.destinationCity
          : destinationCity // ignore: cast_nullable_to_non_nullable
              as String,
      departureTime: null == departureTime
          ? _value.departureTime
          : departureTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      seats: null == seats
          ? _value.seats
          : seats // ignore: cast_nullable_to_non_nullable
              as int,
      pricePerSeat: null == pricePerSeat
          ? _value.pricePerSeat
          : pricePerSeat // ignore: cast_nullable_to_non_nullable
              as double,
      pickupLocation: null == pickupLocation
          ? _value.pickupLocation
          : pickupLocation // ignore: cast_nullable_to_non_nullable
              as String,
      pickupLatitude: null == pickupLatitude
          ? _value.pickupLatitude
          : pickupLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      pickupLongitude: null == pickupLongitude
          ? _value.pickupLongitude
          : pickupLongitude // ignore: cast_nullable_to_non_nullable
              as double,
      destinationLatitude: null == destinationLatitude
          ? _value.destinationLatitude
          : destinationLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      destinationLongitude: null == destinationLongitude
          ? _value.destinationLongitude
          : destinationLongitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripCreateRequestImpl implements _TripCreateRequest {
  const _$TripCreateRequestImpl(
      {required this.departureCity,
      required this.destinationCity,
      required this.departureTime,
      required this.seats,
      required this.pricePerSeat,
      this.pickupLocation = '',
      this.pickupLatitude = 0.0,
      this.pickupLongitude = 0.0,
      this.destinationLatitude = 0.0,
      this.destinationLongitude = 0.0});

  factory _$TripCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripCreateRequestImplFromJson(json);

  @override
  final String departureCity;
  @override
  final String destinationCity;
  @override
  final DateTime departureTime;
  @override
  final int seats;
  @override
  final double pricePerSeat;
  @override
  @JsonKey()
  final String pickupLocation;
  @override
  @JsonKey()
  final double pickupLatitude;
  @override
  @JsonKey()
  final double pickupLongitude;
  @override
  @JsonKey()
  final double destinationLatitude;
  @override
  @JsonKey()
  final double destinationLongitude;

  @override
  String toString() {
    return 'TripCreateRequest(departureCity: $departureCity, destinationCity: $destinationCity, departureTime: $departureTime, seats: $seats, pricePerSeat: $pricePerSeat, pickupLocation: $pickupLocation, pickupLatitude: $pickupLatitude, pickupLongitude: $pickupLongitude, destinationLatitude: $destinationLatitude, destinationLongitude: $destinationLongitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripCreateRequestImpl &&
            (identical(other.departureCity, departureCity) ||
                other.departureCity == departureCity) &&
            (identical(other.destinationCity, destinationCity) ||
                other.destinationCity == destinationCity) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.seats, seats) || other.seats == seats) &&
            (identical(other.pricePerSeat, pricePerSeat) ||
                other.pricePerSeat == pricePerSeat) &&
            (identical(other.pickupLocation, pickupLocation) ||
                other.pickupLocation == pickupLocation) &&
            (identical(other.pickupLatitude, pickupLatitude) ||
                other.pickupLatitude == pickupLatitude) &&
            (identical(other.pickupLongitude, pickupLongitude) ||
                other.pickupLongitude == pickupLongitude) &&
            (identical(other.destinationLatitude, destinationLatitude) ||
                other.destinationLatitude == destinationLatitude) &&
            (identical(other.destinationLongitude, destinationLongitude) ||
                other.destinationLongitude == destinationLongitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      departureCity,
      destinationCity,
      departureTime,
      seats,
      pricePerSeat,
      pickupLocation,
      pickupLatitude,
      pickupLongitude,
      destinationLatitude,
      destinationLongitude);

  /// Create a copy of TripCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripCreateRequestImplCopyWith<_$TripCreateRequestImpl> get copyWith =>
      __$$TripCreateRequestImplCopyWithImpl<_$TripCreateRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _TripCreateRequest implements TripCreateRequest {
  const factory _TripCreateRequest(
      {required final String departureCity,
      required final String destinationCity,
      required final DateTime departureTime,
      required final int seats,
      required final double pricePerSeat,
      final String pickupLocation,
      final double pickupLatitude,
      final double pickupLongitude,
      final double destinationLatitude,
      final double destinationLongitude}) = _$TripCreateRequestImpl;

  factory _TripCreateRequest.fromJson(Map<String, dynamic> json) =
      _$TripCreateRequestImpl.fromJson;

  @override
  String get departureCity;
  @override
  String get destinationCity;
  @override
  DateTime get departureTime;
  @override
  int get seats;
  @override
  double get pricePerSeat;
  @override
  String get pickupLocation;
  @override
  double get pickupLatitude;
  @override
  double get pickupLongitude;
  @override
  double get destinationLatitude;
  @override
  double get destinationLongitude;

  /// Create a copy of TripCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripCreateRequestImplCopyWith<_$TripCreateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TripSearchParams _$TripSearchParamsFromJson(Map<String, dynamic> json) {
  return _TripSearchParams.fromJson(json);
}

/// @nodoc
mixin _$TripSearchParams {
  String get from => throw _privateConstructorUsedError;
  String get to => throw _privateConstructorUsedError;
  DateTime? get date => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  double get radiusKm => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get pageSize => throw _privateConstructorUsedError;
  int get seatsNeeded => throw _privateConstructorUsedError;

  /// Serializes this TripSearchParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripSearchParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripSearchParamsCopyWith<TripSearchParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripSearchParamsCopyWith<$Res> {
  factory $TripSearchParamsCopyWith(
          TripSearchParams value, $Res Function(TripSearchParams) then) =
      _$TripSearchParamsCopyWithImpl<$Res, TripSearchParams>;
  @useResult
  $Res call(
      {String from,
      String to,
      DateTime? date,
      double? latitude,
      double? longitude,
      double radiusKm,
      int page,
      int pageSize,
      int seatsNeeded});
}

/// @nodoc
class _$TripSearchParamsCopyWithImpl<$Res, $Val extends TripSearchParams>
    implements $TripSearchParamsCopyWith<$Res> {
  _$TripSearchParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripSearchParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? date = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? radiusKm = null,
    Object? page = null,
    Object? pageSize = null,
    Object? seatsNeeded = null,
  }) {
    return _then(_value.copyWith(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      radiusKm: null == radiusKm
          ? _value.radiusKm
          : radiusKm // ignore: cast_nullable_to_non_nullable
              as double,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      seatsNeeded: null == seatsNeeded
          ? _value.seatsNeeded
          : seatsNeeded // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TripSearchParamsImplCopyWith<$Res>
    implements $TripSearchParamsCopyWith<$Res> {
  factory _$$TripSearchParamsImplCopyWith(_$TripSearchParamsImpl value,
          $Res Function(_$TripSearchParamsImpl) then) =
      __$$TripSearchParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String from,
      String to,
      DateTime? date,
      double? latitude,
      double? longitude,
      double radiusKm,
      int page,
      int pageSize,
      int seatsNeeded});
}

/// @nodoc
class __$$TripSearchParamsImplCopyWithImpl<$Res>
    extends _$TripSearchParamsCopyWithImpl<$Res, _$TripSearchParamsImpl>
    implements _$$TripSearchParamsImplCopyWith<$Res> {
  __$$TripSearchParamsImplCopyWithImpl(_$TripSearchParamsImpl _value,
      $Res Function(_$TripSearchParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of TripSearchParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? date = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? radiusKm = null,
    Object? page = null,
    Object? pageSize = null,
    Object? seatsNeeded = null,
  }) {
    return _then(_$TripSearchParamsImpl(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as String,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      radiusKm: null == radiusKm
          ? _value.radiusKm
          : radiusKm // ignore: cast_nullable_to_non_nullable
              as double,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      pageSize: null == pageSize
          ? _value.pageSize
          : pageSize // ignore: cast_nullable_to_non_nullable
              as int,
      seatsNeeded: null == seatsNeeded
          ? _value.seatsNeeded
          : seatsNeeded // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TripSearchParamsImpl implements _TripSearchParams {
  const _$TripSearchParamsImpl(
      {this.from = '',
      this.to = '',
      this.date,
      this.latitude,
      this.longitude,
      this.radiusKm = 50.0,
      this.page = 1,
      this.pageSize = 20,
      this.seatsNeeded = 1});

  factory _$TripSearchParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripSearchParamsImplFromJson(json);

  @override
  @JsonKey()
  final String from;
  @override
  @JsonKey()
  final String to;
  @override
  final DateTime? date;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  @JsonKey()
  final double radiusKm;
  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int pageSize;
  @override
  @JsonKey()
  final int seatsNeeded;

  @override
  String toString() {
    return 'TripSearchParams(from: $from, to: $to, date: $date, latitude: $latitude, longitude: $longitude, radiusKm: $radiusKm, page: $page, pageSize: $pageSize, seatsNeeded: $seatsNeeded)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripSearchParamsImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.radiusKm, radiusKm) ||
                other.radiusKm == radiusKm) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.pageSize, pageSize) ||
                other.pageSize == pageSize) &&
            (identical(other.seatsNeeded, seatsNeeded) ||
                other.seatsNeeded == seatsNeeded));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, from, to, date, latitude,
      longitude, radiusKm, page, pageSize, seatsNeeded);

  /// Create a copy of TripSearchParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripSearchParamsImplCopyWith<_$TripSearchParamsImpl> get copyWith =>
      __$$TripSearchParamsImplCopyWithImpl<_$TripSearchParamsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripSearchParamsImplToJson(
      this,
    );
  }
}

abstract class _TripSearchParams implements TripSearchParams {
  const factory _TripSearchParams(
      {final String from,
      final String to,
      final DateTime? date,
      final double? latitude,
      final double? longitude,
      final double radiusKm,
      final int page,
      final int pageSize,
      final int seatsNeeded}) = _$TripSearchParamsImpl;

  factory _TripSearchParams.fromJson(Map<String, dynamic> json) =
      _$TripSearchParamsImpl.fromJson;

  @override
  String get from;
  @override
  String get to;
  @override
  DateTime? get date;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  double get radiusKm;
  @override
  int get page;
  @override
  int get pageSize;
  @override
  int get seatsNeeded;

  /// Create a copy of TripSearchParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripSearchParamsImplCopyWith<_$TripSearchParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
