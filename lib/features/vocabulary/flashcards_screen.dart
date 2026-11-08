import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/tts_service.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';
import '../../data/models/vocab_grammar_models.dart';

class FlashcardsScreen extends ConsumerStatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen> {
  int _currentIndex = 0;
  bool _showBack = false;
  int _learnedCount = 0;
  int _relearnCount = 0;

  void _onSwipe(bool knewIt, List<VocabWord> words) {
    if (_currentIndex >= words.length) return;

    final word = words[_currentIndex];
    final srs = ref.read(srsSchedulerProvider);
    srs.reviewWord(wordId: word.id, knewIt: knewIt);

    setState(() {
      if (knewIt) {
        _learnedCount++;
      } else {
        _relearnCount++;
      }
      _showBack = false;
      _currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final vocabAsync = ref.watch(vocabListProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Flashcards',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: vocabAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (words) {
          if (_currentIndex >= words.length) {
            return _buildFinishedView(colors, textTheme);
          }

          final currentWord = words[_currentIndex];
          final progress = (_currentIndex + 1) / words.length;

          return SafeArea(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  AppSpacing.vGapSm,
                  // Progress counter & bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Card ${_currentIndex + 1} of ${words.length}',
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.mutedText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Text('👍 $_learnedCount  ',
                              style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text('🔄 $_relearnCount',
                              style: const TextStyle(fontWeight: FontWeight.w700)),
                        ],
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

                  const Spacer(flex: 1),

                  // Swipeable & Flippable Flashcard
                  Dismissible(
                    key: Key(currentWord.id),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      final knewIt = direction == DismissDirection.startToEnd;
                      _onSwipe(knewIt, words);
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 32),
                      decoration: BoxDecoration(
                        color: colors.successTint,
                        borderRadius: AppSpacing.brCard,
                        border: Border.all(color: colors.success, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_rounded,
                              size: 48, color: colors.success),
                          const SizedBox(height: 4),
                          Text('Know it!',
                              style: TextStyle(
                                  color: colors.success,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 32),
                      decoration: BoxDecoration(
                        color: colors.dangerTint,
                        borderRadius: AppSpacing.brCard,
                        border: Border.all(color: colors.danger, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.replay_rounded,
                              size: 48, color: colors.danger),
                          const SizedBox(height: 4),
                          Text('Still learning',
                              style: TextStyle(
                                  color: colors.danger,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _showBack = !_showBack),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: double.infinity,
                        height: 380,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: AppSpacing.brCard,
                          border: Border.all(
                            color: _showBack ? colors.primary : colors.border,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow,
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: _showBack
                            ? _buildCardBack(currentWord, colors, textTheme)
                            : _buildCardFront(currentWord, colors, textTheme),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    'Tap card to flip • Swipe Right for "Know it" • Swipe Left for "Learning"',
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.mutedText,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Bottom Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.close_rounded, color: colors.danger),
                          label: Text(
                            'Still learning',
                            style: TextStyle(
                              color: colors.danger,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: colors.danger, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.brButton,
                            ),
                          ),
                          onPressed: () => _onSwipe(false, words),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check_rounded, color: Colors.white),
                          label: const Text(
                            'Know it!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.success,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppSpacing.brButton,
                            ),
                          ),
                          onPressed: () => _onSwipe(true, words),
                        ),
                      ),
                    ],
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

  Widget _buildCardFront(
      VocabWord word, AppCustomColors colors, TextTheme textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: colors.primaryTint,
            borderRadius: AppSpacing.brFull,
          ),
          child: Text(
            word.category.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          word.word,
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          word.phonetic,
          style: textTheme.bodyLarge?.copyWith(
            color: colors.mutedText,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 18),
        IconButton(
          icon: Icon(Icons.volume_up_rounded, color: colors.primary, size: 32),
          onPressed: () => TtsService().speak(word.word),
        ),
        const SizedBox(height: 24),
        Text(
          'Tap to reveal definition 🔄',
          style: textTheme.bodySmall?.copyWith(
            color: colors.mutedText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCardBack(
      VocabWord word, AppCustomColors colors, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${word.partOfSpeech} • ${word.level}',
          style: textTheme.labelSmall?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          word.definition,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.text,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Example:',
          style: textTheme.labelSmall?.copyWith(
            color: colors.mutedText,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '"${word.example}"',
          style: textTheme.bodyMedium?.copyWith(
            color: colors.text,
            fontStyle: FontStyle.italic,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(Icons.volume_up_rounded, color: colors.primary),
            onPressed: () => TtsService().speak(word.example),
          ),
        ),
      ],
    );
  }

  Widget _buildFinishedView(AppCustomColors colors, TextTheme textTheme) {
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
                child: Text('🎉', style: TextStyle(fontSize: 48)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Session Completed!',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You reviewed $_learnedCount words as "Know it" and flagged $_relearnCount for extra repetition.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.mutedText,
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Back to Vocabulary Hub',
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}

