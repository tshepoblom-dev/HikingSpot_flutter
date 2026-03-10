// lib/features/ride_requests/presentation/screens/my_ride_requests_screen.dart
// Passengers can view their posted ride requests and respond to driver offers.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../../data/models/ride_request_models.dart';
import '../providers/ride_requests_provider.dart';
import '../widgets/ride_request_card.dart';

class MyRideRequestsScreen extends ConsumerWidget {
  const MyRideRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myRideRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ride Requests'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () =>
                ref.read(myRideRequestsProvider.notifier).refresh(),
          ),
        ],
      ),
      body: state.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const HsShimmerCard(height: 160),
        ),
        error: (e, _) => HsErrorState(
          message: e.toString(),
          onRetry: () =>
              ref.read(myRideRequestsProvider.notifier).refresh(),
        ),
        data: (requests) {
          if (requests.isEmpty) {
            return const HsEmptyState(
              icon: Icons.hail_outlined,
              title: 'No ride requests yet',
              subtitle:
                  'Post a request and drivers along your route will offer you a seat.',
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(myRideRequestsProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final req = requests[i];
                return RideRequestCard(
                  request: req,
                  trailing: _buildActions(context, ref, req),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget? _buildActions(
      BuildContext context, WidgetRef ref, RideRequestResponse req) {
    // Driver has made an offer — passenger can accept or decline
    if (req.status == RideRequestStatus.driverOffered) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                await ref
                    .read(myRideRequestsProvider.notifier)
                    .cancelRequest(req.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Offer declined.')),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Decline'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                await ref
                    .read(myRideRequestsProvider.notifier)
                    .acceptOffer(req.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Offer accepted! Booking confirmed.'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Accept Ride'),
            ),
          ),
        ],
      );
    }

    // Open requests can be cancelled
    if (req.status == RideRequestStatus.open) {
      return SizedBox(
        width: double.infinity,
        child: TextButton.icon(
          onPressed: () => _confirmCancel(context, ref, req),
          icon: const Icon(Icons.cancel_outlined, size: 16),
          label: const Text('Cancel Request'),
          style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
        ),
      );
    }

    return null;
  }

  void _confirmCancel(
      BuildContext context, WidgetRef ref, RideRequestResponse req) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Request?'),
        content: Text(
            'Cancel your ride request from ${req.fromCity} to ${req.toCity}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref
                  .read(myRideRequestsProvider.notifier)
                  .cancelRequest(req.id);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            child: const Text('Cancel Request'),
          ),
        ],
      ),
    );
  }
}
