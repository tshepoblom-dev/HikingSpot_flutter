// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RatingCreateRequestImpl _$$RatingCreateRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$RatingCreateRequestImpl(
      tripId: (json['tripId'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      comment: json['comment'] as String? ?? '',
    );

Map<String, dynamic> _$$RatingCreateRequestImplToJson(
        _$RatingCreateRequestImpl instance) =>
    <String, dynamic>{
      'tripId': instance.tripId,
      'score': instance.score,
      'comment': instance.comment,
    };
