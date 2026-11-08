import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/tts_service.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';

class DictionaryResultScreen extends ConsumerWidget {
  final String wordId;

  const DictionaryResultScreen({super.key, required this.wordId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          'Dictionary Definition',
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

          return SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSpacing.vGapMd,

                  // Main Word Card
                  AppCard(
                    padding: const EdgeInsets.all(24),
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
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.volume_up_rounded,
                                  color: colors.primary, size: 28),
                              onPressed: () => TtsService().speak(word.word),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
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
                          style: textTheme.bodyLarge?.copyWith(
                            color: colors.mutedText,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vGapMd,

                  // Meaning Section
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MEANING',
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
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vGapMd,

                  // Example in Context
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'EXAMPLE IN CONTEXT',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.mutedText,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.volume_up_rounded,
                                  size: 18, color: colors.primary),
                              onPressed: () =>
                                  TtsService().speak(word.example),
                            ),
                          ],
                        ),
                        Text(
                          '"${word.example}"',
                          style: textTheme.bodyMedium?.copyWith(
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
                          'SYNONYMS & RELATED WORDS',
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
                          children: word.synonyms.map((s) {
                            return Chip(
                              label: Text(s),
                              backgroundColor: colors.background,
                              side: BorderSide(color: colors.border),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  AppSpacing.vGapLg,

                  PrimaryButton(
                    label: 'Listen to Full Pronunciation 🔊',
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

