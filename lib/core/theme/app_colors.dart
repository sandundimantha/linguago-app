import 'package:flutter/material.dart';

/// Semantic palette definitions for LinguaGo (derived from DESIGN.md).
class AppColors {
  AppColors._();

  // Core brand tokens
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color primaryDarker = Color(0xFF3730A3); // Indigo 700 (Tactile bottom edge)
  static const Color primaryTint = Color(0xFFEEF2FF);

  static const Color success = Color(0xFF22C55E); // Emerald
  static const Color successDarker = Color(0xFF16A34A); // Emerald 700 (Tactile bottom edge)
  static const Color successTint = Color(0xFFF0FDF4);

  static const Color danger = Color(0xFFEF4444); // Crimson / Red
  static const Color dangerDarker = Color(0xFFDC2626); // Red 700 (Tactile bottom edge)
  static const Color dangerTint = Color(0xFFFEF2F2);

  static const Color accent = Color(0xFFF59E0B); // Amber / Orange
  static const Color accentDarker = Color(0xFFD97706);
  static const Color accentTint = Color(0xFFFEF3C7);

  // Light surfaces
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color textLight = Color(0xFF0F172A);
  static const Color mutedTextLight = Color(0xFF64748B);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Dark surfaces (derived faithfully from the same slate/indigo palette)
  static const Color backgroundDark = Color(0xFF0B1120); // Deep slate
  static const Color cardDark = Color(0xFF1E293B); // Slate 800
  static const Color textDark = Color(0xFFF8FAFC); // Slate 50
  static const Color mutedTextDark = Color(0xFF94A3B8); // Slate 400
  static const Color borderDark = Color(0xFF334155); // Slate 700

  // Dark mode specific tints
  static const Color primaryTintDark = Color(0xFF1E1B4B);
  static const Color successTintDark = Color(0xFF052E16);
  static const Color dangerTintDark = Color(0xFF450A0A);
  static const Color accentTintDark = Color(0xFF451A03);
}

/// A ThemeExtension that allows accessing semantic design system colors
/// directly from the active ThemeData, e.g. `Theme.of(context).extension<AppCustomColors>()!`
/// or via the convenience extension `context.appColors`.
class AppCustomColors extends ThemeExtension<AppCustomColors> {
  final Color primary;
  final Color primaryDarker;
  final Color primaryTint;

  final Color success;
  final Color successDarker;
  final Color successTint;

  final Color danger;
  final Color dangerDarker;
  final Color dangerTint;

  final Color accent;
  final Color accentDarker;
  final Color accentTint;

  final Color background;
  final Color card;
  final Color text;
  final Color mutedText;
  final Color border;
  final Color shadow;

  const AppCustomColors({
    required this.primary,
    required this.primaryDarker,
    required this.primaryTint,
    required this.success,
    required this.successDarker,
    required this.successTint,
    required this.danger,
    required this.dangerDarker,
    required this.dangerTint,
    required this.accent,
    required this.accentDarker,
    required this.accentTint,
    required this.background,
    required this.card,
    required this.text,
    required this.mutedText,
    required this.border,
    required this.shadow,
  });

  static const light = AppCustomColors(
    primary: AppColors.primary,
    primaryDarker: AppColors.primaryDarker,
    primaryTint: AppColors.primaryTint,
    success: AppColors.success,
    successDarker: AppColors.successDarker,
    successTint: AppColors.successTint,
    danger: AppColors.danger,
    dangerDarker: AppColors.dangerDarker,
    dangerTint: AppColors.dangerTint,
    accent: AppColors.accent,
    accentDarker: AppColors.accentDarker,
    accentTint: AppColors.accentTint,
    background: AppColors.backgroundLight,
    card: AppColors.cardLight,
    text: AppColors.textLight,
    mutedText: AppColors.mutedTextLight,
    border: AppColors.borderLight,
    shadow: Color(0x0F0F172A), // 6% black shadow
  );

  static const dark = AppCustomColors(
    primary: AppColors.primary,
    primaryDarker: AppColors.primaryDarker,
    primaryTint: AppColors.primaryTintDark,
    success: AppColors.success,
    successDarker: AppColors.successDarker,
    successTint: AppColors.successTintDark,
    danger: AppColors.danger,
    dangerDarker: AppColors.dangerDarker,
    dangerTint: AppColors.dangerTintDark,
    accent: AppColors.accent,
    accentDarker: AppColors.accentDarker,
    accentTint: AppColors.accentTintDark,
    background: AppColors.backgroundDark,
    card: AppColors.cardDark,
    text: AppColors.textDark,
    mutedText: AppColors.mutedTextDark,
    border: AppColors.borderDark,
    shadow: Color(0x33000000), // 20% black shadow in dark
  );

  @override
  AppCustomColors copyWith({
    Color? primary,
    Color? primaryDarker,
    Color? primaryTint,
    Color? success,
    Color? successDarker,
    Color? successTint,
    Color? danger,
    Color? dangerDarker,
    Color? dangerTint,
    Color? accent,
    Color? accentDarker,
    Color? accentTint,
    Color? background,
    Color? card,
    Color? text,
    Color? mutedText,
    Color? border,
    Color? shadow,
  }) {
    return AppCustomColors(
      primary: primary ?? this.primary,
      primaryDarker: primaryDarker ?? this.primaryDarker,
      primaryTint: primaryTint ?? this.primaryTint,
      success: success ?? this.success,
      successDarker: successDarker ?? this.successDarker,
      successTint: successTint ?? this.successTint,
      danger: danger ?? this.danger,
      dangerDarker: dangerDarker ?? this.dangerDarker,
      dangerTint: dangerTint ?? this.dangerTint,
      accent: accent ?? this.accent,
      accentDarker: accentDarker ?? this.accentDarker,
      accentTint: accentTint ?? this.accentTint,
      background: background ?? this.background,
      card: card ?? this.card,
      text: text ?? this.text,
      mutedText: mutedText ?? this.mutedText,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  AppCustomColors lerp(ThemeExtension<AppCustomColors>? other, double t) {
    if (other is! AppCustomColors) return this;
    return AppCustomColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDarker: Color.lerp(primaryDarker, other.primaryDarker, t)!,
      primaryTint: Color.lerp(primaryTint, other.primaryTint, t)!,
      success: Color.lerp(success, other.success, t)!,
      successDarker: Color.lerp(successDarker, other.successDarker, t)!,
      successTint: Color.lerp(successTint, other.successTint, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerDarker: Color.lerp(dangerDarker, other.dangerDarker, t)!,
      dangerTint: Color.lerp(dangerTint, other.dangerTint, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentDarker: Color.lerp(accentDarker, other.accentDarker, t)!,
      accentTint: Color.lerp(accentTint, other.accentTint, t)!,
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      text: Color.lerp(text, other.text, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

/// Convenience getter on BuildContext for cleaner UI code:
/// `context.appColors.primary`
extension AppColorsExtension on BuildContext {
  AppCustomColors get appColors =>
      Theme.of(this).extension<AppCustomColors>() ?? AppCustomColors.light;
}

