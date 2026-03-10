// lib/core/maps/map_location_picker_screen.dart
//
// Full-screen OpenStreetMap picker with a centred crosshair pin.
// Panning the map triggers a Nominatim reverse-geocode (600 ms debounce).
// Tapping "Confirm Location" pops the screen with the selected [ResolvedLocation].
//
// Replaces the previous Google Maps implementation.
// Public interface (constructor + return type) is unchanged.
//
// Depends on:
//   flutter_map: ^7.0.0
//   latlong2:    ^0.9.0
//   geolocator:  ^13.0.0  (unchanged)

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'google_maps_service.dart';

class MapLocationPickerScreen extends ConsumerStatefulWidget {
  final ResolvedLocation? initialLocation;
  final String title;

  const MapLocationPickerScreen({
    super.key,
    this.initialLocation,
    this.title = 'Choose Location',
  });

  @override
  ConsumerState<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState
    extends ConsumerState<MapLocationPickerScreen> {
  final _mapController = MapController();

  // Default centre: Johannesburg, ZA
  static const _defaultCentre = LatLng(-26.2041, 28.0473);
  static const _defaultZoom   = 13.0;

  late LatLng _centre;
  ResolvedLocation? _resolved;
  bool _isLoading = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _centre  = LatLng(
        widget.initialLocation!.latitude,
        widget.initialLocation!.longitude,
      );
      _resolved = widget.initialLocation;
    } else {
      _centre = _defaultCentre;
      // Try to jump to the device's real position after the first frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryStartAtCurrentLocation();
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  // ── Location helpers ───────────────────────────────────────────────────────

  Future<void> _tryStartAtCurrentLocation() async {
    final svc = ref.read(googleMapsServiceProvider);
    final pos = await svc.getCurrentPosition();
    if (pos != null && mounted) {
      final latLng = LatLng(pos.latitude, pos.longitude);
      _mapController.move(latLng, 14);
      setState(() => _centre = latLng);
      _reverseGeocode(latLng);
    }
  }

  Future<void> _myLocation() async {
    final svc = ref.read(googleMapsServiceProvider);
    final pos = await svc.getCurrentPosition();
    if (!mounted) return;
    if (pos == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Could not get your location. Check permissions.')),
      );
      return;
    }
    final latLng = LatLng(pos.latitude, pos.longitude);
    _mapController.move(latLng, 15);
  }

  // ── Map interaction ────────────────────────────────────────────────────────

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    if (!hasGesture) return;
    _centre = camera.center;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _reverseGeocode(_centre);
    });
  }

  Future<void> _reverseGeocode(LatLng pos) async {
    setState(() => _isLoading = true);
    final result = await ref
        .read(googleMapsServiceProvider)
        .reverseGeocode(pos.latitude, pos.longitude);
    if (mounted) {
      setState(() {
        _resolved  = result;
        _isLoading = false;
      });
    }
  }

  void _confirm() {
    if (_resolved == null) return;
    Navigator.of(context).pop(_resolved);
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // ── OpenStreetMap tile layer ────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _centre,
              initialZoom:   _defaultZoom,
              onPositionChanged: _onPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                // Required by OSM tile usage policy
                userAgentPackageName: 'com.hikingspot.app',
                // Keep tile cache reasonable
                maxNativeZoom: 19,
              ),
              // Attribution required by ODbL licence
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                ],
              ),
            ],
          ),

          // ── Fixed crosshair pin at centre ────────────────────────────
          const Center(
            child: Padding(
              // Lift by half the pin height so the tip sits on the target
              padding: EdgeInsets.only(bottom: 36),
              child: Icon(
                Icons.location_pin,
                color: Color(0xFF2D7A4F),
                size: 48,
              ),
            ),
          ),

          // ── My-location FAB ──────────────────────────────────────────
          Positioned(
            right: 12,
            bottom: 180,
            child: FloatingActionButton.small(
              heroTag: 'my_loc',
              onPressed: _myLocation,
              backgroundColor: Colors.white,
              child:
                  const Icon(Icons.my_location, color: Color(0xFF2D7A4F)),
            ),
          ),

          // ── Address bar + Confirm button ──────────────────────────────
          Positioned(
            left:  0,
            right: 0,
            bottom: 0,
            child: _AddressConfirmBar(
              resolved:  _resolved,
              isLoading: _isLoading,
              onConfirm: _resolved != null ? _confirm : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Address bar ───────────────────────────────────────────────────────────────

class _AddressConfirmBar extends StatelessWidget {
  final ResolvedLocation? resolved;
  final bool isLoading;
  final VoidCallback? onConfirm;

  const _AddressConfirmBar({
    required this.resolved,
    required this.isLoading,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Address display
          Row(
            children: [
              const Icon(Icons.location_pin,
                  color: Color(0xFF2D7A4F), size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: isLoading
                    ? const _LoadingDots()
                    : resolved != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                resolved!.cityName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              if (resolved!.fullAddress != resolved!.cityName)
                                Text(
                                  resolved!.fullAddress,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          )
                        : Text(
                            'Move the map to select a location',
                            style:
                                TextStyle(color: Colors.grey.shade500),
                          ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Confirm
          ElevatedButton.icon(
            onPressed: onConfirm,
            icon: const Icon(Icons.check_circle_outline, size: 20),
            label: const Text('Confirm Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D7A4F),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingDots extends StatelessWidget {
  const _LoadingDots();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16, height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.grey.shade400,
          ),
        ),
        const SizedBox(width: 8),
        Text('Finding address…',
            style: TextStyle(color: Colors.grey.shade500)),
      ],
    );
  }
}
