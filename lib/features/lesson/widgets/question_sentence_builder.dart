import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/lesson_models.dart';

class SentenceBuilderView extends StatelessWidget {
  final LessonQuestion question;
  final List<String> selectedWords;
  final ValueChanged<List<String>> onChanged;

  const SentenceBuilderView({
    super.key,
    required this.question,
    required this.selectedWords,
    required this.onChanged,
  });

  void _tapAvailableWord(String word) {
    final updated = List<String>.from(selectedWords)..add(word);
    onChanged(updated);
  }

  void _removeWordAt(int index) {
    final updated = List<String>.from(selectedWords)..removeAt(index);
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    // Calculate word pool with frequency handling
    final poolWords = List<String>.from(question.words);
    final chosenIndices = <int>[];
    for (final selected in selectedWords) {
      for (int i = 0; i < poolWords.length; i++) {
        if (!chosenIndices.contains(i) && poolWords[i] == selected) {
          chosenIndices.add(i);
          break;
        }
      }
    }

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
        const SizedBox(height: 24),

        // Drop / Assembly zone
        Container(
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: AppSpacing.brCard,
            border: Border.all(
              color: selectedWords.isNotEmpty ? colors.primary : colors.border,
              width: 1.5,
            ),
          ),
          child: selectedWords.isEmpty
              ? Center(
                  child: Text(
                    'Tap words below to build your sentence',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.mutedText,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: List.generate(selectedWords.length, (i) {
                    final word = selectedWords[i];
                    return GestureDetector(
                      onTap: () => _removeWordAt(i),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: colors.primaryTint,
                          borderRadius: AppSpacing.brButton,
                          border: Border.all(color: colors.primary, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              word,
                              style: textTheme.bodyLarge?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.close_rounded,
                                size: 14, color: colors.primary),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
        ),

        const Spacer(),

        // Word Pool
        Wrap(
          spacing: 10,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: List.generate(poolWords.length, (index) {
            final word = poolWords[index];
            final isUsed = chosenIndices.contains(index);

            return GestureDetector(
              onTap: isUsed ? null : () => _tapAvailableWord(word),
              child: AnimatedOpacity(
                opacity: isUsed ? 0.3 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: AppSpacing.brButton,
                    border: Border.all(color: colors.border, width: 1.5),
                    boxShadow: isUsed
                        ? null
                        : [
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
                      color: isUsed ? colors.mutedText : colors.text,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}

