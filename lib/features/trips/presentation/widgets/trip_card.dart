// lib/features/trips/presentation/widgets/trip_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../../data/models/trip_models.dart';

class TripCard extends StatelessWidget {
  final TripResponse trip;
  final VoidCallback? onTap;
  final bool compact;

  const TripCard({super.key, required this.trip, this.onTap, this.compact = false});

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
              // ── Route row ───────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.trip_origin,
                              size: 14, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(trip.departureCity,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                                overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Container(
                            width: 1, height: 12,
                            color: AppColors.border),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                              size: 14, color: AppColors.error),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(trip.destinationCity,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                                overflow: TextOverflow.ellipsis)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
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
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 10),

              // ── Meta row ─────────────────────────────────────────────
              Row(
                children: [
                  _MetaChip(
                    icon: Icons.calendar_today_outlined,
                    label: DateFormat('EEE, dd MMM').format(trip.departureTime),
                  ),
                  const SizedBox(width: 8),
                  _MetaChip(
                    icon: Icons.access_time,
                    label: DateFormat('HH:mm').format(trip.departureTime),
                  ),
                  const Spacer(),
                  _MetaChip(
                    icon: Icons.people_outline,
                    label: '${trip.availableSeats} seats',
                    highlight: trip.availableSeats <= 2,
                  ),
                ],
              ),

              if (!compact) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.person_outline,
                      size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(trip.driverName,
                        style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis)),
                    HsStarRating(rating: trip.driverRating, size: 14),
                  ],
                ),
              ],

              if (trip.distanceKm != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.pin_drop_outlined,
                      size: 13, color: AppColors.info),
                    const SizedBox(width: 4),
                    Text('${trip.distanceKm!.toStringAsFixed(1)} km away',
                      style: const TextStyle(
                        fontSize: 11, color: AppColors.info)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlight;

  const _MetaChip({
    required this.icon, required this.label, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: highlight ? AppColors.warning.withOpacity(0.1) : AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12,
            color: highlight ? AppColors.warning : AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label,
            style: TextStyle(
              fontSize: 11,
              color: highlight ? AppColors.warning : AppColors.textSecondary,
              fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
            )),
        ],
      ),
    );
  }
}
