import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/choice_card.dart';
import '../../core/widgets/app_progress_bar.dart';
import '../../data/local/placement_data.dart';

/// 5-question mini placement test.
/// After completion, navigates to the placement result screen.
class PlacementTestScreen extends StatefulWidget {
  const PlacementTestScreen({super.key});

  @override
  State<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends State<PlacementTestScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOption;
  ChoiceCardState? _revealState; // null while selecting, set after answer

  void _onOptionTap(int optionIdx) {
    if (_revealState != null) return; // already answered
    final q = placementQuestions[_currentIndex];
    final isCorrect = optionIdx == q.correctIndex;
    setState(() {
      _selectedOption = optionIdx;
      _revealState =
          isCorrect ? ChoiceCardState.correct : ChoiceCardState.wrong;
      if (isCorrect) _score++;
    });

    // Auto-advance after a brief pause so the user sees the feedback
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      if (_currentIndex < placementQuestions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedOption = null;
          _revealState = null;
        });
      } else {
        // Test complete — navigate to result
        context.go('/onboarding/placement-result', extra: _score);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final q = placementQuestions[_currentIndex];
    final progress = (_currentIndex + 1) / placementQuestions.length;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Question ${_currentIndex + 1} of ${placementQuestions.length}',
          style: textTheme.titleSmall?.copyWith(color: colors.mutedText),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Progress bar
              AppProgressBar(value: progress),
              const SizedBox(height: 28),

              // Question
              Text(
                q.question,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.text,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Options
              Expanded(
                child: ListView.separated(
                  itemCount: q.options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    ChoiceCardState cardState;
                    if (_revealState == null) {
                      cardState = _selectedOption == i
                          ? ChoiceCardState.selected
                          : ChoiceCardState.normal;
                    } else if (i == q.correctIndex) {
                      cardState = ChoiceCardState.correct;
                    } else if (i == _selectedOption) {
                      cardState = ChoiceCardState.wrong;
                    } else {
                      cardState = ChoiceCardState.normal;
                    }

                    return ChoiceCard(
                      text: q.options[i],
                      state: cardState,
                      optionIndex: String.fromCharCode(65 + i), // A, B, C, D
                      onTap: () => _onOptionTap(i),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

