import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';

class BadgeItem {
  final String icon;
  final String title;
  final String description;
  final bool isUnlocked;
  final String dateUnlocked;

  const BadgeItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.isUnlocked,
    this.dateUnlocked = '',
  });
}

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  static const List<BadgeItem> _badges = [
    BadgeItem(
      icon: '🔥',
      title: '7-Day Streak',
      description: 'Maintained continuous practice for 7 days in a row.',
      isUnlocked: true,
      dateUnlocked: 'Unlocked yesterday',
    ),
    BadgeItem(
      icon: '⚡',
      title: 'XP Pioneer',
      description: 'Accumulate over 100 XP from lessons and review drills.',
      isUnlocked: true,
      dateUnlocked: 'Unlocked 3 days ago',
    ),
    BadgeItem(
      icon: '🦉',
      title: 'Lingo Disciple',
      description: 'Completed your first structured learning unit.',
      isUnlocked: true,
      dateUnlocked: 'Unlocked 5 days ago',
    ),
    BadgeItem(
      icon: '🗣️',
      title: 'Silver Tongue',
      description: 'Achieve 90%+ pronunciation score on 5 speaking phrases.',
      isUnlocked: false,
    ),
    BadgeItem(
      icon: '🧠',
      title: 'SRS Virtuoso',
      description: 'Advance 10 vocabulary words to Leitner Box 4.',
      isUnlocked: false,
    ),
    BadgeItem(
      icon: '🎧',
      title: 'Eagle Ear',
      description: 'Listen to 3 dialogue tracks at 1.25x speed with 100% quiz accuracy.',
      isUnlocked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Achievements & Badges',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: AppSpacing.screenPadding,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: _badges.length,
          itemBuilder: (context, i) {
            final b = _badges[i];
            return AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: b.isUnlocked
                          ? colors.primaryTint
                          : colors.border.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        b.isUnlocked ? b.icon : '🔒',
                        style: TextStyle(
                          fontSize: b.isUnlocked ? 32 : 22,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    b.title,
                    textAlign: TextAlign.center,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: b.isUnlocked ? colors.text : colors.mutedText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    b.description,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.mutedText,
                      fontSize: 11,
                    ),
                  ),
                  if (b.isUnlocked) ...[
                    const SizedBox(height: 8),
                    Text(
                      b.dateUnlocked,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

