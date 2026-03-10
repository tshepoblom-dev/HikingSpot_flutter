// lib/features/ride_requests/presentation/widgets/ride_request_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../data/models/ride_request_models.dart';

class RideRequestCard extends StatelessWidget {
  final RideRequestResponse request;
  final VoidCallback? onTap;
  final Widget? trailing;

  const RideRequestCard({
    super.key,
    required this.request,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme  = Theme.of(context);
    final fmt    = DateFormat('EEE d MMM · HH:mm');
    final status = request.status;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Passenger + Status row ─────────────────────────────
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.primary.withOpacity(0.12),
                    child: Text(
                      request.passengerName.isNotEmpty
                          ? request.passengerName[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request.passengerName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold)),
                        if (request.passengerRating > 0)
                          Row(children: [
                            const Icon(Icons.star_rounded,
                                size: 14, color: Colors.amber),
                            const SizedBox(width: 2),
                            Text(request.passengerRating.toStringAsFixed(1),
                                style: theme.textTheme.bodySmall),
                          ]),
                      ],
                    ),
                  ),
                  _StatusBadge(status: status),
                ],
              ),
              const SizedBox(height: 14),

              // ── Route ─────────────────────────────────────────────
              Row(
                children: [
                  Column(children: [
                    const Icon(Icons.trip_origin, size: 16, color: AppColors.primary),
                    Container(width: 1, height: 20, color: Colors.grey.shade300),
                    const Icon(Icons.location_on, size: 16, color: AppColors.error),
                  ]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(request.fromCity,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600)),
                        const SizedBox(height: 14),
                        Text(request.toCity,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Details row ────────────────────────────────────────
              DefaultTextStyle(
                style: theme.textTheme.bodySmall!
                    .copyWith(color: Colors.grey.shade600),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(fmt.format(request.requestedDate)),
                    const SizedBox(width: 14),
                    const Icon(Icons.person_outline, size: 13, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text('${request.seatsNeeded} seat${request.seatsNeeded > 1 ? 's' : ''}'),
                    if (request.maxPrice != null) ...[
                      const SizedBox(width: 14),
                      const Icon(Icons.payments_outlined, size: 13, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Max R${request.maxPrice!.toStringAsFixed(0)}'),
                    ],
                  ],
                ),
              ),

              if (request.notes != null && request.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(request.notes!,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
              ],

              // ── Driver offer info (when status = driverOffered) ────
              if (status == RideRequestStatus.driverOffered &&
                  request.driverName != null) ...[
                const Divider(height: 20),
                Row(
                  children: [
                    const Icon(Icons.local_taxi_outlined,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${request.driverName} · ${request.driverVehicle ?? ''}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (request.offeredPrice != null)
                      Text(
                        'R${request.offeredPrice!.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],

              if (trailing != null) ...[
                const SizedBox(height: 12),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final RideRequestStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (status) {
      case RideRequestStatus.open:
        bg = Colors.green.shade50; fg = Colors.green.shade700; break;
      case RideRequestStatus.driverOffered:
        bg = Colors.orange.shade50; fg = Colors.orange.shade700; break;
      case RideRequestStatus.accepted:
        bg = Colors.blue.shade50; fg = Colors.blue.shade700; break;
      case RideRequestStatus.completed:
        bg = Colors.grey.shade100; fg = Colors.grey.shade600; break;
      default:
        bg = Colors.red.shade50; fg = Colors.red.shade700;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status.label,
          style: TextStyle(
              color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
