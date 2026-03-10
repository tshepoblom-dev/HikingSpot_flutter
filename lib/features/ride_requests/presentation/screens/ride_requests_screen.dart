// lib/features/ride_requests/presentation/screens/ride_requests_screen.dart
// Drivers browse open passenger ride requests and can offer to take them.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../../data/models/ride_request_models.dart';
import '../providers/ride_requests_provider.dart';
import '../widgets/ride_request_card.dart';

class RideRequestsScreen extends ConsumerStatefulWidget {
  const RideRequestsScreen({super.key});

  @override
  ConsumerState<RideRequestsScreen> createState() => _RideRequestsScreenState();
}

class _RideRequestsScreenState extends ConsumerState<RideRequestsScreen> {
  final _fromCtrl = TextEditingController();
  final _toCtrl   = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rideRequestResultsProvider.notifier)
          .search(const RideRequestSearchParams());
    });
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  void _search() {
    final params = RideRequestSearchParams(
      fromCity: _fromCtrl.text.trim(),
      toCity:   _toCtrl.text.trim(),
    );
    ref.read(rideRequestSearchStateProvider.notifier).state = params;
    ref.read(rideRequestResultsProvider.notifier).search(params);
  }

  void _showOfferDialog(RideRequestResponse request) {
    final tripIdCtrl  = TextEditingController();
    final msgCtrl     = TextEditingController();
    final formKey     = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36, height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Text('Offer a Ride',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                '${request.passengerName} · ${request.fromCity} → ${request.toCity}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: tripIdCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Your Trip ID (optional)',
                  hintText: 'Link to one of your posted trips',
                  prefixIcon: const Icon(Icons.directions_car_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: msgCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Message to passenger (optional)',
                  hintText: 'e.g. I drive through Midrand every weekday',
                  prefixIcon: const Icon(Icons.message_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              Consumer(builder: (ctx, cRef, _) {
                final vmState = cRef.watch(makeOfferVMProvider);
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: vmState.isLoading
                        ? null
                        : () async {
                            final offer = RideOfferRequest(
                              rideRequestId: request.id,
                              tripId: int.tryParse(tripIdCtrl.text),
                              message: msgCtrl.text.trim().isEmpty
                                  ? null
                                  : msgCtrl.text.trim(),
                            );
                            final ok = await cRef
                                .read(makeOfferVMProvider.notifier)
                                .makeOffer(offer);
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(ok
                                  ? '✅ Offer sent to ${request.passengerName}!'
                                  : 'Failed to send offer. Try again.'),
                              backgroundColor: ok
                                  ? AppColors.primary
                                  : AppColors.error,
                            ));
                          },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: vmState.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Send Offer'),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(rideRequestResultsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Passenger Requests',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Passengers looking for rides along your route',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13)),
                  const SizedBox(height: 20),
                  // ── Search row ────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.trip_origin,
                                  color: AppColors.primary, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _fromCtrl,
                                  decoration: const InputDecoration(
                                    hintText: 'From',
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: AppColors.error, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _toCtrl,
                                  decoration: const InputDecoration(
                                    hintText: 'To',
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _search,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Results ─────────────────────────────────────────────────
          results.when(
            loading: () => SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, __) => const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: HsShimmerCard(height: 160),
                  ),
                  childCount: 4,
                ),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: HsErrorState(message: e.toString()),
            ),
            data: (paged) => paged.items.isEmpty
                ? const SliverFillRemaining(
                    child: HsEmptyState(
                      icon: Icons.hail_outlined,
                      title: 'No ride requests',
                      subtitle:
                          'No passengers have posted requests matching this route yet.',
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) {
                          final req = paged.items[i];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: RideRequestCard(
                              request: req,
                              trailing: req.status == RideRequestStatus.open
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () =>
                                            _showOfferDialog(req),
                                        icon: const Icon(
                                            Icons.local_taxi_outlined,
                                            size: 16),
                                        label: const Text('Offer a Ride'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppColors.primary,
                                          side: const BorderSide(
                                              color: AppColors.primary),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        },
                        childCount: paged.items.length,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
