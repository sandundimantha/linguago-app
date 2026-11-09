import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/tts_service.dart';
import '../../core/widgets/choice_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';
import '../../data/models/vocab_grammar_models.dart';

class ReviewSessionScreen extends ConsumerStatefulWidget {
  const ReviewSessionScreen({super.key});

  @override
  ConsumerState<ReviewSessionScreen> createState() => _ReviewSessionScreenState();
}

class _ReviewSessionScreenState extends ConsumerState<ReviewSessionScreen> {
  int _currentIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  int _correctCount = 0;

  void _onAnswer(int optionIndex, VocabWord word, List<String> options) {
    if (_answered) return;

    final isCorrect = options[optionIndex] == word.definition;
    final srs = ref.read(srsSchedulerProvider);
    srs.reviewWord(wordId: word.id, knewIt: isCorrect);

    setState(() {
      _selectedOption = optionIndex;
      _answered = true;
      if (isCorrect) _correctCount++;
    });
  }

  void _nextWord(int total) {
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

    final dueWordsAsync = ref.watch(dueWordsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'SRS Review Session',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: dueWordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (dueWords) {
          final words = dueWords.isNotEmpty
              ? dueWords
              : ref.watch(vocabListProvider).valueOrNull ?? [];

          if (words.isEmpty) {
            return const Center(child: Text('No words to review'));
          }

          if (_currentIndex >= words.length) {
            return _buildCompletedView(words.length, colors, textTheme);
          }

          final currentWord = words[_currentIndex];
          final progress = (_currentIndex + 1) / words.length;

          // Distractor definitions from remaining words
          final allWords = ref.watch(vocabListProvider).valueOrNull ?? words;
          final otherDefinitions = allWords
              .where((w) => w.id != currentWord.id)
              .map((w) => w.definition)
              .toList()
            ..shuffle();

          final options = [
            currentWord.definition,
            if (otherDefinitions.isNotEmpty) otherDefinitions[0],
            if (otherDefinitions.length > 1) otherDefinitions[1],
            if (otherDefinitions.length > 2) otherDefinitions[2],
          ]..shuffle();

          final correctIndex = options.indexOf(currentWord.definition);

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
                        'Review ${_currentIndex + 1} of ${words.length}',
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.mutedText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Score: $_correctCount / ${_currentIndex + (_answered ? 1 : 0)}',
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

                  // Prompt Word Box
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: colors.card,
                      borderRadius: AppSpacing.brCard,
                      border: Border.all(color: colors.border, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentWord.word,
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: colors.text,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.volume_up_rounded,
                                  color: colors.primary),
                              onPressed: () =>
                                  TtsService().speak(currentWord.word),
                            ),
                          ],
                        ),
                        Text(
                          '${currentWord.partOfSpeech} • ${currentWord.phonetic}',
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.mutedText,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Select the matching definition:',
                          style: textTheme.labelMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vGapMd,

                  // Multiple Choice Options
                  Expanded(
                    child: ListView.separated(
                      itemCount: options.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        ChoiceCardState state = ChoiceCardState.normal;
                        if (_answered) {
                          if (i == correctIndex) {
                            state = ChoiceCardState.correct;
                          } else if (i == _selectedOption) {
                            state = ChoiceCardState.wrong;
                          }
                        } else if (_selectedOption == i) {
                          state = ChoiceCardState.selected;
                        }

                        return ChoiceCard(
                          text: options[i],
                          optionIndex: String.fromCharCode(65 + i),
                          state: state,
                          onTap: _answered
                              ? null
                              : () => _onAnswer(i, currentWord, options),
                        );
                      },
                    ),
                  ),

                  if (_answered) ...[
                    PrimaryButton(
                      label: 'Next Word',
                      onPressed: () => _nextWord(words.length),
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

  Widget _buildCompletedView(
      int total, AppCustomColors colors, TextTheme textTheme) {
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
                child: Text('🧠', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Review Complete!',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You successfully reviewed all due words.\nScore: $_correctCount / $total',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: colors.mutedText,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Return to Hub',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}

