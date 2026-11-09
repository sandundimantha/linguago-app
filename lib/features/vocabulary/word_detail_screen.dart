import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/tts_service.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';

class WordDetailScreen extends ConsumerWidget {
  final String wordId;

  const WordDetailScreen({super.key, required this.wordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final vocabAsync = ref.watch(vocabListProvider);
    final srs = ref.watch(srsSchedulerProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Word Details',
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
          final word = words.firstWhere(
            (w) => w.id == wordId,
            orElse: () => words.first,
          );
          final box = srs.getBox(word.id);

          return SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSpacing.vGapMd,

                  // Main Word Header Card
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: colors.primaryTint,
                                borderRadius: AppSpacing.brFull,
                              ),
                              child: Text(
                                word.partOfSpeech.toUpperCase(),
                                style: textTheme.labelSmall?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: colors.successTint,
                                borderRadius: AppSpacing.brFull,
                              ),
                              child: Text(
                                'Leitner Box $box',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colors.success,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    word.word,
                                    style: textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: colors.text,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    word.phonetic,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colors.mutedText,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => TtsService().speak(word.word),
                              child: Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.volume_up_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vGapMd,

                  // Definition
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DEFINITION',
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.mutedText,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          word.definition,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colors.text,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vGapMd,

                  // Example Sentence
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'EXAMPLE SENTENCE',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.mutedText,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.volume_up_rounded,
                                  size: 20, color: colors.primary),
                              onPressed: () => TtsService().speak(word.example),
                            ),
                          ],
                        ),
                        Text(
                          '"${word.example}"',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colors.text,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vGapMd,

                  // Synonyms
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SYNONYMS',
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.mutedText,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: word.synonyms.map((syn) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: colors.background,
                                borderRadius: AppSpacing.brButton,
                                border: Border.all(color: colors.border),
                              ),
                              child: Text(
                                syn,
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colors.text,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vGapLg,

                  // Speak full word
                  PrimaryButton(
                    label: 'Pronounce Word 🔊',
                    icon: const Icon(Icons.volume_up_rounded),
                    onPressed: () => TtsService().speak(word.word),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

