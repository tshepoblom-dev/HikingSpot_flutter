// lib/shared/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color primary        = Color(0xFF1B8A57);
  static const Color primaryLight   = Color(0xFF4CAF77);
  static const Color primaryDark    = Color(0xFF0F6B40);
  static const Color secondary      = Color(0xFF0D6EFD);
  static const Color accent         = Color(0xFFFFC107);
  static const Color error          = Color(0xFFDC3545);
  static const Color success        = Color(0xFF28A745);
  static const Color warning        = Color(0xFFFFC107);
  static const Color info           = Color(0xFF17A2B8);

  // Light
  static const Color background     = Color(0xFFF8F9FA);
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color cardBg         = Color(0xFFFFFFFF);
  static const Color divider        = Color(0xFFE9ECEF);
  static const Color textPrimary    = Color(0xFF212529);
  static const Color textSecondary  = Color(0xFF6C757D);
  static const Color textHint       = Color(0xFFADB5BD);
  static const Color border         = Color(0xFFDEE2E6);

  // Dark
  static const Color darkBackground  = Color(0xFF121212);
  static const Color darkSurface     = Color(0xFF1E1E1E);
  static const Color darkCard        = Color(0xFF2A2A2A);
  static const Color darkText        = Color(0xFFF8F9FA);
  static const Color darkTextSec     = Color(0xFFADB5BD);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF0D6EFD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [primaryDark, Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const List<Color> statusColors = [
    Color(0xFFFFC107), // Pending
    Color(0xFF28A745), // Approved
    Color(0xFFDC3545), // Rejected
    Color(0xFF6C757D), // Cancelled
  ];
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _buildLight();
  static ThemeData get dark  => _buildDark();

  static ThemeData _buildLight() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _textTheme(AppColors.textPrimary),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBg,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.06),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textHint,
          fontSize: 14,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.background,
        selectedColor: AppColors.primary.withOpacity(0.15),
        labelStyle: GoogleFonts.poppins(fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: AppColors.border),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static ThemeData _buildDark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      textTheme: _textTheme(AppColors.darkText),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
      ),
    );
  }

  static TextTheme _textTheme(Color color) => TextTheme(
    displayLarge:  GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold,   color: color),
    displayMedium: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold,   color: color),
    displaySmall:  GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600,   color: color),
    headlineLarge: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600,   color: color),
    headlineMedium:GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600,   color: color),
    headlineSmall: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600,   color: color),
    titleLarge:    GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600,   color: color),
    titleMedium:   GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500,   color: color),
    titleSmall:    GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500,   color: color),
    bodyLarge:     GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.normal, color: color),
    bodyMedium:    GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.normal, color: color),
    bodySmall:     GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.normal, color: color),
    labelLarge:    GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600,   color: color),
    labelMedium:   GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500,   color: color),
    labelSmall:    GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500,   color: color),
  );
}
