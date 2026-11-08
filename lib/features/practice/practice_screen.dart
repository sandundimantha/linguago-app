import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        title: Text(
          'Practice & Skills',
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

              // Learning Path Hero Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: AppSpacing.brCard,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: AppSpacing.brFull,
                          ),
                          child: Text(
                            'CURRICULUM',
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Structured Learning Path',
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Follow guided units with lessons, interactive quizzes, and speaking labs.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 18),
                    PrimaryButton(
                      label: 'Open Learning Path 🗺️',
                      backgroundColor: Colors.white,
                      bottomEdgeColor: const Color(0xFFE2E8F0),
                      textColor: colors.primary,
                      onPressed: () => context.push('/learning-path'),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapLg,

              Text(
                'Skill Training Drills',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                ),
              ),

              AppSpacing.vGapMd,

              // Vocabulary Hub Shortcut
              _PracticeDrillCard(
                icon: '📚',
                title: 'Vocabulary Hub',
                subtitle: 'Spaced repetition Leitner flashcards & 20 word bank',
                color: colors.primary,
                colors: colors,
                textTheme: textTheme,
                onTap: () => context.push('/vocab'),
              ),

              AppSpacing.vGapSm,

              // Grammar Lab Shortcut
              _PracticeDrillCard(
                icon: '⚖️',
                title: 'Grammar Lab',
                subtitle: 'Rules, clear formulas, pitfalls & interactive drills',
                color: colors.accent,
                colors: colors,
                textTheme: textTheme,
                onTap: () => context.push('/grammar'),
              ),

              AppSpacing.vGapSm,

              _PracticeDrillCard(
                icon: '🗣️',
                title: 'Speaking Lab',
                subtitle: 'Practice accent & pronunciation with audio prompts',
                color: colors.success,
                colors: colors,
                textTheme: textTheme,
                onTap: () => context.push('/lesson/1'),
              ),

              AppSpacing.vGapSm,

              _PracticeDrillCard(
                icon: '🎧',
                title: 'Listening Sprint',
                subtitle: 'Train ear comprehension with native dialogues',
                color: const Color(0xFF8B5CF6),
                colors: colors,
                textTheme: textTheme,
                onTap: () => context.push('/lesson/2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PracticeDrillCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final AppCustomColors colors;
  final TextTheme textTheme;
  final VoidCallback onTap;

  const _PracticeDrillCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
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
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: AppSpacing.brCard,
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 26)),
              ),
            ),
            AppSpacing.hGapMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.mutedText),
          ],
        ),
      ),
    );
  }
}
