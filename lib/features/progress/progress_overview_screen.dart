import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../app/providers.dart';

class ProgressOverviewScreen extends ConsumerWidget {
  const ProgressOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final repo = ref.watch(lessonRepositoryProvider);
    final totalXp = repo.getTotalXp();
    final streak = repo.getStreak();
    final completedLessonIds = repo.getCompletedLessonIds();
    final dailyXp = repo.getDailyXpHistory();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        title: Text(
          'Learning Progress',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.vGapMd,

              // Top Stats Hero
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      icon: '⚡',
                      value: '$totalXp',
                      label: 'TOTAL XP',
                      color: colors.accent,
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      icon: '🔥',
                      value: '$streak days',
                      label: 'CURRENT STREAK',
                      color: const Color(0xFFEA580C),
                      colors: colors,
                      textTheme: textTheme,
                      onTap: () => context.push('/progress/streak'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      icon: '✅',
                      value: '${completedLessonIds.length}',
                      label: 'LESSONS DONE',
                      color: colors.success,
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  ),
                ],
              ),

              AppSpacing.vGapLg,

              // 7-Day XP Chart Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '7-Day XP Activity',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.text,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.primaryTint,
                            borderRadius: AppSpacing.brFull,
                          ),
                          child: Text(
                            'Real Data',
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 140,
                      child: _DailyBarChart(dailyXp: dailyXp, colors: colors),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapLg,

              // Quick Nav Grid to Calendar, Badges, Leaderboard, Friends
              Row(
                children: [
                  Expanded(
                    child: _NavCard(
                      icon: '📅',
                      title: 'Streak Calendar',
                      subtitle: 'Active days log',
                      colors: colors,
                      textTheme: textTheme,
                      onTap: () => context.push('/progress/streak'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _NavCard(
                      icon: '🎖️',
                      title: 'Achievements',
                      subtitle: 'Badges & trophies',
                      colors: colors,
                      textTheme: textTheme,
                      onTap: () => context.push('/progress/badges'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _NavCard(
                      icon: '🏆',
                      title: 'Leaderboard',
                      subtitle: 'Global ranking',
                      colors: colors,
                      textTheme: textTheme,
                      onTap: () => context.push('/progress/leaderboard'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _NavCard(
                      icon: '👥',
                      title: 'Friends & Rivals',
                      subtitle: 'Social challenges',
                      colors: colors,
                      textTheme: textTheme,
                      onTap: () => context.push('/progress/friends'),
                    ),
                  ),
                ],
              ),

              AppSpacing.vGapMd,
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;
  final AppCustomColors colors;
  final TextTheme textTheme;
  final VoidCallback? onTap;

  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.colors,
    required this.textTheme,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.brCard,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 6),
              Text(
                value,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: textTheme.labelSmall?.copyWith(
                  color: colors.mutedText,
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final AppCustomColors colors;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.textTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.brCard,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 10),
            Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: colors.mutedText,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyBarChart extends StatelessWidget {
  final Map<String, int> dailyXp;
  final AppCustomColors colors;

  const _DailyBarChart({required this.dailyXp, required this.colors});

  @override
  Widget build(BuildContext context) {
    final entries = dailyXp.entries.toList();
    if (entries.isEmpty) return const Center(child: Text('No activity yet'));

    final recent7 = entries.length > 7
        ? entries.sublist(entries.length - 7)
        : entries;

    final maxXp = recent7.map((e) => e.value).fold<int>(60, (a, b) => a > b ? a : b);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: recent7.map((entry) {
        final heightPct = (entry.value / maxXp).clamp(0.1, 1.0);
        final date = DateTime.tryParse(entry.key) ?? DateTime.now();
        final dayLabel = ['M', 'T', 'W', 'T', 'F', 'S', 'S'][date.weekday - 1];

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              '${entry.value}',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Container(
              width: 22,
              height: 80 * heightPct,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dayLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: colors.mutedText,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

