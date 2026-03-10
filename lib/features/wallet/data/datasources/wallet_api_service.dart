// lib/features/wallet/data/datasources/wallet_api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../models/wallet_models.dart';

// ── Provider ──────────────────────────────────────────────────────────────────

final walletApiServiceProvider = Provider<WalletApiService>((ref) =>
    WalletApiService(ref.watch(dioClientProvider)));

// ── Service ───────────────────────────────────────────────────────────────────

class WalletApiService {
  final Dio _dio;
  WalletApiService(this._dio);

  // ── GET /api/wallet ────────────────────────────────────────────────────────

  Future<WalletResponse> getWallet() async {
    try {
      final res = await _dio.get('/api/wallet');
      return WalletResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // ── GET /api/wallet/transactions ───────────────────────────────────────────

  Future<List<WalletTransaction>> getTransactions({
    int page = 1,
    int pageSize = 30,
  }) async {
    try {
      final res = await _dio.get('/api/wallet/transactions', queryParameters: {
        'page':     page,
        'pageSize': pageSize,
      });
      return (res.data as List)
          .map((e) => WalletTransaction.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // ── POST /api/wallet/topup/initiate ───────────────────────────────────────

  Future<TopUpInitiateResponse> initiateTopUp(TopUpInitiateRequest request) async {
    try {
      final res = await _dio.post(
        '/api/wallet/topup/initiate',
        data: request.toJson(),
      );
      return TopUpInitiateResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  // ── POST /api/wallet/transfer ─────────────────────────────────────────────

  Future<P2PTransferResponse> transfer(P2PTransferRequest request) async {
    try {
      final res = await _dio.post('/api/wallet/transfer', data: request.toJson());
      return P2PTransferResponse.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
