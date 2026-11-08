import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/tts_service.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';
import '../../data/models/vocab_grammar_models.dart';

class RuleCardScreen extends ConsumerWidget {
  final String topicId;

  const RuleCardScreen({super.key, required this.topicId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final grammarAsync = ref.watch(grammarTopicsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Grammar Rules',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: grammarAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (topics) {
          final topic = topics.firstWhere(
            (t) => t.id == topicId,
            orElse: () => topics.first,
          );

          return SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSpacing.vGapMd,

                  // Topic Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: AppSpacing.brCard,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.level.toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          topic.title,
                          style: textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          topic.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: AppSpacing.brButton,
                          ),
                          child: Text(
                            'Formula: ${topic.formula}',
                            style: textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vGapLg,

                  Text(
                    'Rules & Key Pitfalls',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.text,
                    ),
                  ),

                  AppSpacing.vGapMd,

                  // Rules list
                  ...topic.rules.map((rule) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rule.title,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colors.text,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              rule.explanation,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colors.mutedText,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Correct Example Box
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colors.successTint,
                                borderRadius: AppSpacing.brButton,
                                border: Border.all(
                                    color: colors.success.withValues(alpha: 0.5)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.check_circle_rounded,
                                      color: colors.success, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      rule.exampleCorrect,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colors.successDarker,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => TtsService()
                                        .speak(rule.exampleCorrect),
                                    child: Icon(Icons.volume_up_rounded,
                                        size: 18, color: colors.success),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Incorrect Example Box
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colors.dangerTint,
                                borderRadius: AppSpacing.brButton,
                                border: Border.all(
                                    color: colors.danger.withValues(alpha: 0.5)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.cancel_rounded,
                                      color: colors.danger, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      rule.exampleIncorrect,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colors.dangerDarker,
                                        decoration:
                                            TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  AppSpacing.vGapMd,

                  // CTA to exercises
                  PrimaryButton(
                    label: 'Practice Exercises (${topic.exercises.length})',
                    icon: const Icon(Icons.fitness_center_rounded),
                    onPressed: () =>
                        context.push('/grammar/exercise/${topic.id}'),
                  ),

                  AppSpacing.vGapMd,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

