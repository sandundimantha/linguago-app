import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// 8px high capsule progress bar with smooth animated green fill.
class AppProgressBar extends StatelessWidget {
  /// Value between 0.0 and 1.0
  final double value;
  final Color? fillColor;
  final Color? trackColor;
  final double height;

  const AppProgressBar({
    super.key,
    required this.value,
    this.fillColor,
    this.trackColor,
    this.height = AppSpacing.progressBarHeight, // 8.0
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final clampedValue = value.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final fillWidth = totalWidth * clampedValue;

        return Container(
          height: height,
          width: totalWidth,
          decoration: BoxDecoration(
            color: trackColor ?? colors.border,
            borderRadius: AppSpacing.brFull,
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                width: fillWidth,
                height: height,
                decoration: BoxDecoration(
                  color: fillColor ?? colors.success,
                  borderRadius: AppSpacing.brFull,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

