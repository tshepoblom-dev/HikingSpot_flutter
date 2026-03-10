// lib/features/wallet/presentation/widgets/wallet_balance_chip.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../shared/theme/app_theme.dart';
import '../providers/wallet_provider.dart';

// ── WalletBalanceChip ─────────────────────────────────────────────────────────
// Small tappable pill that shows the current wallet balance.
// Tapping navigates to the wallet screen.
// Used in AppBar actions or page headers.

class WalletBalanceChip extends ConsumerWidget {
  /// When [light] is true the text/icon are white — use over dark hero headers.
  final bool light;

  const WalletBalanceChip({super.key, this.light = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);

    final bg      = light
        ? Colors.white.withOpacity(0.18)
        : AppColors.primary.withOpacity(0.1);
    final fg      = light ? Colors.white : AppColors.primary;
    final border  = light
        ? Colors.white.withOpacity(0.35)
        : AppColors.primary.withOpacity(0.25);

    return GestureDetector(
      onTap: () => context.push(RouteConstants.wallet),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_balance_wallet_rounded, size: 15, color: fg),
            const SizedBox(width: 5),
            walletAsync.when(
              loading: () => SizedBox(
                width: 14, height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: fg,
                ),
              ),
              error: (_, __) => Text('—',
                  style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w600)),
              data: (w) => Text(
                'R ${w.balance.toStringAsFixed(2)}',
                style: TextStyle(
                  color: fg, fontSize: 13, fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── WalletBalanceBanner ───────────────────────────────────────────────────────
// Larger inline card — used as the top section of screens like booking list.

class WalletBalanceBanner extends ConsumerWidget {
  const WalletBalanceBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);

    return GestureDetector(
      onTap: () => context.push(RouteConstants.wallet),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryDark, Color(0xFF1565C0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white, size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Balance
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wallet Balance',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  walletAsync.when(
                    loading: () => const SizedBox(
                      height: 18,
                      child: LinearProgressIndicator(
                        backgroundColor: Colors.white24,
                        color: Colors.white,
                      ),
                    ),
                    error: (_, __) => const Text('—',
                      style: TextStyle(color: Colors.white, fontSize: 20,
                          fontWeight: FontWeight.bold)),
                    data: (w) => Text(
                      'R ${w.balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // CTA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.35)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('Top Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
