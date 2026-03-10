// lib/features/trips/presentation/screens/trip_search_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/maps/google_maps_service.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_city_field.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../../data/models/trip_models.dart';
import '../providers/trips_provider.dart';

class TripSearchScreen extends ConsumerStatefulWidget {
  const TripSearchScreen({super.key});

  @override
  ConsumerState<TripSearchScreen> createState() => _TripSearchScreenState();
}

class _TripSearchScreenState extends ConsumerState<TripSearchScreen> {
  ResolvedLocation? _fromLocation;
  ResolvedLocation? _toLocation;
  DateTime? _date;
  int _seats = 1;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate:   DateTime.now(),
      lastDate:    DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _search() {
    final params = TripSearchParams(
      from:        _fromLocation?.cityName  ?? '',
      to:          _toLocation?.cityName    ?? '',
      date:        _date,
      latitude:    _fromLocation?.latitude,
      longitude:   _fromLocation?.longitude,
      seatsNeeded: _seats,
    );
    ref.read(tripSearchStateProvider.notifier).updateParams(params);
    context.go(RouteConstants.tripResults, extra: params.toJson());
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _date == null
        ? 'Any date'
        : DateFormat('EEE d MMM').format(_date!);

    return Scaffold(
      appBar: AppBar(title: const Text('Find a Ride')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Route card ──────────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    HsCityField(
                      label: 'From',
                      hint:  'Departure city',
                      prefixIcon: const Icon(Icons.trip_origin,
                          color: AppColors.primary),
                      initialValue: _fromLocation,
                      onLocationSelected: (loc) =>
                          setState(() => _fromLocation = loc),
                    ),
                    const SizedBox(height: 8),

                    // Swap button
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.swap_vert,
                            color: AppColors.primary),
                        tooltip: 'Swap cities',
                        onPressed: () => setState(() {
                          final tmp   = _fromLocation;
                          _fromLocation = _toLocation;
                          _toLocation   = tmp;
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),

                    HsCityField(
                      label: 'To',
                      hint:  'Destination city',
                      prefixIcon: const Icon(Icons.location_on,
                          color: AppColors.error),
                      initialValue: _toLocation,
                      onLocationSelected: (loc) =>
                          setState(() => _toLocation = loc),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Date & seats row ────────────────────────────────────────
            Row(
              children: [
                // Date picker
                Expanded(
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today,
                          color: AppColors.primary),
                      title: Text(dateLabel,
                          style: const TextStyle(fontSize: 14)),
                      subtitle: const Text('Date',
                          style: TextStyle(fontSize: 11)),
                      onTap: _pickDate,
                      trailing: _date != null
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () =>
                                  setState(() => _date = null),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Seats stepper
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Seats',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.remove_circle_outline),
                                onPressed: _seats > 1
                                    ? () => setState(() => _seats--)
                                    : null,
                                iconSize: 20,
                              ),
                              Text('$_seats',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(
                                    Icons.add_circle_outline),
                                onPressed: _seats < 8
                                    ? () => setState(() => _seats++)
                                    : null,
                                iconSize: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Near me hint
            if (_fromLocation != null) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    const Icon(Icons.radar, size: 14,
                        color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Searching near ${_fromLocation!.cityName}'
                        ' (50 km radius)',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            HsButton(
              label: 'Search Rides',
              onPressed: _search,
              icon: Icons.search,
            ),
          ],
        ),
      ),
    );
  }
}
