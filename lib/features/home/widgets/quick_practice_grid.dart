import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../data/models/home_data.dart';

/// 2x2 Grid of Quick Practice shortcuts (Vocabulary, Grammar Drill, Speaking Lab, Listening).
class QuickPracticeGrid extends StatelessWidget {
  final List<QuickPracticeItem> items;

  const QuickPracticeGrid({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.length < 4) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Quick Practice',
          actionText: 'View All',
          onActionTap: () => context.go('/practice'),
        ),
        AppSpacing.vGapMd,
        // Row 1: Item 0 and Item 1
        Row(
          children: [
            Expanded(child: _PracticeCard(item: items[0])),
            AppSpacing.hGapMd,
            Expanded(child: _PracticeCard(item: items[1])),
          ],
        ),
        AppSpacing.vGapMd,
        // Row 2: Item 2 and Item 3
        Row(
          children: [
            Expanded(child: _PracticeCard(item: items[2])),
            AppSpacing.hGapMd,
            Expanded(child: _PracticeCard(item: items[3])),
          ],
        ),
      ],
    );
  }
}

class _PracticeCard extends StatelessWidget {
  final QuickPracticeItem item;

  const _PracticeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    // Resolve icon background and badge colors dynamically
    Color iconBg;
    Color iconColor;
    Color badgeBg;
    Color badgeTextColor;

    switch (item.badgeType) {
      case QuickPracticeBadgeType.error:
        iconBg = colors.primaryTint;
        iconColor = colors.primary;
        badgeBg = colors.dangerTint;
        badgeTextColor = colors.danger;
        break;
      case QuickPracticeBadgeType.primary:
        iconBg = colors.accentTint;
        iconColor = colors.accentDarker;
        badgeBg = colors.primaryTint;
        badgeTextColor = colors.primary;
        break;
      case QuickPracticeBadgeType.secondary:
        iconBg = colors.successTint;
        iconColor = colors.success;
        badgeBg = colors.successTint;
        badgeTextColor = colors.success;
        break;
      case QuickPracticeBadgeType.neutral:
        iconBg = colors.border.withValues(alpha: 0.5);
        iconColor = colors.primary;
        badgeBg = colors.border;
        badgeTextColor = colors.mutedText;
        break;
    }

    return AppCard(
      onTap: () => context.go('/practice'),
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Icon & Badge Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: AppSpacing.brMd, // 12px
                ),
                alignment: Alignment.center,
                child: Icon(
                  item.icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: AppSpacing.brFull,
                ),
                child: Text(
                  item.badgeText,
                  style: textTheme.labelSmall?.copyWith(
                    color: badgeTextColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Title
          Text(
            item.title,
            style: textTheme.headlineSmall?.copyWith(
              color: colors.text,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2.0),

          // Subtitle
          Text(
            item.subtitle,
            style: textTheme.bodySmall?.copyWith(
              color: colors.mutedText,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

