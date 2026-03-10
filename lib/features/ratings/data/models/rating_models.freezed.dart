// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RatingCreateRequest _$RatingCreateRequestFromJson(Map<String, dynamic> json) {
  return _RatingCreateRequest.fromJson(json);
}

/// @nodoc
mixin _$RatingCreateRequest {
  int get tripId => throw _privateConstructorUsedError;
  int get score => throw _privateConstructorUsedError;
  String get comment => throw _privateConstructorUsedError;

  /// Serializes this RatingCreateRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RatingCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RatingCreateRequestCopyWith<RatingCreateRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatingCreateRequestCopyWith<$Res> {
  factory $RatingCreateRequestCopyWith(
          RatingCreateRequest value, $Res Function(RatingCreateRequest) then) =
      _$RatingCreateRequestCopyWithImpl<$Res, RatingCreateRequest>;
  @useResult
  $Res call({int tripId, int score, String comment});
}

/// @nodoc
class _$RatingCreateRequestCopyWithImpl<$Res, $Val extends RatingCreateRequest>
    implements $RatingCreateRequestCopyWith<$Res> {
  _$RatingCreateRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RatingCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? score = null,
    Object? comment = null,
  }) {
    return _then(_value.copyWith(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RatingCreateRequestImplCopyWith<$Res>
    implements $RatingCreateRequestCopyWith<$Res> {
  factory _$$RatingCreateRequestImplCopyWith(_$RatingCreateRequestImpl value,
          $Res Function(_$RatingCreateRequestImpl) then) =
      __$$RatingCreateRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int tripId, int score, String comment});
}

/// @nodoc
class __$$RatingCreateRequestImplCopyWithImpl<$Res>
    extends _$RatingCreateRequestCopyWithImpl<$Res, _$RatingCreateRequestImpl>
    implements _$$RatingCreateRequestImplCopyWith<$Res> {
  __$$RatingCreateRequestImplCopyWithImpl(_$RatingCreateRequestImpl _value,
      $Res Function(_$RatingCreateRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of RatingCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tripId = null,
    Object? score = null,
    Object? comment = null,
  }) {
    return _then(_$RatingCreateRequestImpl(
      tripId: null == tripId
          ? _value.tripId
          : tripId // ignore: cast_nullable_to_non_nullable
              as int,
      score: null == score
          ? _value.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      comment: null == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RatingCreateRequestImpl implements _RatingCreateRequest {
  const _$RatingCreateRequestImpl(
      {required this.tripId, required this.score, this.comment = ''});

  factory _$RatingCreateRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$RatingCreateRequestImplFromJson(json);

  @override
  final int tripId;
  @override
  final int score;
  @override
  @JsonKey()
  final String comment;

  @override
  String toString() {
    return 'RatingCreateRequest(tripId: $tripId, score: $score, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RatingCreateRequestImpl &&
            (identical(other.tripId, tripId) || other.tripId == tripId) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tripId, score, comment);

  /// Create a copy of RatingCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RatingCreateRequestImplCopyWith<_$RatingCreateRequestImpl> get copyWith =>
      __$$RatingCreateRequestImplCopyWithImpl<_$RatingCreateRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RatingCreateRequestImplToJson(
      this,
    );
  }
}

abstract class _RatingCreateRequest implements RatingCreateRequest {
  const factory _RatingCreateRequest(
      {required final int tripId,
      required final int score,
      final String comment}) = _$RatingCreateRequestImpl;

  factory _RatingCreateRequest.fromJson(Map<String, dynamic> json) =
      _$RatingCreateRequestImpl.fromJson;

  @override
  int get tripId;
  @override
  int get score;
  @override
  String get comment;

  /// Create a copy of RatingCreateRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RatingCreateRequestImplCopyWith<_$RatingCreateRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
