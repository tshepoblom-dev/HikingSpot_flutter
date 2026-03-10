// lib/features/trips/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/models/trip_models.dart';
import '../providers/trips_provider.dart';
import '../widgets/trip_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _fromCtrl = TextEditingController();
  final _toCtrl   = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tripResultsProvider.notifier).search(const TripSearchParams());
    });
  }

  @override
  void dispose() {
    _fromCtrl.dispose(); _toCtrl.dispose(); super.dispose();
  }

  void _search() {
    final params = TripSearchParams(
      from: _fromCtrl.text.trim(),
      to:   _toCtrl.text.trim(),
    );
    context.go(
      RouteConstants.tripResults,
      extra: {'from': params.from, 'to': params.to},
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth     = ref.watch(authStateProvider).valueOrNull;
    final featured = ref.watch(tripResultsProvider);
    final isDriver = auth?.isDriver ?? false;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello, ${auth?.fullName.split(' ').first ?? 'Traveller'} 👋',
                            style: const TextStyle(
                              color: Colors.white, fontSize: 22,
                              fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(isDriver
                              ? 'Ready to drive today?'
                              : 'Where are you heading today?',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8), fontSize: 14)),
                        ],
                      ),
                      // Driver quick action
                      if (isDriver)
                        _QuickAction(
                          icon: Icons.add_circle_outline,
                          label: 'Post Trip',
                          onTap: () => context.go(RouteConstants.createTrip),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Search Card ────────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20, offset: const Offset(0, 8))],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _SearchField(
                          icon: Icons.trip_origin,
                          iconColor: AppColors.primary,
                          hint: 'Departure city',
                          controller: _fromCtrl,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Divider(),
                        ),
                        _SearchField(
                          icon: Icons.location_on,
                          iconColor: AppColors.error,
                          hint: 'Destination city',
                          controller: _toCtrl,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _search,
                          icon: const Icon(Icons.search),
                          label: const Text('Search Rides'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Passenger quick-action strip ──────────────────────
                  if (!isDriver) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.hail_outlined,
                            label: 'Post Ride Request',
                            subtitle: 'Drivers will come to you',
                            color: Colors.white.withOpacity(0.15),
                            onTap: () => context.go(RouteConstants.createRideRequest),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _QuickActionCard(
                            icon: Icons.list_alt_outlined,
                            label: 'My Requests',
                            subtitle: 'See driver offers',
                            color: Colors.white.withOpacity(0.15),
                            onTap: () => context.go(RouteConstants.myRideRequests),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // ── Driver: view passenger requests ────────────────────
                  if (isDriver) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => context.go(RouteConstants.rideRequests),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.hail_outlined,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('View Passenger Requests',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13)),
                                  Text(
                                    'Passengers looking for rides on your route',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right,
                                color: Colors.white.withOpacity(0.7)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Stats Strip ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.primaryDark,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _StatChip(value: '10K+', label: 'Trips'),
                  _StatDivider(),
                  _StatChip(value: '50K+', label: 'Passengers'),
                  _StatDivider(),
                  _StatChip(value: '200+', label: 'Cities'),
                ],
              ),
            ),
          ),

          // ── Available Trips ────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverToBoxAdapter(
              child: HsSectionHeader(
                title: 'Available Rides',
                action: 'See all',
                onAction: () => context.go(RouteConstants.tripSearch),
              ),
            ),
          ),

          featured.when(
            loading: () => SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, __) => const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: HsShimmerCard(height: 140),
                  ),
                  childCount: 4,
                ),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: HsErrorState(message: e.toString())),
            data: (result) => result.items.isEmpty
                ? const SliverFillRemaining(
                    child: HsEmptyState(
                      icon: Icons.directions_car_outlined,
                      title: 'No trips available',
                      subtitle: 'Check back soon for new rides!',
                    ))
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TripCard(
                            trip: result.items[i],
                            onTap: () => context.go(
                              RouteConstants.tripDetailsPath(result.items[i].tripId)),
                          ),
                        ),
                        childCount: result.items.length,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Supporting Widgets ────────────────────────────────────────────────────────

class _SearchField extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String hint;
  final TextEditingController controller;

  const _SearchField({
    required this.icon, required this.iconColor,
    required this.hint, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(
          color: Colors.white.withOpacity(0.7), fontSize: 12)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();
  @override
  Widget build(BuildContext context) =>
      Container(height: 36, width: 1, color: Colors.white.withOpacity(0.2));
}
