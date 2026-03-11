// lib/features/wallet/presentation/screens/wallet_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../../data/models/wallet_models.dart';
import '../providers/wallet_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(walletProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primaryDark,
            foregroundColor: Colors.white,
            title: const Text('My Wallet',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  ref.read(walletProvider.notifier).refresh();
                  ref.read(transactionsProvider.notifier).refresh();
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _BalanceHero(walletAsync: walletAsync),
            ),
            bottom: TabBar(
              controller: _tabs,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(text: 'Transactions'),
                Tab(text: 'Transfer'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabs,
          children: [
            _TransactionsTab(),
            _TransferTab(),
          ],
        ),
      ),

      // ── FAB: Top Up ───────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTopUpSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Top Up',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  void _showTopUpSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _TopUpSheet(onSuccess: () {
        ref.read(walletProvider.notifier).refresh();
        ref.read(transactionsProvider.notifier).refresh();
      }),
    );
  }
}

// ── Balance Hero ──────────────────────────────────────────────────────────────

class _BalanceHero extends StatelessWidget {
  final AsyncValue<WalletResponse> walletAsync;
  const _BalanceHero({required this.walletAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Available Balance',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75), fontSize: 13)),
              const SizedBox(height: 6),
              walletAsync.when(
                loading: () => const SizedBox(
                  width: 160, height: 38,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white24,
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                error: (e, _) => const Text('—',
                    style: TextStyle(color: Colors.white, fontSize: 36)),
                data: (w) => Text(
                  'R ${w.balance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              walletAsync.whenOrNull(
                data: (w) => Text(
                  'Updated ${_relativeTime(w.updatedAt)}',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.55), fontSize: 11),
                ),
              ) ?? const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('d MMM').format(dt);
  }
}

// ── Transactions Tab ──────────────────────────────────────────────────────────

class _TransactionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionsProvider);

    return txAsync.when(
      loading: () => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: HsShimmerCard(height: 72),
        ),
      ),
      error: (e, _) => HsErrorState(
        message: e.toString(),
        onRetry: () => ref.read(transactionsProvider.notifier).refresh(),
      ),
      data: (txs) => txs.isEmpty
          ? const HsEmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No transactions yet',
              subtitle: 'Top up your wallet to get started!',
            )
          : RefreshIndicator(
              onRefresh: () async =>
                  ref.read(transactionsProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                itemCount: txs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _TxCard(tx: txs[i]),
              ),
            ),
    );
  }
}

class _TxCard extends StatelessWidget {
  final WalletTransaction tx;
  const _TxCard({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.isCredit;
    final amountColor = isCredit ? AppColors.success : AppColors.error;
    final amountPrefix = isCredit ? '+' : '';

    return Card(
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: amountColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(_typeIcon(tx.type), color: amountColor, size: 20),
            ),
            const SizedBox(width: 12),

            // Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.typeLabel,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(tx.description,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(
                    DateFormat('d MMM yyyy, HH:mm').format(tx.createdAt.toLocal()),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
            ),

            // Amount
            Text(
              '$amountPrefix R ${tx.amount.abs().toStringAsFixed(2)}',
              style: TextStyle(
                color: amountColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _typeIcon(TransactionType t) => switch (t) {
    TransactionType.topUp           => Icons.add_circle_outline,
    TransactionType.rideCommission  => Icons.directions_car_outlined,
    TransactionType.p2PTransfer     => Icons.send_outlined,
    TransactionType.p2PReceive      => Icons.call_received_outlined,
    TransactionType.refund          => Icons.undo_outlined,
    TransactionType.adminAdjustment => Icons.admin_panel_settings_outlined,
  };
}

// ── Transfer Tab ──────────────────────────────────────────────────────────────

class _TransferTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_TransferTab> createState() => _TransferTabState();
}

class _TransferTabState extends ConsumerState<_TransferTab> {
  final _formKey     = GlobalKey<FormState>();
  final _recipCtrl   = TextEditingController();
  final _amountCtrl  = TextEditingController();
  final _noteCtrl    = TextEditingController();

  @override
  void dispose() {
    _recipCtrl.dispose(); _amountCtrl.dispose(); _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    final result = await ref
        .read(transferVMProvider.notifier)
        .transfer(
          recipientTag: _recipCtrl.text.trim(),
          amount:          amount,
          note:            _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
        );

    if (!mounted) return;

    if (result?.success == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result!.message),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _amountCtrl.clear(); _recipCtrl.clear(); _noteCtrl.clear();
      ref.read(transferVMProvider.notifier).reset();
    } else {
      final err = ref.read(transferVMProvider).error?.toString()
          ?? result?.message
          ?? 'Transfer failed';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm        = ref.watch(transferVMProvider);
    final isLoading = vm.isLoading;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // At the top of _TransferTab build(), before the info card
            Consumer(builder: (_, ref, __) {
              final wallet = ref.watch(walletProvider).valueOrNull;
              if (wallet?.walletTag == null) return const SizedBox();
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_outlined,
                        color: AppColors.primary, size: 18),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Wallet Tag',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        Text(wallet!.walletTag!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.primary,
                                letterSpacing: 1)),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.copy_outlined,
                          color: AppColors.primary, size: 18),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: wallet.walletTag!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Wallet tag copied!')),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
            // ── Info card ─────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.info, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Transfer funds directly to a driver or another user by their User ID.',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.info.withOpacity(0.9)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text('Recipient Wallet Tag',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _recipCtrl,
              decoration: const InputDecoration(
                hintText: 'e.g. HS-K7X2M9',
                prefixIcon: Icon(Icons.tag_outlined),
              ),
              validator: (v) {
                final val = v?.trim() ?? '';
                if (val.isEmpty) return 'Required';
                if (!RegExp(r'^HS-[A-Z0-9]{6}$').hasMatch(val.toUpperCase())) {
                  return 'Enter a valid wallet tag (e.g. HS-K7X2M9)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            const Text('Amount (ZAR)',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _amountCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              decoration: const InputDecoration(
                hintText: '0.00',
                prefixText: 'R ',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
              validator: (v) {
                final d = double.tryParse(v?.trim() ?? '');
                if (d == null || d <= 0) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 16),

            const Text('Note (optional)',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _noteCtrl,
              maxLength: 200,
              decoration: const InputDecoration(
                hintText: 'e.g. Trip payment for Joburg → Pretoria',
                prefixIcon: Icon(Icons.note_outlined),
              ),
            ),
            const SizedBox(height: 24),

            HsButton(
              label: 'Send Money',
              icon: Icons.send,
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top-Up Bottom Sheet ───────────────────────────────────────────────────────

class _TopUpSheet extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;
  const _TopUpSheet({required this.onSuccess});

  @override
  ConsumerState<_TopUpSheet> createState() => _TopUpSheetState();
}

class _TopUpSheetState extends ConsumerState<_TopUpSheet> {
  final _formKey    = GlobalKey<FormState>();
  final _amountCtrl = TextEditingController();
  double? _selected;

  static const _presets = [50.0, 100.0, 200.0, 500.0];

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _initiate() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = _selected ?? double.tryParse(_amountCtrl.text.trim()) ?? 0;

    final result = await ref.read(topUpVMProvider.notifier).initiate(amount);
    if (!mounted) return;

    if (result != null) {
      Navigator.of(context).pop(); // close sheet
      await _openPayFast(result.paymentUrl);
      widget.onSuccess();
    } else {
      final err = ref.read(topUpVMProvider).error?.toString() ?? 'Failed to initiate payment';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err), backgroundColor: AppColors.error),
      );
    }
  }
  // In _TopUpSheet — replace launchUrl with a WebView push
  Future<void> _openPayFast(String url) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => _PayFastWebView(paymentUrl: url),
      ),
    );

    // result is 'success' | 'cancel' | null (dismissed)
    if (result == 'success') {
      widget.onSuccess();
    }
  }
/*
  Future<void> _openPayFast(String url) async {
    final uri = Uri.parse(url);
  //  if (await canLaunchUrl(uri)) {
  try{
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
  }
  catch(e){
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open payment page')),
        );
      }
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    final vm        = ref.watch(topUpVMProvider);
    final isLoading = vm.isLoading;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_circle,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Top Up Wallet',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                      Text('Pay securely via PayFast',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Quick amounts ─────────────────────────────────────────────
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _presets.map((p) {
                final selected = _selected == p;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selected = selected ? null : p;
                      if (!selected) _amountCtrl.text = p.toStringAsFixed(0);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      'R ${p.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: selected ? Colors.white : AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // ── Custom amount ─────────────────────────────────────────────
            TextFormField(
              controller: _amountCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
              ],
              onChanged: (_) => setState(() => _selected = null),
              decoration: const InputDecoration(
                labelText: 'Or enter custom amount',
                hintText: '0.00',
                prefixText: 'R ',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
              validator: (_) {
                final amount =
                    _selected ?? double.tryParse(_amountCtrl.text.trim());
                if (amount == null || amount < 10) {
                  return 'Minimum top-up is R10';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),

            // PayFast badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline,
                    size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                const Text('Secured by PayFast',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 20),

            HsButton(
              label: 'Proceed to Payment',
              icon: Icons.open_in_new,
              isLoading: isLoading,
              onPressed: _initiate,
            ),
          ],
        ),
      ),
    );
  }
}

// New widget — add to wallet_screen.dart
class _PayFastWebView extends StatefulWidget {
  final String paymentUrl;
  const _PayFastWebView({required this.paymentUrl});

  @override
  State<_PayFastWebView> createState() => _PayFastWebViewState();
}

class _PayFastWebViewState extends State<_PayFastWebView> {
  late final WebViewController _controller;

  // These must match exactly what the server returns as return/cancel URLs
  static const _successPath = '/api/wallet/payfast/return';
  static const _cancelPath  = '/api/wallet/payfast/cancel';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (req) {
          final uri = Uri.tryParse(req.url);
          if (uri == null) return NavigationDecision.navigate;

          if (uri.path == _successPath) {
            // ITN will have already credited the wallet by the time
            // PayFast redirects here — safe to refresh and close.
            Navigator.of(context).pop('success');
            return NavigationDecision.prevent;
          }

          if (uri.path == _cancelPath) {
            Navigator.of(context).pop('cancel');
            return NavigationDecision.prevent;
          }

          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop('cancel'),
        ),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
