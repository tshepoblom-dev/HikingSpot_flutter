// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingRequest _$BookingRequestFromJson(Map<String, dynamic> json) {
  return _BookingRequest.fromJson(json);
}

/// @nodoc
mixin _$BookingRequest {
  int get tripId => throw _privateConstructorUsedError;
  int get seatsRequested => throw _privateConstructorUsedError;
  int get paymentMethod => throw _privateConstructorUsedError;

  /// Serializes this BookingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingRequestCopyWith<BookingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingRequestCopyWith<$Res> {
  factory $BookingRequestCopyWith(
          BookingRequest value, $Res Function(BookingRequest) then) =
      _$BookingRequestCopyWithImpl<$Res, BookingRequest>;
  @useResult
  $Res call({int tripId, int seatsRequested, int paymentMethod});
}

/// @nodoc
class _$BookingRequestCopyWithImpl<$Res, $Val extends BookingRequest>
    implements $BookingRequestCopyWith<$Res> {
  _$BookingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? seatsRequested = null,
    Object? paymentMethod = null,
  }) {
    return _then(_value.copyWith(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as int,
      seatsRequested: null == seatsRequested
          ? _value.seatsRequested
          : seatsRequested // ignore: cast_nullable_to_non_nullable
              as int,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingRequestImplCopyWith<$Res>
    implements $BookingRequestCopyWith<$Res> {
  factory _$$BookingRequestImplCopyWith(_$BookingRequestImpl value,
          $Res Function(_$BookingRequestImpl) then) =
      __$$BookingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int tripId, int seatsRequested, int paymentMethod});
}

/// @nodoc
class __$$BookingRequestImplCopyWithImpl<$Res>
    extends _$BookingRequestCopyWithImpl<$Res, _$BookingRequestImpl>
    implements _$$BookingRequestImplCopyWith<$Res> {
  __$$BookingRequestImplCopyWithImpl(
      _$BookingRequestImpl _value, $Res Function(_$BookingRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? seatsRequested = null,
    Object? paymentMethod = null,
  }) {
    return _then(_$BookingRequestImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as int,
      seatsRequested: null == seatsRequested
          ? _value.seatsRequested
          : seatsRequested // ignore: cast_nullable_to_non_nullable
              as int,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingRequestImpl implements _BookingRequest {
  const _$BookingRequestImpl(
      {required this.tripId, this.seatsRequested = 1, this.paymentMethod = 0});

  factory _$BookingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingRequestImplFromJson(json);

  @override
  final int tripId;
  @override
  @JsonKey()
  final int seatsRequested;
  @override
  @JsonKey()
  final int paymentMethod;

  @override
  String toString() {
    return 'BookingRequest(tripId: $tripId, seatsRequested: $seatsRequested, paymentMethod: $paymentMethod)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingRequestImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.seatsRequested, seatsRequested) ||
                other.seatsRequested == seatsRequested) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, tripId, seatsRequested, paymentMethod);

  /// Create a copy of BookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingRequestImplCopyWith<_$BookingRequestImpl> get copyWith =>
      __$$BookingRequestImplCopyWithImpl<_$BookingRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingRequestImplToJson(
      this,
    );
  }
}

abstract class _BookingRequest implements BookingRequest {
  const factory _BookingRequest(
      {required final int tripId,
      final int seatsRequested,
      final int paymentMethod}) = _$BookingRequestImpl;

  factory _BookingRequest.fromJson(Map<String, dynamic> json) =
      _$BookingRequestImpl.fromJson;

  @override
  int get tripId;
  @override
  int get seatsRequested;
  @override
  int get paymentMethod;

  /// Create a copy of BookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingRequestImplCopyWith<_$BookingRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingResponse _$BookingResponseFromJson(Map<String, dynamic> json) {
  return _BookingResponse.fromJson(json);
}

/// @nodoc
mixin _$BookingResponse {
  int get bookingId => throw _privateConstructorUsedError;
  int get tripId => throw _privateConstructorUsedError;
  String get passengerId => throw _privateConstructorUsedError;
  String get passengerName => throw _privateConstructorUsedError;
  String get departureCity => throw _privateConstructorUsedError;
  String get destinationCity => throw _privateConstructorUsedError;
  DateTime get departureTime => throw _privateConstructorUsedError;
  int get seatsRequested => throw _privateConstructorUsedError;
  @BookingStatusConverter()
  BookingStatus get status => throw _privateConstructorUsedError;
  int get paymentMethod =>
      throw _privateConstructorUsedError; // raw int from server
  bool get commissionCharged => throw _privateConstructorUsedError;
  DateTime get requestedAt => throw _privateConstructorUsedError;

  /// Serializes this BookingResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingResponseCopyWith<BookingResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingResponseCopyWith<$Res> {
  factory $BookingResponseCopyWith(
          BookingResponse value, $Res Function(BookingResponse) then) =
      _$BookingResponseCopyWithImpl<$Res, BookingResponse>;
  @useResult
  $Res call(
      {int bookingId,
      int tripId,
      String passengerId,
      String passengerName,
      String departureCity,
      String destinationCity,
      DateTime departureTime,
      int seatsRequested,
      @BookingStatusConverter() BookingStatus status,
      int paymentMethod,
      bool commissionCharged,
      DateTime requestedAt});
}

/// @nodoc
class _$BookingResponseCopyWithImpl<$Res, $Val extends BookingResponse>
    implements $BookingResponseCopyWith<$Res> {
  _$BookingResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? tripId = null,
    Object? passengerId = null,
    Object? passengerName = null,
    Object? departureCity = null,
    Object? destinationCity = null,
    Object? departureTime = null,
    Object? seatsRequested = null,
    Object? status = null,
    Object? paymentMethod = null,
    Object? commissionCharged = null,
    Object? requestedAt = null,
  }) {
    return _then(_value.copyWith(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as int,
      passengerId: null == passengerId
          ? _value.passengerId
          : passengerId // ignore: cast_nullable_to_non_nullable
              as String,
      passengerName: null == passengerName
          ? _value.passengerName
          : passengerName // ignore: cast_nullable_to_non_nullable
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
      seatsRequested: null == seatsRequested
          ? _value.seatsRequested
          : seatsRequested // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as int,
      commissionCharged: null == commissionCharged
          ? _value.commissionCharged
          : commissionCharged // ignore: cast_nullable_to_non_nullable
              as bool,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingResponseImplCopyWith<$Res>
    implements $BookingResponseCopyWith<$Res> {
  factory _$$BookingResponseImplCopyWith(_$BookingResponseImpl value,
          $Res Function(_$BookingResponseImpl) then) =
      __$$BookingResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int bookingId,
      int tripId,
      String passengerId,
      String passengerName,
      String departureCity,
      String destinationCity,
      DateTime departureTime,
      int seatsRequested,
      @BookingStatusConverter() BookingStatus status,
      int paymentMethod,
      bool commissionCharged,
      DateTime requestedAt});
}

/// @nodoc
class __$$BookingResponseImplCopyWithImpl<$Res>
    extends _$BookingResponseCopyWithImpl<$Res, _$BookingResponseImpl>
    implements _$$BookingResponseImplCopyWith<$Res> {
  __$$BookingResponseImplCopyWithImpl(
      _$BookingResponseImpl _value, $Res Function(_$BookingResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
    Object? tripId = null,
    Object? passengerId = null,
    Object? passengerName = null,
    Object? departureCity = null,
    Object? destinationCity = null,
    Object? departureTime = null,
    Object? seatsRequested = null,
    Object? status = null,
    Object? paymentMethod = null,
    Object? commissionCharged = null,
    Object? requestedAt = null,
  }) {
    return _then(_$BookingResponseImpl(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int,
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as int,
      passengerId: null == passengerId
          ? _value.passengerId
          : passengerId // ignore: cast_nullable_to_non_nullable
              as String,
      passengerName: null == passengerName
          ? _value.passengerName
          : passengerName // ignore: cast_nullable_to_non_nullable
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
      seatsRequested: null == seatsRequested
          ? _value.seatsRequested
          : seatsRequested // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as int,
      commissionCharged: null == commissionCharged
          ? _value.commissionCharged
          : commissionCharged // ignore: cast_nullable_to_non_nullable
              as bool,
      requestedAt: null == requestedAt
          ? _value.requestedAt
          : requestedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingResponseImpl implements _BookingResponse {
  const _$BookingResponseImpl(
      {required this.bookingId,
      required this.tripId,
      this.passengerId = '',
      required this.passengerName,
      required this.departureCity,
      required this.destinationCity,
      required this.departureTime,
      required this.seatsRequested,
      @BookingStatusConverter() required this.status,
      this.paymentMethod = 0,
      this.commissionCharged = false,
      required this.requestedAt});

  factory _$BookingResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingResponseImplFromJson(json);

  @override
  final int bookingId;
  @override
  final int tripId;
  @override
  @JsonKey()
  final String passengerId;
  @override
  final String passengerName;
  @override
  final String departureCity;
  @override
  final String destinationCity;
  @override
  final DateTime departureTime;
  @override
  final int seatsRequested;
  @override
  @BookingStatusConverter()
  final BookingStatus status;
  @override
  @JsonKey()
  final int paymentMethod;
// raw int from server
  @override
  @JsonKey()
  final bool commissionCharged;
  @override
  final DateTime requestedAt;

  @override
  String toString() {
    return 'BookingResponse(bookingId: $bookingId, tripId: $tripId, passengerId: $passengerId, passengerName: $passengerName, departureCity: $departureCity, destinationCity: $destinationCity, departureTime: $departureTime, seatsRequested: $seatsRequested, status: $status, paymentMethod: $paymentMethod, commissionCharged: $commissionCharged, requestedAt: $requestedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingResponseImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.passengerId, passengerId) ||
                other.passengerId == passengerId) &&
            (identical(other.passengerName, passengerName) ||
                other.passengerName == passengerName) &&
            (identical(other.departureCity, departureCity) ||
                other.departureCity == departureCity) &&
            (identical(other.destinationCity, destinationCity) ||
                other.destinationCity == destinationCity) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.seatsRequested, seatsRequested) ||
                other.seatsRequested == seatsRequested) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.commissionCharged, commissionCharged) ||
                other.commissionCharged == commissionCharged) &&
            (identical(other.requestedAt, requestedAt) ||
                other.requestedAt == requestedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      bookingId,
      tripId,
      passengerId,
      passengerName,
      departureCity,
      destinationCity,
      departureTime,
      seatsRequested,
      status,
      paymentMethod,
      commissionCharged,
      requestedAt);

  /// Create a copy of BookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingResponseImplCopyWith<_$BookingResponseImpl> get copyWith =>
      __$$BookingResponseImplCopyWithImpl<_$BookingResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingResponseImplToJson(
      this,
    );
  }
}

abstract class _BookingResponse implements BookingResponse {
  const factory _BookingResponse(
      {required final int bookingId,
      required final int tripId,
      final String passengerId,
      required final String passengerName,
      required final String departureCity,
      required final String destinationCity,
      required final DateTime departureTime,
      required final int seatsRequested,
      @BookingStatusConverter() required final BookingStatus status,
      final int paymentMethod,
      final bool commissionCharged,
      required final DateTime requestedAt}) = _$BookingResponseImpl;

  factory _BookingResponse.fromJson(Map<String, dynamic> json) =
      _$BookingResponseImpl.fromJson;

  @override
  int get bookingId;
  @override
  int get tripId;
  @override
  String get passengerId;
  @override
  String get passengerName;
  @override
  String get departureCity;
  @override
  String get destinationCity;
  @override
  DateTime get departureTime;
  @override
  int get seatsRequested;
  @override
  @BookingStatusConverter()
  BookingStatus get status;
  @override
  int get paymentMethod; // raw int from server
  @override
  bool get commissionCharged;
  @override
  DateTime get requestedAt;

  /// Create a copy of BookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingResponseImplCopyWith<_$BookingResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookingAction _$BookingActionFromJson(Map<String, dynamic> json) {
  return _BookingAction.fromJson(json);
}

/// @nodoc
mixin _$BookingAction {
  int get bookingId => throw _privateConstructorUsedError;

  /// Serializes this BookingAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingActionCopyWith<BookingAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingActionCopyWith<$Res> {
  factory $BookingActionCopyWith(
          BookingAction value, $Res Function(BookingAction) then) =
      _$BookingActionCopyWithImpl<$Res, BookingAction>;
  @useResult
  $Res call({int bookingId});
}

/// @nodoc
class _$BookingActionCopyWithImpl<$Res, $Val extends BookingAction>
    implements $BookingActionCopyWith<$Res> {
  _$BookingActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
  }) {
    return _then(_value.copyWith(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookingActionImplCopyWith<$Res>
    implements $BookingActionCopyWith<$Res> {
  factory _$$BookingActionImplCopyWith(
          _$BookingActionImpl value, $Res Function(_$BookingActionImpl) then) =
      __$$BookingActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int bookingId});
}

/// @nodoc
class __$$BookingActionImplCopyWithImpl<$Res>
    extends _$BookingActionCopyWithImpl<$Res, _$BookingActionImpl>
    implements _$$BookingActionImplCopyWith<$Res> {
  __$$BookingActionImplCopyWithImpl(
      _$BookingActionImpl _value, $Res Function(_$BookingActionImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookingId = null,
  }) {
    return _then(_$BookingActionImpl(
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingActionImpl implements _BookingAction {
  const _$BookingActionImpl({required this.bookingId});

  factory _$BookingActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingActionImplFromJson(json);

  @override
  final int bookingId;

  @override
  String toString() {
    return 'BookingAction(bookingId: $bookingId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingActionImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookingId);

  /// Create a copy of BookingAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingActionImplCopyWith<_$BookingActionImpl> get copyWith =>
      __$$BookingActionImplCopyWithImpl<_$BookingActionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingActionImplToJson(
      this,
    );
  }
}

abstract class _BookingAction implements BookingAction {
  const factory _BookingAction({required final int bookingId}) =
      _$BookingActionImpl;

  factory _BookingAction.fromJson(Map<String, dynamic> json) =
      _$BookingActionImpl.fromJson;

  @override
  int get bookingId;

  /// Create a copy of BookingAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingActionImplCopyWith<_$BookingActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
