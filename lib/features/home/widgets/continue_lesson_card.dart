import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/xp_badge.dart';
import '../../../data/models/home_data.dart';

/// Dark Indigo Hero Card for resuming the current learning module.
/// Features ambient background accents, step progress, and an inverted white tactile button.
class ContinueLessonCard extends StatelessWidget {
  final ContinueLesson lesson;

  const ContinueLessonCard({
    super.key,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: AppSpacing.brCard,
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: AppSpacing.brCard,
        child: Stack(
          children: [
            // Playful Decorative Ambient Accents
            Positioned(
              right: -24,
              bottom: -24,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryDarker.withValues(alpha: 0.3),
                ),
              ),
            ),
            Positioned(
              right: -8,
              top: 8,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6BFF8F).withValues(alpha: 0.15),
                ),
              ),
            ),

            // Card Content
            Padding(
              padding: AppSpacing.pLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Unit Badge & XP Chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: AppSpacing.brFull,
                          ),
                          child: Text(
                            lesson.unitTitle,
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      AppSpacing.hGapSm,
                      XpBadge(
                        xp: '+${lesson.xpReward} XP',
                        backgroundColor: const Color(0xFFFFDDB8),
                        textColor: const Color(0xFF684000),
                        iconColor: const Color(0xFF684000),
                      ),
                    ],
                  ),

                  AppSpacing.vGapMd,

                  // Lesson Title & Subtitle
                  Text(
                    lesson.lessonTitle,
                    style: textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    lesson.subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  AppSpacing.vGapMd,

                  // Segmented Progress Track
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Step ${lesson.currentStep} of ${lesson.totalSteps}',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    height: 12.0,
                    width: double.infinity,
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppSpacing.brFull,
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: lesson.progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF6BFF8F), // Bright mint green
                          borderRadius: AppSpacing.brFull,
                        ),
                      ),
                    ),
                  ),

                  AppSpacing.vGapLg,

                  // Inverted Tactile Action Button
                  PrimaryButton(
                    label: 'Continue Lesson',
                    icon: const Icon(Icons.arrow_forward_rounded),
                    backgroundColor: Colors.white,
                    bottomEdgeColor: const Color(0xFFE2E8F0),
                    textColor: colors.primary,
                    onPressed: () => context.push('/lesson/${lesson.lessonId}'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

