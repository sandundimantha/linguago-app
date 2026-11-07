import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/home_data.dart';

/// Top App Bar containing the Streak Pill, Gem Counter Pill, and Profile Avatar trigger.
class HomeTopBar extends StatelessWidget implements PreferredSizeWidget {
  final UserStats stats;

  const HomeTopBar({
    super.key,
    required this.stats,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64.0);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: AppSpacing.screenMargin,
      title: Row(
        children: [
          // 1. Streak Flame Pill
          Container(
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
                  '${stats.topBarStreak}',
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.accentDarker,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.hGapSm,

          // 2. Diamond / Gems Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: colors.primaryTint,
              borderRadius: AppSpacing.brFull,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.diamond_rounded,
                  color: colors.primary,
                  size: 20,
                ),
                const SizedBox(width: 4.0),
                Text(
                  '${stats.topBarGems}',
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // Quick Theme Preview Shortcut
        IconButton(
          icon: Icon(
            Icons.palette_outlined,
            color: colors.mutedText,
            size: 22,
          ),
          tooltip: 'Theme Preview',
          onPressed: () => context.push('/preview'),
        ),

        // Profile Avatar Button
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.screenMargin),
          child: GestureDetector(
            onTap: () => context.go('/profile'),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: colors.primary,
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

