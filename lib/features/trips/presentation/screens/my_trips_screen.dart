// lib/features/trips/presentation/screens/my_trips_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../core/maps/google_maps_service.dart';
import '../../../../core/maps/map_location_picker_screen.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_city_field.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../../data/models/trip_models.dart';
import '../providers/trips_provider.dart';
import '../widgets/trip_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Create Trip Screen
// ─────────────────────────────────────────────────────────────────────────────

class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey    = GlobalKey<FormState>();
  final _priceCtrl  = TextEditingController();

  // Resolved locations (city name + lat/lng) from HsCityField
  ResolvedLocation? _fromLocation;
  ResolvedLocation? _toLocation;
  ResolvedLocation? _pickupLocation;

  DateTime? _departureTime;
  int       _seats = 2;

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  // ── Date / time picker ───────────────────────────────────────────────────

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 1)),
      firstDate:   DateTime.now(),
      lastDate:    DateTime.now().add(const Duration(days: 90)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(hours: 1))),
    );
    if (time == null) return;

    setState(() {
      _departureTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  // ── Map picker for pickup location ───────────────────────────────────────
  // Opens the full-screen map; the returned ResolvedLocation has a full
  // street address (not just city) plus exact lat/lng.

  Future<void> _pickPickupOnMap() async {
    final result = await Navigator.push<ResolvedLocation>(
      context,
      MaterialPageRoute(
        builder: (_) => MapLocationPickerScreen(
          initialLocation: _pickupLocation,
          title: 'Pick Pickup Point',
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() => _pickupLocation = result);
    }
  }

  // ── Submit ───────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fromLocation == null || _toLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select departure and destination cities.')),
      );
      return;
    }
    if (_departureTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select departure date & time.')),
      );
      return;
    }

    final request = TripCreateRequest(
      departureCity:        _fromLocation!.cityName,
      destinationCity:      _toLocation!.cityName,
      departureTime:        _departureTime!,
      seats:                _seats,
      pricePerSeat:         double.tryParse(_priceCtrl.text.trim()) ?? 0,
      pickupLocation:       _pickupLocation?.fullAddress ?? '',
      pickupLatitude:       _pickupLocation?.latitude    ?? _fromLocation!.latitude,
      pickupLongitude:      _pickupLocation?.longitude   ?? _fromLocation!.longitude,
      destinationLatitude:  _toLocation!.latitude,
      destinationLongitude: _toLocation!.longitude,
    );

    final result =
        await ref.read(createTripVMProvider.notifier).createTrip(request);
    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Trip posted successfully!')),
      );
      context.go(RouteConstants.myTrips);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(createTripVMProvider);

    ref.listen(createTripVMProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()),
              backgroundColor: AppColors.error)),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Post a Trip')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Route card ────────────────────────────────────────────
              _SectionCard(
                title: 'Route',
                icon: Icons.route,
                child: Column(
                  children: [
                    // Departure city — autocomplete + current location
                    HsCityField(
                      label: 'Departure City',
                      hint:  'e.g. Johannesburg',
                      prefixIcon: const Icon(Icons.trip_origin,
                          color: AppColors.primary),
                      initialValue: _fromLocation,
                      onLocationSelected: (loc) =>
                          setState(() => _fromLocation = loc),
                      validator: (_) => _fromLocation == null
                          ? 'Select departure city' : null,
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

                    // Destination city
                    HsCityField(
                      label: 'Destination City',
                      hint:  'e.g. Pretoria',
                      prefixIcon: const Icon(Icons.location_on,
                          color: AppColors.error),
                      initialValue: _toLocation,
                      onLocationSelected: (loc) =>
                          setState(() => _toLocation = loc),
                      validator: (_) => _toLocation == null
                          ? 'Select destination city' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Departure time ────────────────────────────────────────
              _SectionCard(
                title: 'Departure',
                icon: Icons.schedule,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today,
                      color: AppColors.primary),
                  title: Text(
                    _departureTime == null
                        ? 'Select departure date & time'
                        : DateFormat('EEE, dd MMM yyyy · HH:mm')
                            .format(_departureTime!),
                    style: TextStyle(
                      color: _departureTime == null
                          ? AppColors.textHint
                          : AppColors.textPrimary,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _pickDateTime,
                ),
              ),
              const SizedBox(height: 12),

              // ── Pickup location ───────────────────────────────────────
              _SectionCard(
                title: 'Pickup Point',
                icon: Icons.pin_drop,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Where exactly should passengers meet you?',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),

                    // Selected pickup display
                    if (_pickupLocation != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_pin,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_pickupLocation!.cityName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                  if (_pickupLocation!.fullAddress !=
                                      _pickupLocation!.cityName)
                                    Text(
                                      _pickupLocation!.fullAddress,
                                      style: const TextStyle(fontSize: 12,
                                          color: AppColors.textSecondary),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  size: 18, color: AppColors.primary),
                              onPressed: _pickPickupOnMap,
                              tooltip: 'Change',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.map_outlined),
                        label: Text(_pickupLocation == null
                            ? 'Pin on Map' : 'Move Pin'),
                        onPressed: _pickPickupOnMap,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ── Price & seats ─────────────────────────────────────────
              _SectionCard(
                title: 'Details',
                icon: Icons.info_outline,
                child: Column(
                  children: [
                    HsTextField(
                      label: 'Price per Seat (R)',
                      hint: '0.00',
                      controller: _priceCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      prefixIcon: const Icon(Icons.monetization_on_outlined),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        if (double.tryParse(v) == null)
                          return 'Enter a valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Icon(Icons.event_seat_outlined,
                            color: AppColors.primary),
                        const SizedBox(width: 10),
                        const Text('Available Seats',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _seats > 1
                              ? () => setState(() => _seats--)
                              : null,
                        ),
                        Text('$_seats',
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: _seats < 7
                              ? () => setState(() => _seats++)
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              HsButton(
                label: 'Post Trip',
                isLoading: vm.isLoading,
                onPressed: _submit,
                icon: Icons.upload_rounded,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable section card ─────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String  title;
  final IconData icon;
  final Widget  child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// My Trips Screen
// ─────────────────────────────────────────────────────────────────────────────

class MyTripsScreen extends ConsumerWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(myTripsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go(RouteConstants.createTrip),
          ),
        ],
      ),
      body: tripsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => HsErrorState(
          message: e.toString(),
          onRetry: () => ref.refresh(myTripsProvider),
        ),
        data: (trips) => trips.isEmpty
            ? HsEmptyState(
                icon: Icons.directions_car_outlined,
                title: 'No trips yet',
                subtitle: 'Post your first trip and start earning!',
                actionLabel: 'Post a Trip',
                onAction: () => context.go(RouteConstants.createTrip),
              )
            : RefreshIndicator(
                onRefresh: () async => ref.refresh(myTripsProvider),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: trips.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => TripCard(
                    trip: trips[i],
                    onTap: () => context.go(
                        RouteConstants.tripDetailsPath(trips[i].tripId)),
                  ),
                ),
              ),
      ),
    );
  }
}
