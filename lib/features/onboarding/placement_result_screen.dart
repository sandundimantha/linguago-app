import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_progress_bar.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';
import '../../data/local/placement_data.dart';

/// Shows the user their placement result (level + score).
class PlacementResultScreen extends ConsumerWidget {
  final int score;

  const PlacementResultScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final level = levelFromScore(score);

    final (emoji, tagline) = switch (level) {
      'Beginner' => ('🌱', "Every expert was once a beginner!"),
      'Elementary' => ('📖', "You've got a solid start!"),
      'Intermediate' => ('🗣️', "You're on the fast track!"),
      'Advanced' => ('🚀', "Impressive — nearly fluent!"),
      _ => ('🎉', "Great job!"),
    };

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenMargin,
          ),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Celebration emoji
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colors.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 56)),
                ),
              ),
              const SizedBox(height: 28),

              Text(
                "You're $level!",
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You scored $score out of ${placementQuestions.length}.',
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.mutedText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tagline,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.mutedText,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 32),

              // Decorative full progress bar
              AppProgressBar(value: 1.0),
              const SizedBox(height: 8),
              Text(
                'Placement complete',
                style: textTheme.labelSmall?.copyWith(
                  color: colors.mutedText,
                ),
              ),

              const Spacer(flex: 3),

              // CTA
              PrimaryButton(
                label: "Let's Go! 🚀",
                onPressed: () async {
                  await ref
                      .read(userPreferencesProvider.notifier)
                      .setPlacementResult(score, level);
                  if (context.mounted) {
                    context.go('/onboarding/daily-goal');
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

