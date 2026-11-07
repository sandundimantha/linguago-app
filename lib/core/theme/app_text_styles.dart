import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Semantic typography scale using Nunito Sans.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Nunito Sans';

  /// Builds a complete TextTheme using Nunito Sans with exact weights,
  /// sizes, heights, and letter spacings according to DESIGN.md.
  static TextTheme buildTextTheme({required Color textColor, required Color mutedColor}) {
    final base = GoogleFonts.nunitoSansTextTheme();

    return base.copyWith(
      // Headline LG: 24px / 32px / 800
      headlineLarge: GoogleFonts.nunitoSans(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 32 / 24,
        letterSpacing: -0.24,
        color: textColor,
      ),
      // Headline MD: 20px / 26px / 700
      headlineMedium: GoogleFonts.nunitoSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 26 / 20,
        letterSpacing: -0.20,
        color: textColor,
      ),
      // Headline SM: 18px / 24px / 700
      headlineSmall: GoogleFonts.nunitoSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 24 / 18,
        color: textColor,
      ),
      // Body LG: 16px / 24px / 500
      bodyLarge: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 24 / 16,
        color: textColor,
      ),
      // Body MD: 14px / 20px / 500
      bodyMedium: GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
        color: mutedColor,
      ),
      // Body SM (useful for secondary notes): 12px / 16px / 500
      bodySmall: GoogleFonts.nunitoSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 16 / 12,
        color: mutedColor,
      ),
      // Label LG (Buttons): 16px / 20px / 800 / +0.02em
      labelLarge: GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        height: 20 / 16,
        letterSpacing: 0.32,
        color: textColor,
      ),
      // Label MD: 13px / 18px / 700
      labelMedium: GoogleFonts.nunitoSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        height: 18 / 13,
        color: textColor,
      ),
      // Label SM (Pills & Badges): 11px / 14px / 700 / +0.03em
      labelSmall: GoogleFonts.nunitoSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 14 / 11,
        letterSpacing: 0.33,
        color: mutedColor,
      ),
    );
  }
}

/// Convenience extension for context.appTextTheme
extension AppTextStylesExtension on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}
