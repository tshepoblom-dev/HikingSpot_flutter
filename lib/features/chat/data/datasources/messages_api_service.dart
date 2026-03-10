// lib/features/chat/data/datasources/messages_api_service.dart

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/dio_client.dart';
import '../models/message_models.dart';

part 'messages_api_service.g.dart';

@riverpod
MessagesApiService messagesApiService(MessagesApiServiceRef ref) =>
    MessagesApiService(ref.watch(dioClientProvider));

class MessagesApiService {
  final Dio _dio;
  MessagesApiService(this._dio);

  Future<List<MessageResponse>> getChatHistory(int bookingId) async {
    try {
      final res = await _dio.get('/api/messages/$bookingId');
      return (res.data as List).map((e) => MessageResponse.fromJson(e)).toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  Future<MessageResponse> sendMessage(SendMessageRequest request) async {
    try {
      final res = await _dio.post('/api/messages', data: request.toJson());
      return MessageResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
