// lib/features/wallet/presentation/providers/wallet_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/wallet_api_service.dart';
import '../../data/models/wallet_models.dart';

// ── Wallet Balance ────────────────────────────────────────────────────────────
// Keeps the most-recently-loaded wallet response in state.
// The screen refreshes this after every top-up or transfer.

class WalletNotifier extends AsyncNotifier<WalletResponse> {
  @override
  Future<WalletResponse> build() =>
      ref.read(walletApiServiceProvider).getWallet();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(walletApiServiceProvider).getWallet());
  }

  /// Optimistically update balance (e.g. after a confirmed transfer).
  void updateBalance(double newBalance) {
    state = state.whenData((w) => WalletResponse(
      walletId:  w.walletId,
      userId:    w.userId,
      walletTag: w.walletTag,
      balance:   newBalance,
      updatedAt: DateTime.now(),
    ));
  }
}

final walletProvider =
    AsyncNotifierProvider<WalletNotifier, WalletResponse>(WalletNotifier.new);

// ── Transaction History ───────────────────────────────────────────────────────

class TransactionsNotifier extends AsyncNotifier<List<WalletTransaction>> {
  @override
  Future<List<WalletTransaction>> build() =>
      ref.read(walletApiServiceProvider).getTransactions();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(walletApiServiceProvider).getTransactions());
  }
}

final transactionsProvider =
    AsyncNotifierProvider<TransactionsNotifier, List<WalletTransaction>>(
        TransactionsNotifier.new);

// ── Top-Up VM ─────────────────────────────────────────────────────────────────
// Tracks the async state of initiating a PayFast top-up.

class TopUpVMNotifier
    extends AutoDisposeAsyncNotifier<TopUpInitiateResponse?> {
  @override
  Future<TopUpInitiateResponse?> build() async => null;

  Future<TopUpInitiateResponse?> initiate(double amount) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(walletApiServiceProvider).initiateTopUp(
          TopUpInitiateRequest(amount: amount),
        ));
    return state.valueOrNull;
  }

  void reset() => state = const AsyncData(null);
}

final topUpVMProvider =
    AutoDisposeAsyncNotifierProvider<TopUpVMNotifier, TopUpInitiateResponse?>(
        TopUpVMNotifier.new);

// ── Transfer VM ───────────────────────────────────────────────────────────────

class TransferVMNotifier
    extends AutoDisposeAsyncNotifier<P2PTransferResponse?> {
  @override
  Future<P2PTransferResponse?> build() async => null;

  Future<P2PTransferResponse?> transfer({
    required String recipientTag,
    required double amount,
    String? note,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(walletApiServiceProvider).transfer(P2PTransferRequest(
          recipientTag: recipientTag,
          amount:          amount,
          note:            note,
        )));

    // If successful, refresh wallet balance
    if (state.hasValue && state.valueOrNull?.success == true) {
      final newBalance = state.valueOrNull?.senderBalance ?? 0;
      ref.read(walletProvider.notifier).updateBalance(newBalance);
      ref.read(transactionsProvider.notifier).refresh();
    }

    return state.valueOrNull;
  }

  void reset() => state = const AsyncData(null);
}

final transferVMProvider =
    AutoDisposeAsyncNotifierProvider<TransferVMNotifier, P2PTransferResponse?>(
        TransferVMNotifier.new);
