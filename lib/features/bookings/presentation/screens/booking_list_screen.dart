// lib/features/bookings/presentation/screens/booking_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../../../wallet/presentation/widgets/wallet_balance_chip.dart';
import '../../data/models/booking_models.dart';
import '../providers/bookings_provider.dart';

class BookingListScreen extends ConsumerWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(myBookingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => HsErrorState(
          message: e.toString(),
          onRetry: () => ref.refresh(myBookingsProvider),
        ),
        data: (bookings) => bookings.isEmpty
            ? Column(
                children: [
                  const WalletBalanceBanner(),
                  Expanded(
                    child: HsEmptyState(
                      icon: Icons.bookmark_outline,
                      title: 'No bookings yet',
                      subtitle: 'Search for rides and book your seat!',
                      actionLabel: 'Find a Ride',
                      onAction: () => context.go(RouteConstants.tripSearch),
                    ),
                  ),
                ],
              )
            : RefreshIndicator(
                onRefresh: () async => ref.refresh(myBookingsProvider),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: WalletBalanceBanner()),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (_, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _BookingCard(
                              booking: bookings[i],
                              onCancel: () => ref
                                  .read(myBookingsProvider.notifier)
                                  .cancelBooking(bookings[i].bookingId),
                              onChat: bookings[i].status == BookingStatus.approved
                                  ? () => context.go(
                                      RouteConstants.chatPath(bookings[i].bookingId),
                                      extra: {
                                        'tripTitle':
                                          '${bookings[i].departureCity} → ${bookings[i].destinationCity}'
                                      })
                                  : null,
                            ),
                          ),
                          childCount: bookings.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingResponse booking;
  final VoidCallback? onCancel;
  final VoidCallback? onChat;

  const _BookingCard({
    required this.booking, this.onCancel, this.onChat,
  });

  Color _statusColor() {
    return switch (booking.status) {
      BookingStatus.approved  => AppColors.success,
      BookingStatus.rejected  => AppColors.error,
      BookingStatus.cancelled => AppColors.textSecondary,
      _                       => AppColors.warning,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${booking.departureCity} → ${booking.destinationCity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                HsStatusBadge(
                  label: booking.status.name.toUpperCase(),
                  color: _statusColor(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                  size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  DateFormat('EEE, dd MMM · HH:mm')
                      .format(booking.departureTime),
                  style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
                const Spacer(),
                const Icon(Icons.people_outline,
                  size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${booking.seatsRequested} seat(s)',
                  style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),

            if (booking.status == BookingStatus.pending ||
                booking.status == BookingStatus.approved) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (onChat != null)
                    Expanded(
                      child: HsButton(
                        label: 'Chat',
                        onPressed: onChat,
                        icon: Icons.chat_outlined,
                        outlined: true,
                      ),
                    ),
                  if (onChat != null) const SizedBox(width: 8),
                  Expanded(
                    child: HsButton(
                      label: 'Cancel',
                      onPressed: onCancel,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Manage Bookings (Driver)
// ─────────────────────────────────────────────────────────────────────────────

class ManageBookingsScreen extends ConsumerWidget {
  const ManageBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(driverBookingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Requests')),
      body: bookingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => HsErrorState(message: e.toString()),
        data: (bookings) {
          final pending = bookings
              .where((b) => b.status == BookingStatus.pending).toList();
          final others  = bookings
              .where((b) => b.status != BookingStatus.pending).toList();

          if (bookings.isEmpty) {
            return const HsEmptyState(
              icon: Icons.inbox_outlined,
              title: 'No requests yet',
              subtitle: 'Booking requests will appear here.');
          }

          return RefreshIndicator(
            onRefresh: () async => ref.refresh(driverBookingsProvider),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (pending.isNotEmpty) ...[
                  const HsSectionHeader(title: 'Pending'),
                  const SizedBox(height: 8),
                  ...pending.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _DriverBookingCard(
                      booking: b,
                      onApprove: () => ref
                          .read(driverBookingsProvider.notifier)
                          .approve(b.bookingId),
                      onReject: () => ref
                          .read(driverBookingsProvider.notifier)
                          .reject(b.bookingId),
                      onChat: () => context.go(
                        RouteConstants.chatPath(b.bookingId),
                        extra: {'tripTitle': '${b.departureCity} → ${b.destinationCity}'}),
                    ),
                  )),
                  const SizedBox(height: 16),
                ],
                if (others.isNotEmpty) ...[
                  const HsSectionHeader(title: 'Past Requests'),
                  const SizedBox(height: 8),
                  ...others.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _DriverBookingCard(booking: b),
                  )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DriverBookingCard extends StatelessWidget {
  final BookingResponse booking;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onChat;

  const _DriverBookingCard({
    required this.booking, this.onApprove, this.onReject, this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = booking.status == BookingStatus.pending;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isPending
            ? const BorderSide(color: AppColors.warning, width: 1.5)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(booking.passengerName,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                HsStatusBadge(
                  label: booking.status.name.toUpperCase(),
                  color: switch (booking.status) {
                    BookingStatus.approved  => AppColors.success,
                    BookingStatus.rejected  => AppColors.error,
                    BookingStatus.pending   => AppColors.warning,
                    _                       => AppColors.textSecondary,
                  },
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text('${booking.departureCity} → ${booking.destinationCity}',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            Text(
              '${booking.seatsRequested} seat(s) · '
              '${DateFormat('dd MMM HH:mm').format(booking.departureTime)}',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),

            if (isPending && (onApprove != null || onReject != null)) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  if (onApprove != null)
                    Expanded(
                      child: HsButton(
                        label: 'Approve',
                        onPressed: onApprove,
                        color: AppColors.success,
                      ),
                    ),
                  if (onApprove != null && onReject != null)
                    const SizedBox(width: 8),
                  if (onReject != null)
                    Expanded(
                      child: HsButton(
                        label: 'Reject',
                        onPressed: onReject,
                        outlined: true,
                        color: AppColors.error,
                      ),
                    ),
                  if (onChat != null) ...[
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      icon: const Icon(Icons.chat_outlined),
                      onPressed: onChat,
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
