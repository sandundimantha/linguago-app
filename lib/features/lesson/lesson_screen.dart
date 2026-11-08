import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_progress_bar.dart';
import '../../core/widgets/hearts_counter.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';
import '../../data/models/lesson_models.dart';
import 'controllers/lesson_controller.dart';
import 'lesson_complete_screen.dart';
import 'widgets/feedback_bottom_sheet.dart';
import 'widgets/out_of_hearts_modal.dart';
import 'widgets/question_fill_blank.dart';
import 'widgets/question_listening.dart';
import 'widgets/question_match_pairs.dart';
import 'widgets/question_multiple_choice.dart';
import 'widgets/question_sentence_builder.dart';
import 'widgets/question_speaking.dart';

class LessonScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const LessonScreen({
    super.key,
    required this.lessonId,
  });

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  LessonModel? _loadedLesson;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLesson();
  }

  Future<void> _fetchLesson() async {
    final repo = ref.read(lessonRepositoryProvider);
    final lesson = await repo.getLessonById(widget.lessonId);
    if (mounted) {
      setState(() {
        _loadedLesson = lesson;
        _isLoading = false;
      });
    }
  }

  void _showOutOfHearts(LessonController controller) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => OutOfHeartsModal(
        onRefill: () {
          Navigator.of(ctx).pop();
          controller.refillHearts();
        },
        onQuit: () {
          Navigator.of(ctx).pop();
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: colors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadedLesson == null) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(leading: const BackButton()),
        body: const Center(child: Text('Lesson not found')),
      );
    }

    final lesson = _loadedLesson!;
    final lessonState = ref.watch(lessonControllerProvider(lesson));
    final controller = ref.read(lessonControllerProvider(lesson).notifier);

    // If out of hearts, show modal
    ref.listen<LessonState>(lessonControllerProvider(lesson), (prev, next) {
      if (next.phase == LessonPhase.outOfHearts &&
          prev?.phase != LessonPhase.outOfHearts) {
        _showOutOfHearts(controller);
      }
    });

    // If completed, navigate to complete screen
    if (lessonState.phase == LessonPhase.completed) {
      final repo = ref.read(lessonRepositoryProvider);
      return LessonCompleteScreen(
        xpEarned: lessonState.xpEarned,
        accuracy: lessonState.accuracy,
        streak: repo.getStreak(),
      );
    }

    final question = lessonState.currentQuestion;
    final hasSelection = lessonState.currentSelection != null;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Close (X), Progress bar, Hearts
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenMargin,
                vertical: 8,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: colors.mutedText,
                    onPressed: () => context.pop(),
                  ),
                  AppSpacing.hGapSm,
                  Expanded(
                    child: AppProgressBar(
                      value: lessonState.progress,
                      fillColor: colors.success,
                    ),
                  ),
                  AppSpacing.hGapSm,
                  HeartsCounter(count: lessonState.hearts),
                ],
              ),
            ),

            // Question View Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenMargin,
                  vertical: 12,
                ),
                child: _buildQuestionBody(question, lessonState, controller),
              ),
            ),

            // Bottom Area: Check Button OR Feedback Sheet
            if (lessonState.phase == LessonPhase.feedback)
              FeedbackBottomSheet(
                isCorrect: lessonState.isLastAnswerCorrect,
                message: lessonState.feedbackMessage ?? '',
                onContinue: controller.continueNext,
              )
            else
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screenMargin),
                child: PrimaryButton(
                  label: 'Check Answer',
                  onPressed: hasSelection ? controller.checkAnswer : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionBody(
    LessonQuestion q,
    LessonState state,
    LessonController controller,
  ) {
    switch (q.type) {
      case QuestionType.multipleChoice:
        return MultipleChoiceView(
          question: q,
          selectedIndex: state.currentSelection as int?,
          onSelect: controller.selectAnswer,
        );

      case QuestionType.fillBlank:
        return FillBlankView(
          question: q,
          selectedWord: state.currentSelection as String?,
          onSelect: controller.selectAnswer,
        );

      case QuestionType.sentenceBuilder:
        return SentenceBuilderView(
          question: q,
          selectedWords: (state.currentSelection as List<String>?) ?? [],
          onChanged: controller.selectAnswer,
        );

      case QuestionType.matchPairs:
        return MatchPairsView(
          question: q,
          userMatches: (state.currentSelection as Map<String, String>?) ?? {},
          onChanged: controller.selectAnswer,
        );

      case QuestionType.listening:
        return ListeningQuestionView(
          question: q,
          selectedIndex: state.currentSelection as int?,
          onSelect: controller.selectAnswer,
        );

      case QuestionType.speaking:
        return SpeakingQuestionView(
          question: q,
          isRecorded: (state.currentSelection as bool?) ?? false,
          onRecorded: controller.selectAnswer,
        );
    }
  }
}
