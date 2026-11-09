import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/choice_card.dart';
import '../../../data/models/lesson_models.dart';

class MultipleChoiceView extends StatelessWidget {
  final LessonQuestion question;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  const MultipleChoiceView({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

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
        Expanded(
          child: ListView.separated(
            itemCount: question.options.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final isSelected = selectedIndex == i;
              return ChoiceCard(
                text: question.options[i],
                optionIndex: String.fromCharCode(65 + i), // A, B, C, D
                state: isSelected
                    ? ChoiceCardState.selected
                    : ChoiceCardState.normal,
                onTap: () => onSelect(i),
              );
            },
          ),
        ),
      ],
    );
  }
}

