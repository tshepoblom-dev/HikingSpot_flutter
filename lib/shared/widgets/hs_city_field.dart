// lib/shared/widgets/hs_city_field.dart
//
// Drop-in replacement for any text field that collects a city name.
// Tapping opens a bottom-sheet with:
//   • "Use my current location" row
//   • A live-search text field wired to Google Places Autocomplete (cities only)
//   • A list of suggestions — selecting one auto-fills the field text and
//     fires onLocationSelected with the full ResolvedLocation (name + lat/lng).
//
// Usage:
//   HsCityField(
//     label: 'Departure City',
//     hint:  'e.g. Johannesburg',
//     prefixIcon: const Icon(Icons.trip_origin),
//     initialValue: _fromLocation,
//     onLocationSelected: (loc) {
//       setState(() => _fromLocation = loc);
//     },
//     validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
//   )

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/maps/google_maps_service.dart';
import '../theme/app_theme.dart';

class HsCityField extends ConsumerStatefulWidget {
  final String label;
  final String? hint;
  final Widget? prefixIcon;
  final ResolvedLocation? initialValue;
  final void Function(ResolvedLocation location) onLocationSelected;
  final String? Function(String?)? validator;

  /// ISO 3166-1 alpha-2 country code to bias autocomplete, e.g. 'ZA'.
  final String? countryBias;

  const HsCityField({
    super.key,
    required this.label,
    required this.onLocationSelected,
    this.hint,
    this.prefixIcon,
    this.initialValue,
    this.validator,
    this.countryBias,
  });

  @override
  ConsumerState<HsCityField> createState() => _HsCityFieldState();
}

class _HsCityFieldState extends ConsumerState<HsCityField> {
  final _displayCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _displayCtrl.text = widget.initialValue!.cityName;
    }
  }

  @override
  void dispose() {
    _displayCtrl.dispose();
    super.dispose();
  }

  Future<void> _openPicker() async {
    final result = await showModalBottomSheet<ResolvedLocation>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CitySearchSheet(
        countryBias: widget.countryBias,
        mapsService: ref.read(googleMapsServiceProvider),
      ),
    );

    if (result != null && mounted) {
      setState(() => _displayCtrl.text = result.cityName);
      widget.onLocationSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        TextFormField(
          controller:  _displayCtrl,
          readOnly:    true,
          onTap:       _openPicker,
          validator:   widget.validator,
          decoration: InputDecoration(
            hintText:   widget.hint,
            prefixIcon: widget.prefixIcon,
            suffixIcon: const Icon(Icons.arrow_drop_down,
                color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

// ── Bottom-sheet search panel ─────────────────────────────────────────────────

class _CitySearchSheet extends StatefulWidget {
  final GoogleMapsService mapsService;
  final String? countryBias;

  const _CitySearchSheet({
    required this.mapsService,
    this.countryBias,
  });

  @override
  State<_CitySearchSheet> createState() => _CitySearchSheetState();
}

class _CitySearchSheetState extends State<_CitySearchSheet> {
  final _searchCtrl = TextEditingController();
  final _focusNode  = FocusNode();

  List<PlaceSuggestion> _suggestions = [];
  bool _searching   = false;
  bool _locLoading  = false;

  // New session token per bottom-sheet open (groups autocomplete + details calls for billing)
  final String _sessionToken =
      DateTime.now().millisecondsSinceEpoch.toString();

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Auto-focus search field when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().length < 2) {
      setState(() { _suggestions = []; _searching = false; });
      return;
    }
    setState(() => _searching = true);
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final results = await widget.mapsService.autocomplete(
        query,
        sessionToken: _sessionToken,
        countryCode:  widget.countryBias,
      );
      if (mounted) setState(() { _suggestions = results; _searching = false; });
    });
  }

  Future<void> _onSuggestionTap(PlaceSuggestion suggestion) async {
    setState(() => _searching = true);
    final resolved = await widget.mapsService.getPlaceDetails(
      suggestion,
      sessionToken: _sessionToken,
    );
    if (mounted) {
      Navigator.of(context).pop(resolved);
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _locLoading = true);
    final resolved = await widget.mapsService.getCurrentLocation();
    if (mounted) {
      if (resolved == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not get your location. Check permissions.'),
          ),
        );
        setState(() => _locLoading = false);
        return;
      }
      Navigator.of(context).pop(resolved);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: bottomPad),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        // Clamp height: short when suggestions are few, tall when many
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle ─────────────────────────────────────────────
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Title ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Text('Search City',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ── Search field ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller:  _searchCtrl,
                focusNode:   _focusNode,
                onChanged:   _onQueryChanged,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText:   'Type a city name…',
                  prefixIcon: _searching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : const Icon(Icons.search),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _suggestions = []);
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // ── Use my location ─────────────────────────────────────────
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: _locLoading
                    ? const Padding(
                        padding: EdgeInsets.all(10),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location,
                        color: AppColors.primary, size: 20),
              ),
              title: const Text('Use my current location',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Auto-detect your city'),
              onTap: _locLoading ? null : _useCurrentLocation,
            ),

            if (_suggestions.isNotEmpty) const Divider(height: 1),

            // ── Suggestions list ────────────────────────────────────────
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 56),
                itemBuilder: (_, i) {
                  final s = _suggestions[i];
                  return ListTile(
                    leading: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on_outlined,
                          color: AppColors.textSecondary, size: 20),
                    ),
                    title: Text(s.mainText,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: s.secondaryText.isNotEmpty
                        ? Text(s.secondaryText,
                            style: const TextStyle(fontSize: 12))
                        : null,
                    onTap: () => _onSuggestionTap(s),
                  );
                },
              ),
            ),

            // Empty state when user typed but no results
            if (!_searching &&
                _suggestions.isEmpty &&
                _searchCtrl.text.length >= 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No cities found for "${_searchCtrl.text}"',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
