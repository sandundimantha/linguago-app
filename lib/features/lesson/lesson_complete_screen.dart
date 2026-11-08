import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/primary_button.dart';

/// Joyful celebration screen shown upon successfully finishing a lesson.
class LessonCompleteScreen extends StatelessWidget {
  final int xpEarned;
  final double accuracy;
  final int streak;

  const LessonCompleteScreen({
    super.key,
    required this.xpEarned,
    required this.accuracy,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final accuracyPercent = (accuracy * 100).round();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Celebration icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colors.successTint,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🏆', style: TextStyle(fontSize: 60)),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Lesson Complete!',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Superb effort! You are making steady progress.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.mutedText,
                ),
              ),

              const SizedBox(height: 36),

              // Stat cards row
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'TOTAL XP',
                      value: '+$xpEarned',
                      icon: '⚡',
                      color: colors.accent,
                      colors: colors,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'ACCURACY',
                      value: '$accuracyPercent%',
                      icon: '🎯',
                      color: colors.success,
                      colors: colors,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'STREAK',
                      value: '$streak days',
                      icon: '🔥',
                      color: const Color(0xFFEA580C),
                      colors: colors,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 3),

              PrimaryButton(
                label: 'Continue to Path',
                onPressed: () {
                  if (context.canPop()) {
                    context.pop(true);
                  } else {
                    context.go('/');
                  }
                },
              ),
              const SizedBox(height: AppSpacing.screenMargin),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;
  final AppCustomColors colors;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: AppSpacing.brCard,
        border: Border.all(color: colors.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.mutedText,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
          ),
        ],
      ),
    );
  }
}

