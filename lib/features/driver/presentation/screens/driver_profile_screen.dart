// lib/features/driver/presentation/screens/driver_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_constants.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/hs_widgets.dart';
import '../../data/models/driver_models.dart';
import '../providers/driver_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Driver Profile Screen (My Profile)
// ─────────────────────────────────────────────────────────────────────────────

class DriverProfileScreen extends ConsumerWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myDriverProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Driver Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => HsErrorState(message: e.toString()),
        data: (profile) {
          if (profile == null) {
            return HsEmptyState(
              icon: Icons.drive_eta_outlined,
              title: 'No driver profile',
              subtitle:
                  'Create a driver profile to start posting trips.',
              actionLabel: 'Create Profile',
              onAction: () => context.go(RouteConstants.driverCreate),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor:
                            AppColors.primary.withOpacity(0.1),
                        child: Text(
                          profile.fullName.isNotEmpty
                              ? profile.fullName[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                              fontSize: 40,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      Text(profile.fullName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall),
                      const SizedBox(height: 4),
                      if (profile.isVerified)
                        const HsStatusBadge(
                            label: '✓ Verified Driver',
                            color: AppColors.success),
                      const SizedBox(height: 8),
                      HsStarRating(
                          rating: profile.rating, size: 20),
                      Text('${profile.totalRatings} ratings',
                          style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Vehicle Information',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                        const Divider(height: 20),
                        _InfoRow(
                            label: 'Make',
                            value: profile.vehicleMake),
                        _InfoRow(
                            label: 'Model',
                            value: profile.vehicleModel),
                        _InfoRow(
                            label: 'Registration',
                            value: profile.vehicleRegistration,
                            isMono: true),
                        _InfoRow(
                            label: 'Seat Capacity',
                            value:
                                '${profile.seatCapacity} passengers'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                HsButton(
                  label: 'Edit Profile',
                  onPressed: () =>
                      context.go(RouteConstants.driverCreate),
                  outlined: true,
                  icon: Icons.edit_outlined,
                ),
                const SizedBox(height: 12),
                HsButton(
                  label: 'My Trips',
                  onPressed: () => context.go(RouteConstants.myTrips),
                  icon: Icons.directions_car_outlined,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Create / Edit Driver Profile Screen
// ─────────────────────────────────────────────────────────────────────────────

class CreateDriverProfileScreen extends ConsumerStatefulWidget {
  const CreateDriverProfileScreen({super.key});

  @override
  ConsumerState<CreateDriverProfileScreen> createState() =>
      _CreateDriverProfileScreenState();
}

class _CreateDriverProfileScreenState
    extends ConsumerState<CreateDriverProfileScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _makeCtrl  = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _regCtrl   = TextEditingController();
  int _seats       = 4;
  bool _isEdit     = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadExisting());
  }

  Future<void> _loadExisting() async {
    final existing =
        await ref.read(myDriverProfileProvider.future);
    if (existing != null) {
      setState(() {
        _isEdit          = true;
        _makeCtrl.text   = existing.vehicleMake;
        _modelCtrl.text  = existing.vehicleModel;
        _regCtrl.text    = existing.vehicleRegistration;
        _seats           = existing.seatCapacity;
      });
    }
  }

  @override
  void dispose() {
    _makeCtrl.dispose();
    _modelCtrl.dispose();
    _regCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final request = DriverProfileRequest(
      vehicleMake:  _makeCtrl.text.trim(),
      vehicleModel: _modelCtrl.text.trim(),
      registration: _regCtrl.text.trim().toUpperCase(),
      seatCapacity: _seats,
    );

    final result = _isEdit
        ? await ref
            .read(driverProfileVMProvider.notifier)
            .updateProfile(request)
        : await ref
            .read(driverProfileVMProvider.notifier)
            .createProfile(request);

    if (result != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              _isEdit ? 'Profile updated!' : 'Profile created!')));
      context.go(RouteConstants.driverProfile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(driverProfileVMProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit
            ? 'Edit Driver Profile'
            : 'Create Driver Profile')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      HsTextField(
                        label: 'Vehicle Make',
                        hint: 'e.g. Toyota',
                        controller: _makeCtrl,
                        prefixIcon: const Icon(
                            Icons.directions_car_outlined),
                        validator: (v) =>
                            v?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      HsTextField(
                        label: 'Vehicle Model',
                        hint: 'e.g. Camry',
                        controller: _modelCtrl,
                        prefixIcon:
                            const Icon(Icons.car_rental),
                        validator: (v) =>
                            v?.isEmpty == true ? 'Required' : null,
                      ),
                      const SizedBox(height: 16),
                      HsTextField(
                        label: 'Registration Number',
                        hint: 'e.g. AB12 CDE',
                        controller: _regCtrl,
                        prefixIcon: const Icon(
                            Icons.credit_card_outlined),
                        validator: (v) =>
                            v?.isEmpty == true ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Passenger Capacity',
                          style: TextStyle(
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                                Icons.remove_circle_outline),
                            onPressed: _seats > 1
                                ? () => setState(() => _seats--)
                                : null,
                          ),
                          Column(
                            children: [
                              Text('$_seats',
                                  style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                              const Text('passengers',
                                  style: TextStyle(
                                      color:
                                          AppColors.textSecondary,
                                      fontSize: 12)),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                                Icons.add_circle_outline),
                            onPressed: _seats < 8
                                ? () => setState(() => _seats++)
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              HsButton(
                label: _isEdit ? 'Save Changes' : 'Create Profile',
                isLoading: vm.isLoading,
                onPressed: _submit,
                icon: Icons.check_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Public Driver Profile Screen
// ─────────────────────────────────────────────────────────────────────────────

class PublicDriverProfileScreen extends ConsumerWidget {
  final int driverProfileId;
  const PublicDriverProfileScreen(
      {super.key, required this.driverProfileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync =
        ref.watch(publicDriverProfileProvider(driverProfileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Driver Profile')),
      body: profileAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => HsErrorState(message: e.toString()),
        data: (profile) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor:
                          AppColors.primary.withOpacity(0.1),
                      child: Text(
                        profile.fullName.isNotEmpty
                            ? profile.fullName[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                            fontSize: 36,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    Text(profile.fullName,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall),
                    if (profile.isVerified)
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: HsStatusBadge(
                            label: '✓ Verified',
                            color: AppColors.success)),
                    const SizedBox(height: 8),
                    HsStarRating(
                        rating: profile.rating, size: 22),
                    Text('${profile.totalRatings} ratings',
                        style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Vehicle',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                      const Divider(height: 16),
                      _InfoRow(
                          label: 'Make',
                          value: profile.vehicleMake),
                      _InfoRow(
                          label: 'Model',
                          value: profile.vehicleModel),
                      _InfoRow(
                          label: 'Seats',
                          value:
                              '${profile.seatCapacity} passengers'),
                    ],
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

// ── Shared widget ─────────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isMono;
  const _InfoRow(
      {required this.label, required this.value, this.isMono = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: isMono ? 'monospace' : null)),
          ),
        ],
      ),
    );
  }
}
