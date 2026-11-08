import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/models/lesson_models.dart';

/// Modal bottom sheet or screen showing an intro to the lesson before starting.
class LessonIntroModal extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onStart;

  const LessonIntroModal({
    super.key,
    required this.lesson,
    required this.onStart,
  });

  static Future<void> show(BuildContext context, LessonModel lesson, VoidCallback onStart) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LessonIntroModal(lesson: lesson, onStart: onStart),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.screenMargin),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colors.primaryTint,
                    borderRadius: AppSpacing.brCard,
                  ),
                  child: const Center(
                    child: Text('📖', style: TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lesson ${lesson.id}',
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        lesson.title,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colors.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              lesson.subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.mutedText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.bolt_rounded,
                  label: '+${lesson.xpReward} XP',
                  color: colors.accent,
                  colors: colors,
                ),
                const SizedBox(width: 12),
                _InfoChip(
                  icon: Icons.quiz_rounded,
                  label: '${lesson.questions.length} questions',
                  color: colors.primary,
                  colors: colors,
                ),
              ],
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              label: 'Start Lesson 🚀',
              onPressed: () {
                Navigator.of(context).pop();
                onStart();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final AppCustomColors colors;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppSpacing.brFull,
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                ),
          ),
        ],
      ),
    );
  }
}

