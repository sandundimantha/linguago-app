import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../app/providers.dart';
import '../../data/models/lesson_models.dart';
import '../lesson/widgets/lesson_intro_modal.dart';

enum LessonNodeStatus {
  completed,
  current,
  locked,
}

class LearningPathScreen extends ConsumerWidget {
  const LearningPathScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final unitsAsync = ref.watch(unitsProvider);
    final completedLessonIds = ref.watch(completedLessonIdsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        title: Text(
          'Learning Path',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: unitsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load path: $err')),
        data: (units) {
          // Determine status for each lesson across all units sequentially
          bool foundCurrent = false;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenMargin,
              vertical: 20,
            ),
            itemCount: units.length,
            itemBuilder: (context, unitIndex) {
              final unit = units[unitIndex];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Unit Header Banner
                  _UnitHeader(unit: unit, colors: colors, textTheme: textTheme),
                  const SizedBox(height: 24),

                  // Winding Nodes Path
                  ...List.generate(unit.lessons.length, (lessonIndex) {
                    final lesson = unit.lessons[lessonIndex];
                    LessonNodeStatus status;

                    if (completedLessonIds.contains(lesson.id)) {
                      status = LessonNodeStatus.completed;
                    } else if (!foundCurrent) {
                      status = LessonNodeStatus.current;
                      foundCurrent = true;
                    } else {
                      status = LessonNodeStatus.locked;
                    }

                    // Zig-zag alignment for playful path: Left (-0.5), Center (0), Right (0.5)
                    final alignments = [-0.4, 0.0, 0.4, 0.0];
                    final alignX = alignments[lessonIndex % alignments.length];

                    final isLast = lessonIndex == unit.lessons.length - 1;

                    return Column(
                      children: [
                        Align(
                          alignment: Alignment(alignX, 0),
                          child: _LessonNode(
                            lesson: lesson,
                            status: status,
                            onTap: () {
                              if (status == LessonNodeStatus.locked) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                        'Complete previous lessons to unlock! 🔒'),
                                    backgroundColor: colors.mutedText,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                return;
                              }
                              // Show intro bottom sheet
                              LessonIntroModal.show(
                                context,
                                lesson,
                                () => context.push('/lesson/${lesson.id}'),
                              );
                            },
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 6,
                            height: 36,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: status == LessonNodeStatus.completed
                                  ? colors.primary
                                  : colors.border,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                      ],
                    );
                  }),

                  const SizedBox(height: 40),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _UnitHeader extends StatelessWidget {
  final UnitModel unit;
  final AppCustomColors colors;
  final TextTheme textTheme;

  const _UnitHeader({
    required this.unit,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final unitColor = Color(int.parse(unit.color));

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: unitColor,
        borderRadius: AppSpacing.brCard,
        boxShadow: [
          BoxShadow(
            color: unitColor.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppSpacing.brFull,
            ),
            child: Text(
              'UNIT ${unit.unitNumber}',
              style: textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            unit.title,
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            unit.description,
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonNode extends StatelessWidget {
  final LessonModel lesson;
  final LessonNodeStatus status;
  final VoidCallback onTap;

  const _LessonNode({
    required this.lesson,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    Color bgColor;
    Color bottomColor;
    Widget icon;

    switch (status) {
      case LessonNodeStatus.completed:
        bgColor = colors.accent;
        bottomColor = colors.accentDarker;
        icon = const Icon(Icons.check_rounded, color: Colors.white, size: 36);
        break;
      case LessonNodeStatus.current:
        bgColor = colors.primary;
        bottomColor = colors.primaryDarker;
        icon = const Icon(Icons.star_rounded, color: Colors.white, size: 40);
        break;
      case LessonNodeStatus.locked:
        bgColor = colors.border;
        bottomColor = colors.border.withValues(alpha: 0.8);
        icon = Icon(Icons.lock_rounded, color: colors.mutedText, size: 28);
        break;
    }

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: bottomColor,
              shape: BoxShape.circle,
              boxShadow: status == LessonNodeStatus.current
                  ? [
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: 76,
                  height: 70,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: icon),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: AppSpacing.brFull,
            border: Border.all(color: colors.border),
          ),
          child: Text(
            lesson.title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: status == LessonNodeStatus.locked
                      ? colors.mutedText
                      : colors.text,
                ),
          ),
        ),
      ],
    );
  }
}

