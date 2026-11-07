import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  /// Light ThemeData
  static ThemeData get lightTheme {
    final textTheme = AppTextStyles.buildTextTheme(
      textColor: AppColors.textLight,
      mutedColor: AppColors.mutedTextLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryTint,
        onPrimaryContainer: AppColors.primaryDarker,
        secondary: AppColors.success,
        onSecondary: Colors.white,
        error: AppColors.danger,
        onError: Colors.white,
        surface: AppColors.cardLight,
        onSurface: AppColors.textLight,
        onSurfaceVariant: AppColors.mutedTextLight,
        outline: AppColors.borderLight,
      ),
      textTheme: textTheme,
      extensions: const [
        AppCustomColors.light,
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight.withValues(alpha: 0.9),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: AppColors.textLight),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: AppColors.textLight,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.brCard,
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }

  /// Dark ThemeData
  static ThemeData get darkTheme {
    final textTheme = AppTextStyles.buildTextTheme(
      textColor: AppColors.textDark,
      mutedColor: AppColors.mutedTextDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryTintDark,
        onPrimaryContainer: AppColors.primaryTint,
        secondary: AppColors.success,
        onSecondary: Colors.white,
        error: AppColors.danger,
        onError: Colors.white,
        surface: AppColors.cardDark,
        onSurface: AppColors.textDark,
        onSurfaceVariant: AppColors.mutedTextDark,
        outline: AppColors.borderDark,
      ),
      textTheme: textTheme,
      extensions: const [
        AppCustomColors.dark,
      ],
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark.withValues(alpha: 0.9),
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: AppColors.textDark,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.brCard,
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
