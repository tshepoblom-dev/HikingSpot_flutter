// lib/features/ride_requests/presentation/screens/create_ride_request_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/maps/google_maps_service.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_city_field.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../../data/models/ride_request_models.dart';
import '../providers/ride_requests_provider.dart';

class CreateRideRequestScreen extends ConsumerStatefulWidget {
  const CreateRideRequestScreen({super.key});

  @override
  ConsumerState<CreateRideRequestScreen> createState() =>
      _CreateRideRequestScreenState();
}

class _CreateRideRequestScreenState
    extends ConsumerState<CreateRideRequestScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _notesCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  ResolvedLocation? _fromLocation;
  ResolvedLocation? _toLocation;
  DateTime?         _requestedDate;
  int               _seats = 1;

  @override
  void dispose() {
    _notesCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(hours: 2)),
      firstDate:   DateTime.now(),
      lastDate:    DateTime.now().add(const Duration(days: 90)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          DateTime.now().add(const Duration(hours: 2))),
    );
    if (time == null || !mounted) return;

    setState(() {
      _requestedDate = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_fromLocation == null || _toLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select departure and destination cities.')),
      );
      return;
    }
    if (_requestedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date & time')),
      );
      return;
    }

    final request = RideRequestCreateRequest(
      fromCity:      _fromLocation!.cityName,
      toCity:        _toLocation!.cityName,
      requestedDate: _requestedDate!,
      seatsNeeded:   _seats,
      maxPrice:      double.tryParse(_priceCtrl.text.trim()),
      notes:         _notesCtrl.text.trim().isEmpty
                         ? null : _notesCtrl.text.trim(),
    );

    final result = await ref
        .read(createRideRequestVMProvider.notifier)
        .submit(request);

    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Ride request posted! Drivers will be notified.'),
          backgroundColor: AppColors.primary,
        ),
      );
      context.pop();
    } else {
      final err = ref.read(createRideRequestVMProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err?.toString() ?? 'Failed to post request'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state   = ref.watch(createRideRequestVMProvider);
    final loading = state.isLoading;
    final fmt     = DateFormat('EEE d MMM yyyy · HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request a Ride'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Info banner ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Post your ride request and drivers along your '
                        'route will offer you a seat.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── From city ───────────────────────────────────────────
              HsCityField(
                label: 'Departure City',
                hint:  'e.g. Johannesburg',
                prefixIcon: const Icon(Icons.trip_origin),
                initialValue: _fromLocation,
                onLocationSelected: (loc) =>
                    setState(() => _fromLocation = loc),
                validator: (_) => _fromLocation == null
                    ? 'Select departure city' : null,
              ),
              const SizedBox(height: 12),

              // Swap
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
              const SizedBox(height: 4),

              // ── To city ─────────────────────────────────────────────
              HsCityField(
                label: 'Destination City',
                hint:  'e.g. Pretoria',
                prefixIcon: const Icon(Icons.location_on),
                initialValue: _toLocation,
                onLocationSelected: (loc) =>
                    setState(() => _toLocation = loc),
                validator: (_) => _toLocation == null
                    ? 'Select destination city' : null,
              ),
              const SizedBox(height: 16),

              // ── Date & time ─────────────────────────────────────────
              GestureDetector(
                onTap: _pickDateTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: _requestedDate != null
                            ? AppColors.primary : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _requestedDate != null
                            ? fmt.format(_requestedDate!)
                            : 'Pick date & time',
                        style: TextStyle(
                          fontSize: 15,
                          color: _requestedDate != null
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Seats ───────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Seats Needed',
                      style: Theme.of(context).textTheme.titleSmall),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () =>
                            setState(() { if (_seats > 1) _seats--; }),
                        icon: const Icon(Icons.remove_circle_outline),
                        color: AppColors.primary,
                      ),
                      Text('$_seats',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () =>
                            setState(() { if (_seats < 8) _seats++; }),
                        icon: const Icon(Icons.add_circle_outline),
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Max price ───────────────────────────────────────────
              HsTextField(
                controller: _priceCtrl,
                label: 'Maximum Price per Seat (optional)',
                hint: 'e.g. 150',
                prefixIcon: const Icon(Icons.payments_outlined),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // ── Notes ───────────────────────────────────────────────
              HsTextField(
                controller: _notesCtrl,
                label: 'Notes (optional)',
                hint: "e.g. I'm near Fourways mall, flexible on time",
                prefixIcon: const Icon(Icons.notes_outlined),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // ── Submit ──────────────────────────────────────────────
              HsButton(
                label: 'Post Ride Request',
                onPressed: loading ? null : _submit,
                isLoading: loading,
                icon: Icons.send_outlined,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
