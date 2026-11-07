import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Gamification Hearts Counter displaying a red heart glyph and remaining lives.
class HeartsCounter extends StatelessWidget {
  final int count;
  final int maxHearts;
  final bool showMax;
  final VoidCallback? onTap;

  const HeartsCounter({
    super.key,
    required this.count,
    this.maxHearts = 5,
    this.showMax = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final displayText = showMax ? '$count / $maxHearts' : '$count';

    final widget = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: colors.dangerTint,
        borderRadius: AppSpacing.brFull,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: colors.danger,
            size: 20,
          ),
          const SizedBox(width: 5.0),
          Text(
            displayText,
            style: textTheme.labelMedium?.copyWith(
              color: colors.danger,
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
        child: widget,
      );
    }

    return widget;
  }
}

