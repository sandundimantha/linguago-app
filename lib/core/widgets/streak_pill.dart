import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Amber streak pill displaying a flame icon and streak count.
class StreakPill extends StatelessWidget {
  final String count;
  final VoidCallback? onTap;

  const StreakPill({
    super.key,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: colors.accentTint,
        borderRadius: AppSpacing.brFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department_rounded,
            color: colors.accent,
            size: 20,
          ),
          const SizedBox(width: 4.0),
          Text(
            count,
            style: textTheme.labelMedium?.copyWith(
              color: colors.accent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: pill,
      );
    }

    return pill;
  }
}

