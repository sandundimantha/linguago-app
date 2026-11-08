import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/lesson_models.dart';
import '../../../data/repositories/lesson_repository.dart';

enum LessonPhase {
  question, // user is answering question
  feedback, // feedback bottom sheet is showing (correct or incorrect)
  completed, // lesson completed successfully
  outOfHearts, // hearts dropped to 0
}

class LessonState {
  final LessonModel lesson;
  final int currentQuestionIndex;
  final int hearts;
  final int xpEarned;
  final int correctAnswersCount;
  final LessonPhase phase;
  final bool isLastAnswerCorrect;
  final String? feedbackMessage;
  final dynamic currentSelection; // chosen answer object/index/etc.

  const LessonState({
    required this.lesson,
    this.currentQuestionIndex = 0,
    this.hearts = 5,
    this.xpEarned = 0,
    this.correctAnswersCount = 0,
    this.phase = LessonPhase.question,
    this.isLastAnswerCorrect = false,
    this.feedbackMessage,
    this.currentSelection,
  });

  LessonQuestion get currentQuestion =>
      lesson.questions[currentQuestionIndex.clamp(0, lesson.questions.length - 1)];

  double get progress {
    if (lesson.questions.isEmpty) return 0.0;
    return currentQuestionIndex / lesson.questions.length;
  }

  double get accuracy {
    if (currentQuestionIndex == 0) return 1.0;
    return (correctAnswersCount / (currentQuestionIndex + 1)).clamp(0.0, 1.0);
  }

  LessonState copyWith({
    LessonModel? lesson,
    int? currentQuestionIndex,
    int? hearts,
    int? xpEarned,
    int? correctAnswersCount,
    LessonPhase? phase,
    bool? isLastAnswerCorrect,
    String? feedbackMessage,
    dynamic currentSelection,
    bool clearSelection = false,
  }) {
    return LessonState(
      lesson: lesson ?? this.lesson,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      hearts: hearts ?? this.hearts,
      xpEarned: xpEarned ?? this.xpEarned,
      correctAnswersCount: correctAnswersCount ?? this.correctAnswersCount,
      phase: phase ?? this.phase,
      isLastAnswerCorrect: isLastAnswerCorrect ?? this.isLastAnswerCorrect,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
      currentSelection:
          clearSelection ? null : (currentSelection ?? this.currentSelection),
    );
  }
}

class LessonController extends StateNotifier<LessonState> {
  final LessonRepository _repo;

  LessonController(this._repo, LessonModel lesson)
      : super(LessonState(
          lesson: lesson,
          hearts: _repo.getHearts(),
        ));

  void selectAnswer(dynamic selection) {
    if (state.phase != LessonPhase.question) return;
    state = state.copyWith(currentSelection: selection);
  }

  bool checkAnswer() {
    if (state.phase != LessonPhase.question) return false;
    final q = state.currentQuestion;
    final selection = state.currentSelection;

    bool isCorrect = false;

    switch (q.type) {
      case QuestionType.multipleChoice:
      case QuestionType.listening:
        if (selection is int) {
          isCorrect = selection == q.correctIndex;
        }
        break;
      case QuestionType.fillBlank:
        if (selection is String) {
          isCorrect =
              selection.trim().toLowerCase() == q.correctAnswer?.trim().toLowerCase();
        }
        break;
      case QuestionType.sentenceBuilder:
        if (selection is List<String>) {
          final assembled = selection.join(' ').trim();
          isCorrect = assembled.toLowerCase() ==
              (q.correctSentence ?? '').trim().toLowerCase();
        }
        break;
      case QuestionType.matchPairs:
        // selection is Map<String, String> of user paired matches
        if (selection is Map<String, String>) {
          isCorrect = q.pairs.every((pair) => selection[pair.left] == pair.right);
        }
        break;
      case QuestionType.speaking:
        // simulated speech check
        isCorrect = true;
        break;
    }

    if (isCorrect) {
      final int additionalXp = (state.lesson.xpReward / state.lesson.questions.length).round();
      state = state.copyWith(
        phase: LessonPhase.feedback,
        isLastAnswerCorrect: true,
        xpEarned: state.xpEarned + additionalXp,
        correctAnswersCount: state.correctAnswersCount + 1,
        feedbackMessage: q.explanation.isNotEmpty
            ? q.explanation
            : 'Well done! That is completely correct.',
      );
    } else {
      final newHearts = (state.hearts - 1).clamp(0, 5);
      _repo.setHearts(newHearts);

      if (newHearts <= 0) {
        state = state.copyWith(
          hearts: 0,
          phase: LessonPhase.outOfHearts,
          isLastAnswerCorrect: false,
          feedbackMessage: q.explanation.isNotEmpty
              ? q.explanation
              : 'Incorrect! You ran out of hearts.',
        );
      } else {
        state = state.copyWith(
          hearts: newHearts,
          phase: LessonPhase.feedback,
          isLastAnswerCorrect: false,
          feedbackMessage: q.explanation.isNotEmpty
              ? q.explanation
              : 'Not quite right. Keep trying!',
        );
      }
    }

    return isCorrect;
  }

  void continueNext() {
    if (state.phase == LessonPhase.outOfHearts) return;

    if (state.currentQuestionIndex + 1 >= state.lesson.questions.length) {
      // Completed all questions in the lesson
      _repo.markLessonCompleted(state.lesson.id);
      _repo.addXp(state.xpEarned);
      state = state.copyWith(phase: LessonPhase.completed);
    } else {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        phase: LessonPhase.question,
        clearSelection: true,
      );
    }
  }

  void refillHearts() {
    _repo.setHearts(5);
    state = state.copyWith(
      hearts: 5,
      phase: LessonPhase.question,
      clearSelection: true,
    );
  }
}
