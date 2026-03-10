// lib/features/ratings/data/models/rating_models.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'rating_models.freezed.dart';
part 'rating_models.g.dart';

@freezed
class RatingCreateRequest with _$RatingCreateRequest {
  const factory RatingCreateRequest({
    required int tripId,
    required int score,
    @Default('') String comment,
  }) = _RatingCreateRequest;

  factory RatingCreateRequest.fromJson(Map<String, dynamic> json) => _$RatingCreateRequestFromJson(json);
}
