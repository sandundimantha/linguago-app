import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/home_data.dart';

/// 3-Column horizontal gamification stats strip (Streak, Total XP, Hearts).
/// Scaled to fit seamlessly on narrow (360px) and wide screens without overflow.
class HomeStatsStrip extends StatelessWidget {
  final UserStats stats;

  const HomeStatsStrip({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        // 1. Streak Card
        Expanded(
          child: _StatTile(
            backgroundColor: colors.accentTint,
            iconBgColor: colors.card,
            iconColor: colors.accentDarker,
            icon: Icons.local_fire_department_rounded,
            label: 'STREAK',
            labelColor: colors.accentDarker,
            value: '${stats.streakDays} Days',
            valueColor: colors.accentDarker,
          ),
        ),

        const SizedBox(width: 10.0),

        // 2. Total XP Card
        Expanded(
          child: _StatTile(
            backgroundColor: colors.primaryTint,
            iconBgColor: colors.card,
            iconColor: colors.primary,
            icon: Icons.bolt_rounded,
            label: 'TOTAL XP',
            labelColor: colors.primary,
            value: _formatNumber(stats.totalXp),
            valueColor: colors.primary,
          ),
        ),

        const SizedBox(width: 10.0),

        // 3. Hearts Card
        Expanded(
          child: _StatTile(
            backgroundColor: colors.dangerTint,
            iconBgColor: colors.card,
            iconColor: colors.danger,
            icon: Icons.favorite_rounded,
            label: 'HEARTS',
            labelColor: colors.danger,
            value: '${stats.currentHearts} / ${stats.maxHearts}',
            valueColor: colors.danger,
          ),
        ),
      ],
    );
  }

  static String _formatNumber(int n) {
    if (n >= 1000) {
      final s = n.toString();
      final buffer = StringBuffer();
      final len = s.length;
      for (int i = 0; i < len; i++) {
        if (i > 0 && (len - i) % 3 == 0) buffer.write(',');
        buffer.write(s[i]);
      }
      return buffer.toString();
    }
    return n.toString();
  }
}

class _StatTile extends StatelessWidget {
  final Color backgroundColor;
  final Color iconBgColor;
  final Color iconColor;
  final IconData icon;
  final String label;
  final Color labelColor;
  final String value;
  final Color valueColor;

  const _StatTile({
    required this.backgroundColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.labelColor,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppSpacing.brMd, // 12px
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon inside small circle
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 8.0),

          // Label & Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: labelColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1.0),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: textTheme.headlineSmall?.copyWith(
                      color: valueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

