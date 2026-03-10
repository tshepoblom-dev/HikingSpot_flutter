// lib/shared/widgets/hs_widgets.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_theme.dart';

// ── Loading Button ────────────────────────────────────────────────────────────

class HsButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;
  final IconData? icon;
  final Color? color;
  final double? width;

  const HsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.outlined = false,
    this.icon,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(width: 22, height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
        : icon != null
            ? Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(icon, size: 20), const SizedBox(width: 8), Text(label),
              ])
            : Text(label);

    if (outlined) {
      return SizedBox(
        width: width,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      );
    }

    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    );
  }
}

// ── Labeled Text Field ────────────────────────────────────────────────────────

class HsTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final void Function(String)? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const HsTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 6),
        TextFormField(
          controller:   controller,
          obscureText:  obscureText,
          keyboardType: keyboardType,
          validator:    validator,
          maxLines:     maxLines,
          onChanged:    onChanged,
          readOnly:     readOnly,
          onTap:        onTap,
          decoration: InputDecoration(
            hintText:    hint,
            prefixIcon:  prefixIcon,
            suffixIcon:  suffixIcon,
          ),
        ),
      ],
    );
  }
}

// ── Star Rating ───────────────────────────────────────────────────────────────

class HsStarRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool showValue;

  const HsStarRating({
    super.key,
    required this.rating,
    this.size = 16,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBarIndicator(
          rating: rating,
          itemSize: size,
          itemBuilder: (_, __) => const Icon(Icons.star, color: AppColors.warning),
          unratedColor: AppColors.border,
        ),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(rating.toStringAsFixed(1),
            style: TextStyle(fontSize: size - 2, color: AppColors.textSecondary)),
        ]
      ],
    );
  }
}

// ── Status Badge ──────────────────────────────────────────────────────────────

class HsStatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const HsStatusBadge({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

// ── Shimmer Card ──────────────────────────────────────────────────────────────

class HsShimmerCard extends StatelessWidget {
  final double height;
  const HsShimmerCard({super.key, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class HsSectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const HsSectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (action != null)
          TextButton(
            onPressed: onAction,
            child: Text(action!, style: const TextStyle(color: AppColors.primary)),
          ),
      ],
    );
  }
}

// ── Error State ───────────────────────────────────────────────────────────────

class HsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const HsErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary)),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              HsButton(label: 'Try Again', onPressed: onRetry, width: 140),
            ]
          ],
        ),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class HsEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const HsEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: AppColors.border),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary)),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              HsButton(label: actionLabel!, onPressed: onAction, width: 200),
            ]
          ],
        ),
      ),
    );
  }
}

// ── Date Formatter Helpers ────────────────────────────────────────────────────

extension DateFormatExt on DateTime {
  String get tripDate => DateFormat('EEE, dd MMM yyyy').format(this);
  String get tripTime => DateFormat('HH:mm').format(this);
  String get tripDateTime => DateFormat('EEE, dd MMM · HH:mm').format(this);
  String get chatTime => DateFormat('HH:mm').format(this);
}
