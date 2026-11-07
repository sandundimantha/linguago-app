import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/core_widgets.dart';

/// Full-screen Lesson view rendered above the App Shell without bottom navigation.
class LessonScreen extends StatefulWidget {
  final String lessonId;

  const LessonScreen({
    super.key,
    required this.lessonId,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _selectedOption = -1;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.vGapSm,
              // Top Bar: Dismiss (X), Progress bar, and Hearts
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: colors.mutedText,
                    onPressed: () => context.pop(),
                  ),
                  AppSpacing.hGapSm,
                  const Expanded(
                    child: AppProgressBar(value: 0.6),
                  ),
                  AppSpacing.hGapSm,
                  const HeartsCounter(count: 5),
                ],
              ),

              AppSpacing.vGapXl,

              // Lesson Headline
              Text(
                'Lesson ${widget.lessonId}',
                style: textTheme.labelMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
              AppSpacing.vGapXs,
              Text(
                'Select the polite way to order coffee:',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                ),
              ),

              AppSpacing.vGapXl,

              // Exercise Options
              ChoiceCard(
                optionIndex: 'A',
                text: 'Give me a coffee right now.',
                state: _selectedOption == 0 ? ChoiceCardState.wrong : ChoiceCardState.normal,
                onTap: () => setState(() => _selectedOption = 0),
              ),
              AppSpacing.vGapMd,
              ChoiceCard(
                optionIndex: 'B',
                text: 'Could I have a cup of coffee, please?',
                state: _selectedOption == 1 ? ChoiceCardState.correct : ChoiceCardState.normal,
                onTap: () => setState(() => _selectedOption = 1),
              ),
              AppSpacing.vGapMd,
              ChoiceCard(
                optionIndex: 'C',
                text: 'Coffee is what I want.',
                state: _selectedOption == 2 ? ChoiceCardState.selected : ChoiceCardState.normal,
                onTap: () => setState(() => _selectedOption = 2),
              ),

              const Spacer(),

              // Bottom Full-screen Tactile Button
              PrimaryButton(
                label: 'Check Answer',
                onPressed: _selectedOption != -1 ? () => context.pop() : null,
              ),
              AppSpacing.vGapMd,
            ],
          ),
        ),
      ),
    );
  }
}
