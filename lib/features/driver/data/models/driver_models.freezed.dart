// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'driver_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DriverProfileRequest _$DriverProfileRequestFromJson(Map<String, dynamic> json) {
  return _DriverProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$DriverProfileRequest {
  String get vehicleMake => throw _privateConstructorUsedError;
  String get vehicleModel => throw _privateConstructorUsedError;
  String get registration => throw _privateConstructorUsedError;
  int get seatCapacity => throw _privateConstructorUsedError;

  /// Serializes this DriverProfileRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DriverProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DriverProfileRequestCopyWith<DriverProfileRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverProfileRequestCopyWith<$Res> {
  factory $DriverProfileRequestCopyWith(DriverProfileRequest value,
          $Res Function(DriverProfileRequest) then) =
      _$DriverProfileRequestCopyWithImpl<$Res, DriverProfileRequest>;
  @useResult
  $Res call(
      {String vehicleMake,
      String vehicleModel,
      String registration,
      int seatCapacity});
}

/// @nodoc
class _$DriverProfileRequestCopyWithImpl<$Res,
        $Val extends DriverProfileRequest>
    implements $DriverProfileRequestCopyWith<$Res> {
  _$DriverProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DriverProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleMake = null,
    Object? vehicleModel = null,
    Object? registration = null,
    Object? seatCapacity = null,
  }) {
    return _then(_value.copyWith(
      vehicleMake: null == vehicleMake
          ? _value.vehicleMake
          : vehicleMake // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleModel: null == vehicleModel
          ? _value.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String,
      registration: null == registration
          ? _value.registration
          : registration // ignore: cast_nullable_to_non_nullable
              as String,
      seatCapacity: null == seatCapacity
          ? _value.seatCapacity
          : seatCapacity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DriverProfileRequestImplCopyWith<$Res>
    implements $DriverProfileRequestCopyWith<$Res> {
  factory _$$DriverProfileRequestImplCopyWith(_$DriverProfileRequestImpl value,
          $Res Function(_$DriverProfileRequestImpl) then) =
      __$$DriverProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String vehicleMake,
      String vehicleModel,
      String registration,
      int seatCapacity});
}

/// @nodoc
class __$$DriverProfileRequestImplCopyWithImpl<$Res>
    extends _$DriverProfileRequestCopyWithImpl<$Res, _$DriverProfileRequestImpl>
    implements _$$DriverProfileRequestImplCopyWith<$Res> {
  __$$DriverProfileRequestImplCopyWithImpl(_$DriverProfileRequestImpl _value,
      $Res Function(_$DriverProfileRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of DriverProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? vehicleMake = null,
    Object? vehicleModel = null,
    Object? registration = null,
    Object? seatCapacity = null,
  }) {
    return _then(_$DriverProfileRequestImpl(
      vehicleMake: null == vehicleMake
          ? _value.vehicleMake
          : vehicleMake // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleModel: null == vehicleModel
          ? _value.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String,
      registration: null == registration
          ? _value.registration
          : registration // ignore: cast_nullable_to_non_nullable
              as String,
      seatCapacity: null == seatCapacity
          ? _value.seatCapacity
          : seatCapacity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DriverProfileRequestImpl implements _DriverProfileRequest {
  const _$DriverProfileRequestImpl(
      {required this.vehicleMake,
      required this.vehicleModel,
      required this.registration,
      required this.seatCapacity});

  factory _$DriverProfileRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverProfileRequestImplFromJson(json);

  @override
  final String vehicleMake;
  @override
  final String vehicleModel;
  @override
  final String registration;
  @override
  final int seatCapacity;

  @override
  String toString() {
    return 'DriverProfileRequest(vehicleMake: $vehicleMake, vehicleModel: $vehicleModel, registration: $registration, seatCapacity: $seatCapacity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverProfileRequestImpl &&
            (identical(other.vehicleMake, vehicleMake) ||
                other.vehicleMake == vehicleMake) &&
            (identical(other.vehicleModel, vehicleModel) ||
                other.vehicleModel == vehicleModel) &&
            (identical(other.registration, registration) ||
                other.registration == registration) &&
            (identical(other.seatCapacity, seatCapacity) ||
                other.seatCapacity == seatCapacity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, vehicleMake, vehicleModel, registration, seatCapacity);

  /// Create a copy of DriverProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverProfileRequestImplCopyWith<_$DriverProfileRequestImpl>
      get copyWith =>
          __$$DriverProfileRequestImplCopyWithImpl<_$DriverProfileRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverProfileRequestImplToJson(
      this,
    );
  }
}

abstract class _DriverProfileRequest implements DriverProfileRequest {
  const factory _DriverProfileRequest(
      {required final String vehicleMake,
      required final String vehicleModel,
      required final String registration,
      required final int seatCapacity}) = _$DriverProfileRequestImpl;

  factory _DriverProfileRequest.fromJson(Map<String, dynamic> json) =
      _$DriverProfileRequestImpl.fromJson;

  @override
  String get vehicleMake;
  @override
  String get vehicleModel;
  @override
  String get registration;
  @override
  int get seatCapacity;

  /// Create a copy of DriverProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DriverProfileRequestImplCopyWith<_$DriverProfileRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

DriverResponse _$DriverResponseFromJson(Map<String, dynamic> json) {
  return _DriverResponse.fromJson(json);
}

/// @nodoc
mixin _$DriverResponse {
  int get driverProfileId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get vehicleMake => throw _privateConstructorUsedError;
  String get vehicleModel => throw _privateConstructorUsedError;
  String get vehicleRegistration => throw _privateConstructorUsedError;
  int get seatCapacity => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get totalRatings => throw _privateConstructorUsedError;
  bool get isVerified => throw _privateConstructorUsedError;

  /// Serializes this DriverResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DriverResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DriverResponseCopyWith<DriverResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DriverResponseCopyWith<$Res> {
  factory $DriverResponseCopyWith(
          DriverResponse value, $Res Function(DriverResponse) then) =
      _$DriverResponseCopyWithImpl<$Res, DriverResponse>;
  @useResult
  $Res call(
      {int driverProfileId,
      String userId,
      String fullName,
      String vehicleMake,
      String vehicleModel,
      String vehicleRegistration,
      int seatCapacity,
      double rating,
      int totalRatings,
      bool isVerified});
}

/// @nodoc
class _$DriverResponseCopyWithImpl<$Res, $Val extends DriverResponse>
    implements $DriverResponseCopyWith<$Res> {
  _$DriverResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DriverResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? driverProfileId = null,
    Object? userId = null,
    Object? fullName = null,
    Object? vehicleMake = null,
    Object? vehicleModel = null,
    Object? vehicleRegistration = null,
    Object? seatCapacity = null,
    Object? rating = null,
    Object? totalRatings = null,
    Object? isVerified = null,
  }) {
    return _then(_value.copyWith(
      driverProfileId: null == driverProfileId
          ? _value.driverProfileId
          : driverProfileId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleMake: null == vehicleMake
          ? _value.vehicleMake
          : vehicleMake // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleModel: null == vehicleModel
          ? _value.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleRegistration: null == vehicleRegistration
          ? _value.vehicleRegistration
          : vehicleRegistration // ignore: cast_nullable_to_non_nullable
              as String,
      seatCapacity: null == seatCapacity
          ? _value.seatCapacity
          : seatCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalRatings: null == totalRatings
          ? _value.totalRatings
          : totalRatings // ignore: cast_nullable_to_non_nullable
              as int,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DriverResponseImplCopyWith<$Res>
    implements $DriverResponseCopyWith<$Res> {
  factory _$$DriverResponseImplCopyWith(_$DriverResponseImpl value,
          $Res Function(_$DriverResponseImpl) then) =
      __$$DriverResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int driverProfileId,
      String userId,
      String fullName,
      String vehicleMake,
      String vehicleModel,
      String vehicleRegistration,
      int seatCapacity,
      double rating,
      int totalRatings,
      bool isVerified});
}

/// @nodoc
class __$$DriverResponseImplCopyWithImpl<$Res>
    extends _$DriverResponseCopyWithImpl<$Res, _$DriverResponseImpl>
    implements _$$DriverResponseImplCopyWith<$Res> {
  __$$DriverResponseImplCopyWithImpl(
      _$DriverResponseImpl _value, $Res Function(_$DriverResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DriverResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? driverProfileId = null,
    Object? userId = null,
    Object? fullName = null,
    Object? vehicleMake = null,
    Object? vehicleModel = null,
    Object? vehicleRegistration = null,
    Object? seatCapacity = null,
    Object? rating = null,
    Object? totalRatings = null,
    Object? isVerified = null,
  }) {
    return _then(_$DriverResponseImpl(
      driverProfileId: null == driverProfileId
          ? _value.driverProfileId
          : driverProfileId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleMake: null == vehicleMake
          ? _value.vehicleMake
          : vehicleMake // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleModel: null == vehicleModel
          ? _value.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleRegistration: null == vehicleRegistration
          ? _value.vehicleRegistration
          : vehicleRegistration // ignore: cast_nullable_to_non_nullable
              as String,
      seatCapacity: null == seatCapacity
          ? _value.seatCapacity
          : seatCapacity // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      totalRatings: null == totalRatings
          ? _value.totalRatings
          : totalRatings // ignore: cast_nullable_to_non_nullable
              as int,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DriverResponseImpl implements _DriverResponse {
  const _$DriverResponseImpl(
      {required this.driverProfileId,
      required this.userId,
      required this.fullName,
      required this.vehicleMake,
      required this.vehicleModel,
      required this.vehicleRegistration,
      required this.seatCapacity,
      required this.rating,
      required this.totalRatings,
      required this.isVerified});

  factory _$DriverResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DriverResponseImplFromJson(json);

  @override
  final int driverProfileId;
  @override
  final String userId;
  @override
  final String fullName;
  @override
  final String vehicleMake;
  @override
  final String vehicleModel;
  @override
  final String vehicleRegistration;
  @override
  final int seatCapacity;
  @override
  final double rating;
  @override
  final int totalRatings;
  @override
  final bool isVerified;

  @override
  String toString() {
    return 'DriverResponse(driverProfileId: $driverProfileId, userId: $userId, fullName: $fullName, vehicleMake: $vehicleMake, vehicleModel: $vehicleModel, vehicleRegistration: $vehicleRegistration, seatCapacity: $seatCapacity, rating: $rating, totalRatings: $totalRatings, isVerified: $isVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DriverResponseImpl &&
            (identical(other.driverProfileId, driverProfileId) ||
                other.driverProfileId == driverProfileId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.vehicleMake, vehicleMake) ||
                other.vehicleMake == vehicleMake) &&
            (identical(other.vehicleModel, vehicleModel) ||
                other.vehicleModel == vehicleModel) &&
            (identical(other.vehicleRegistration, vehicleRegistration) ||
                other.vehicleRegistration == vehicleRegistration) &&
            (identical(other.seatCapacity, seatCapacity) ||
                other.seatCapacity == seatCapacity) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.totalRatings, totalRatings) ||
                other.totalRatings == totalRatings) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      driverProfileId,
      userId,
      fullName,
      vehicleMake,
      vehicleModel,
      vehicleRegistration,
      seatCapacity,
      rating,
      totalRatings,
      isVerified);

  /// Create a copy of DriverResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DriverResponseImplCopyWith<_$DriverResponseImpl> get copyWith =>
      __$$DriverResponseImplCopyWithImpl<_$DriverResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DriverResponseImplToJson(
      this,
    );
  }
}

abstract class _DriverResponse implements DriverResponse {
  const factory _DriverResponse(
      {required final int driverProfileId,
      required final String userId,
      required final String fullName,
      required final String vehicleMake,
      required final String vehicleModel,
      required final String vehicleRegistration,
      required final int seatCapacity,
      required final double rating,
      required final int totalRatings,
      required final bool isVerified}) = _$DriverResponseImpl;

  factory _DriverResponse.fromJson(Map<String, dynamic> json) =
      _$DriverResponseImpl.fromJson;

  @override
  int get driverProfileId;
  @override
  String get userId;
  @override
  String get fullName;
  @override
  String get vehicleMake;
  @override
  String get vehicleModel;
  @override
  String get vehicleRegistration;
  @override
  int get seatCapacity;
  @override
  double get rating;
  @override
  int get totalRatings;
  @override
  bool get isVerified;

  /// Create a copy of DriverResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DriverResponseImplCopyWith<_$DriverResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
