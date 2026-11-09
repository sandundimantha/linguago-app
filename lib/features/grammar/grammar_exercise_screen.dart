import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/choice_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';
import '../../data/models/vocab_grammar_models.dart';

class GrammarExerciseScreen extends ConsumerStatefulWidget {
  final String topicId;

  const GrammarExerciseScreen({super.key, required this.topicId});

  @override
  ConsumerState<GrammarExerciseScreen> createState() =>
      _GrammarExerciseScreenState();
}

class _GrammarExerciseScreenState extends ConsumerState<GrammarExerciseScreen> {
  int _currentIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  int _correctCount = 0;

  void _onOptionTap(int index, GrammarExercise ex) {
    if (_answered) return;

    final isCorrect = index == ex.correctIndex;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (isCorrect) _correctCount++;
    });
  }

  void _nextExercise(int total) {
    setState(() {
      _currentIndex++;
      _selectedOption = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'Grammar Drill',
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
            (t) => t.id == widget.topicId,
            orElse: () => topics.first,
          );
          final exercises = topic.exercises;

          if (_currentIndex >= exercises.length) {
            return _buildFinishedView(
                exercises.length, topic.title, colors, textTheme);
          }

          final currentEx = exercises[_currentIndex];
          final progress = (_currentIndex + 1) / exercises.length;

          return SafeArea(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSpacing.vGapSm,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Exercise ${_currentIndex + 1} of ${exercises.length}',
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.mutedText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Score: $_correctCount',
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: colors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),

                  AppSpacing.vGapLg,

                  // Question Box
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: AppSpacing.brCard,
                      border: Border.all(color: colors.border, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      currentEx.prompt,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.text,
                        height: 1.3,
                      ),
                    ),
                  ),

                  AppSpacing.vGapLg,

                  // Option Cards
                  Expanded(
                    child: ListView.separated(
                      itemCount: currentEx.options.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        ChoiceCardState state = ChoiceCardState.normal;
                        if (_answered) {
                          if (i == currentEx.correctIndex) {
                            state = ChoiceCardState.correct;
                          } else if (i == _selectedOption) {
                            state = ChoiceCardState.wrong;
                          }
                        } else if (_selectedOption == i) {
                          state = ChoiceCardState.selected;
                        }

                        return ChoiceCard(
                          text: currentEx.options[i],
                          optionIndex: String.fromCharCode(65 + i),
                          state: state,
                          onTap: _answered
                              ? null
                              : () => _onOptionTap(i, currentEx),
                        );
                      },
                    ),
                  ),

                  if (_answered) ...[
                    // Explanation Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: (_selectedOption == currentEx.correctIndex)
                            ? colors.successTint
                            : colors.dangerTint,
                        borderRadius: AppSpacing.brButton,
                        border: Border.all(
                          color: (_selectedOption == currentEx.correctIndex)
                              ? colors.success
                              : colors.danger,
                        ),
                      ),
                      child: Text(
                        currentEx.explanation,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      label: 'Next Exercise',
                      onPressed: () => _nextExercise(exercises.length),
                    ),
                    AppSpacing.vGapMd,
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFinishedView(int total, String topicTitle,
      AppCustomColors colors, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colors.successTint,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🎓', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Drill Finished!',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              topicTitle,
              style: textTheme.titleMedium?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Score: $_correctCount / $total correct',
              style: textTheme.bodyLarge?.copyWith(
                color: colors.mutedText,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Back to Grammar Lab',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}

