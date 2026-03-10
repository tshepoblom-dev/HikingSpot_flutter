// lib/features/trips/presentation/screens/trip_results_and_details.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../../../bookings/presentation/providers/bookings_provider.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';
import '../../data/models/trip_models.dart';
import '../providers/trips_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Trip Results Screen
// ─────────────────────────────────────────────────────────────────────────────

class TripResultsScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> searchParams;
  const TripResultsScreen({super.key, required this.searchParams});

  @override
  ConsumerState<TripResultsScreen> createState() => _TripResultsScreenState();
}

class _TripResultsScreenState extends ConsumerState<TripResultsScreen> {
  late TripSearchParams _params;

  @override
  void initState() {
    super.initState();
    _params = TripSearchParams(
      from: widget.searchParams['from'] as String? ?? '',
      to:   widget.searchParams['to']   as String? ?? '',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tripResultsProvider.notifier).search(_params);
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(tripResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_params.from.isNotEmpty && _params.to.isNotEmpty
            ? '${_params.from} → ${_params.to}'
            : 'Search Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => context.go(RouteConstants.tripSearch),
          ),
        ],
      ),
      body: results.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, __) => const HsShimmerCard(height: 160),
        ),
        error: (e, _) => HsErrorState(
          message: e.toString(),
          onRetry: () =>
              ref.read(tripResultsProvider.notifier).search(_params),
        ),
        data: (result) => result.items.isEmpty
            ? const HsEmptyState(
                icon: Icons.search_off,
                title: 'No rides found',
                subtitle: 'Try different cities or dates.')
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '${result.totalCount} ride${result.totalCount != 1 ? "s" : ""} found',
                          style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: result.items.length +
                          (result.hasNext ? 1 : 0),
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        if (i == result.items.length) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 8),
                            child: HsButton(
                              label: 'Load More',
                              outlined: true,
                              onPressed: () => ref
                                  .read(tripResultsProvider.notifier)
                                  .loadMore(_params),
                            ),
                          );
                        }
                        return _TripCard(
                          trip: result.items[i],
                          onTap: () => context.go(
                            RouteConstants.tripDetailsPath(
                                result.items[i].tripId)),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trip Details Screen
// ─────────────────────────────────────────────────────────────────────────────

class TripDetailsScreen extends ConsumerStatefulWidget {
  final int tripId;
  const TripDetailsScreen({super.key, required this.tripId});

  @override
  ConsumerState<TripDetailsScreen> createState() =>
      _TripDetailsScreenState();
}

class _TripDetailsScreenState extends ConsumerState<TripDetailsScreen> {
  int _seats          = 1;
  int _paymentMethod  = 0; // 0=Cash, 1=Wallet, 2=PayShap

  static const _paymentOptions = [
    (value: 0, label: 'Cash',    icon: Icons.payments_outlined,           desc: 'Pay the driver in cash'),
    (value: 1, label: 'Wallet',  icon: Icons.account_balance_wallet_outlined, desc: 'Pay from your wallet balance'),
    (value: 2, label: 'PayShap', icon: Icons.swap_horiz_outlined,         desc: 'Real-time bank transfer'),
  ];

  @override
  Widget build(BuildContext context) {
    final tripAsync = ref.watch(tripDetailsProvider(widget.tripId));
    final bookVM    = ref.watch(requestBookingVMProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Trip Details')),
      body: tripAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:   (e, _) => HsErrorState(message: e.toString()),
        data:    (trip) => _buildBody(context, trip, bookVM),
      ),
    );
  }

  Widget _buildBody(BuildContext context, TripResponse trip,
      AsyncValue<dynamic> bookVM) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _RouteRow(
                        from: trip.departureCity,
                        to:   trip.destinationCity,
                        time: trip.departureTime,
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                        children: [
                          _InfoTile(
                            icon: Icons.monetization_on_outlined,
                            label: 'Price/Seat',
                            value:
                                '£${trip.pricePerSeat.toStringAsFixed(0)}',
                            highlight: true,
                          ),
                          _InfoTile(
                            icon: Icons.people_outline,
                            label: 'Seats Left',
                            value: '${trip.availableSeats}',
                          ),
                          _InfoTile(
                            icon: Icons.pin_drop_outlined,
                            label: 'Pickup',
                            value: trip.pickupLocation.isEmpty
                                ? 'TBC'
                                : trip.pickupLocation,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.person,
                        color: AppColors.primary),
                  ),
                  title: Text(trip.driverName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.vehicle,
                          style: const TextStyle(fontSize: 12)),
                      const SizedBox(height: 4),
                      HsStarRating(rating: trip.driverRating),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('How many seats do you need?',
                          style:
                              TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                                Icons.remove_circle_outline),
                            onPressed: _seats > 1
                                ? () => setState(() => _seats--)
                                : null,
                          ),
                          Text('$_seats',
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(
                                Icons.add_circle_outline),
                            onPressed:
                                _seats < trip.availableSeats
                                    ? () => setState(() => _seats++)
                                    : null,
                          ),
                          const Spacer(),
                          Text(
                            'Total: £${(trip.pricePerSeat * _seats).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Payment Method ─────────────────────────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Payment Method',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 10),
                      ..._paymentOptions.map((opt) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _PaymentOptionTile(
                          icon:     opt.icon,
                          label:    opt.label,
                          desc:     opt.desc,
                          selected: _paymentMethod == opt.value,
                          onTap:    () => setState(() => _paymentMethod = opt.value),
                        ),
                      )),
                      // Wallet balance hint when wallet selected
                      if (_paymentMethod == 1)
                        Consumer(builder: (_, ref, __) {
                          final w = ref.watch(walletProvider).valueOrNull;
                          if (w == null) return const SizedBox();
                          final total = trip.pricePerSeat * _seats;
                          final enough = w.balance >= total * 0.10;
                          return Container(
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: enough
                                  ? AppColors.success.withOpacity(0.08)
                                  : AppColors.warning.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: enough
                                    ? AppColors.success.withOpacity(0.3)
                                    : AppColors.warning.withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  enough ? Icons.check_circle_outline : Icons.warning_amber_outlined,
                                  size: 15,
                                  color: enough ? AppColors.success : AppColors.warning,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    enough
                                        ? 'Wallet balance: R ${w.balance.toStringAsFixed(2)} — 10% commission (R${(total * 0.10).toStringAsFixed(2)}) will be charged on completion.'
                                        : 'Low wallet balance (R ${w.balance.toStringAsFixed(2)}). Top up to cover the 10% fee.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: enough ? AppColors.success : AppColors.warning,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
          bottom: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4))
              ],
            ),
            child: HsButton(
              label: trip.availableSeats > 0
                  ? 'Request Booking'
                  : 'Fully Booked',
              onPressed:
                  trip.availableSeats > 0 ? () => _book(trip) : null,
              isLoading: bookVM.isLoading,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _book(TripResponse trip) async {
    final result = await ref
        .read(requestBookingVMProvider.notifier)
        .request(trip.tripId, seats: _seats, paymentMethod: _paymentMethod);
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Booking requested! Waiting for driver approval.')));
      context.go(RouteConstants.bookingList);
    } else {
      final err = ref.read(requestBookingVMProvider).error;
      if (err != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(err.toString()),
            backgroundColor: AppColors.error));
      }
    }
  }
}

// ── Supporting Widgets ────────────────────────────────────────────────────────

class _TripCard extends StatelessWidget {
  final TripResponse trip;
  final VoidCallback? onTap;
  const _TripCard({required this.trip, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.trip_origin,
                              size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(trip.departureCity,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                                overflow: TextOverflow.ellipsis)),
                        ]),
                        Row(children: [
                          const Icon(Icons.location_on,
                              size: 14, color: AppColors.error),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(trip.destinationCity,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15),
                                overflow: TextOverflow.ellipsis)),
                        ]),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '£${trip.pricePerSeat.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.people_outline,
                      size: 13, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('${trip.availableSeats} seats',
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                  const Spacer(),
                  HsStarRating(
                      rating: trip.driverRating, size: 13),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  final String from;
  final String to;
  final DateTime time;
  const _RouteRow(
      {required this.from, required this.to, required this.time});

  @override
  Widget build(BuildContext context) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.trip_origin,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(from,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on,
                    size: 14, color: AppColors.error),
                const SizedBox(width: 6),
                Text(to,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ]),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${time.day}/${time.month}/${time.year}',
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text('$h:$m',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary)),
          ],
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool highlight;
  const _InfoTile(
      {required this.icon,
      required this.label,
      required this.value,
      this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon,
            color: highlight
                ? AppColors.primary
                : AppColors.textSecondary),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: highlight ? AppColors.primary : null)),
        Text(label,
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

// ── Payment Option Tile ───────────────────────────────────────────────────────

class _PaymentOptionTile extends StatelessWidget {
  final IconData   icon;
  final String     label;
  final String     desc;
  final bool       selected;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.icon,
    required this.label,
    required this.desc,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.07)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: selected ? AppColors.primary : AppColors.textSecondary,
                size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: selected ? AppColors.primary : null,
                      )),
                  Text(desc,
                      style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle,
                  color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }
}
