import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/choice_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';

/// Screen where the user picks their primary learning goal.
class LearningGoalScreen extends ConsumerStatefulWidget {
  const LearningGoalScreen({super.key});

  @override
  ConsumerState<LearningGoalScreen> createState() => _LearningGoalScreenState();
}

class _LearningGoalScreenState extends ConsumerState<LearningGoalScreen> {
  String? _selected;

  static const _goals = [
    ('✈️', 'Travel & Tourism', 'Navigate the world with confidence'),
    ('💼', 'Business & Career', 'Excel in professional settings'),
    ('🎓', 'Academic Study', 'Succeed in English-taught programs'),
    ('💬', 'Everyday Conversation', 'Chat naturally with anyone'),
    ('📋', 'Exam Preparation', 'Ace IELTS, TOEFL or Cambridge'),
    ('🌏', 'Move Abroad', 'Start a new life in a new country'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenMargin, 8,
                AppSpacing.screenMargin, 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "What's your\nlearning goal?",
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.text,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We'll tailor your lessons to reach it faster.",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.mutedText,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenMargin,
                  vertical: 4,
                ),
                itemCount: _goals.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final (emoji, title, subtitle) = _goals[i];
                  final isSelected = _selected == title;
                  return ChoiceCard(
                    text: title,
                    subtitle: subtitle,
                    state: isSelected
                        ? ChoiceCardState.selected
                        : ChoiceCardState.normal,
                    onTap: () => setState(() => _selected = title),
                    leading: Text(emoji, style: const TextStyle(fontSize: 28)),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenMargin),
              child: PrimaryButton(
                label: 'Continue',
                onPressed: _selected == null
                    ? null
                    : () async {
                        await ref
                            .read(userPreferencesProvider.notifier)
                            .setLearningGoal(_selected!);
                        if (context.mounted) context.go('/onboarding/level');
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
