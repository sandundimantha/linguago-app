import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Gamification XP Badge with sparkle/star icon and point value (e.g., "+30 XP").
class XpBadge extends StatelessWidget {
  final String xp;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;

  const XpBadge({
    super.key,
    required this.xp,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final bg = backgroundColor ?? colors.accentTint;
    final text = textColor ?? colors.accent;
    final icon = iconColor ?? colors.accent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppSpacing.brFull,
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.stars_rounded,
            color: icon,
            size: 16,
          ),
          const SizedBox(width: 4.0),
          Text(
            xp,
            style: textTheme.labelMedium?.copyWith(
              color: text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

