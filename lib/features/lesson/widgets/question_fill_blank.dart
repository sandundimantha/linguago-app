import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/lesson_models.dart';

class FillBlankView extends StatelessWidget {
  final LessonQuestion question;
  final String? selectedWord;
  final ValueChanged<String> onSelect;

  const FillBlankView({
    super.key,
    required this.question,
    required this.selectedWord,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final parts = (question.sentence ?? '___').split('___');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question.prompt,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 36),

        // Sentence display with slot
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: AppSpacing.brCard,
            border: Border.all(color: colors.border, width: 1.5),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 10,
            children: [
              if (parts.isNotEmpty)
                Text(
                  parts[0],
                  style: textTheme.titleLarge?.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              // Slot Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                constraints: const BoxConstraints(minWidth: 80),
                decoration: BoxDecoration(
                  color: selectedWord != null
                      ? colors.primaryTint
                      : colors.background,
                  borderRadius: AppSpacing.brButton,
                  border: Border.all(
                    color: selectedWord != null
                        ? colors.primary
                        : colors.border,
                    width: 2,
                  ),
                ),
                child: Text(
                  selectedWord ?? '______',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium?.copyWith(
                    color: selectedWord != null
                        ? colors.primary
                        : colors.mutedText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (parts.length > 1)
                Text(
                  parts[1],
                  style: textTheme.titleLarge?.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),

        const Spacer(),

        // Word tiles
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: question.options.map((word) {
            final isChosen = selectedWord == word;
            return GestureDetector(
              onTap: () => onSelect(word),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                decoration: BoxDecoration(
                  color: isChosen ? colors.primaryTint : colors.card,
                  borderRadius: AppSpacing.brButton,
                  border: Border.all(
                    color: isChosen ? colors.primary : colors.border,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadow,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  word,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isChosen ? colors.primary : colors.text,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}

