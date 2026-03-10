// lib/features/chat/data/models/message_models.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_models.freezed.dart';
part 'message_models.g.dart';

@freezed
class MessageResponse with _$MessageResponse {
  const factory MessageResponse({
    required int id,
    required int bookingId,
    required String senderId,
    required String senderName,
    required String text,
    required DateTime sentAt,
  }) = _MessageResponse;

  factory MessageResponse.fromJson(Map<String, dynamic> json) => _$MessageResponseFromJson(json);
}

@freezed
class SendMessageRequest with _$SendMessageRequest {
  const factory SendMessageRequest({
    required int bookingId,
    required String text,
  }) = _SendMessageRequest;

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) => _$SendMessageRequestFromJson(json);
}
