import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/models/home_data.dart';

/// Educational card spotlighting daily vocabulary with audio pronunciation and definition.
class WordOfTheDayCard extends StatefulWidget {
  final WordOfTheDay wordOfTheDay;

  const WordOfTheDayCard({
    super.key,
    required this.wordOfTheDay,
  });

  @override
  State<WordOfTheDayCard> createState() => _WordOfTheDayCardState();
}

class _WordOfTheDayCardState extends State<WordOfTheDayCard> {
  bool _isPlayingAudio = false;

  void _playAudio() {
    if (_isPlayingAudio) return;
    setState(() => _isPlayingAudio = true);
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) setState(() => _isPlayingAudio = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final word = widget.wordOfTheDay;

    return AppCard(
      padding: AppSpacing.pMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Tag & CEFR Level Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_rounded,
                      color: colors.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 6.0),
                    Flexible(
                      child: Text(
                        'WORD OF THE DAY',
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.accentDarker,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: colors.successTint,
                  borderRadius: AppSpacing.brFull,
                ),
                child: Text(
                  word.cefrLevel,
                  style: textTheme.labelSmall?.copyWith(
                    color: colors.success,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.vGapMd,

          // 2. Word, Part of Speech, Phonetic, and Audio Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            word.word,
                            style: textTheme.headlineLarge?.copyWith(
                              color: colors.text,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          word.partOfSpeech,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.mutedText,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      word.phonetic,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.mutedText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Pronounce Audio Trigger Button
              GestureDetector(
                onTap: _playAudio,
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isPlayingAudio ? colors.primary : colors.primaryTint,
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _isPlayingAudio ? Icons.graphic_eq_rounded : Icons.volume_up_rounded,
                    color: _isPlayingAudio ? Colors.white : colors.primary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.vGapMd,

          // 3. Definition & Context Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: AppSpacing.brMd,
              border: Border.all(color: colors.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '“${word.definition}”',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6.0),
                Text(
                  'e.g., ${word.example}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.mutedText,
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.vGapMd,

          // 4. Practice CTA Button
          PrimaryButton(
            label: 'Practice in sentence',
            icon: const Icon(Icons.edit_note_rounded),
            onPressed: () => context.go('/practice'),
          ),
        ],
      ),
    );
  }
}

