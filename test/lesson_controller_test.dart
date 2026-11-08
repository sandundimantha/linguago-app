import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linguago/data/models/lesson_models.dart';
import 'package:linguago/data/repositories/lesson_repository.dart';
import 'package:linguago/features/lesson/controllers/lesson_controller.dart';

void main() {
  group('LessonController Answer Checking & XP Tests', () {
    late SharedPreferences prefs;
    late LessonRepository repo;
    late LessonModel testLesson;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repo = LessonRepository(prefs);

      testLesson = const LessonModel(
        id: 'test_l1',
        unitId: 'u1',
        title: 'Test Lesson',
        subtitle: 'Test Subtitle',
        xpReward: 30,
        questions: [
          LessonQuestion(
            id: 'q1',
            type: QuestionType.multipleChoice,
            prompt: 'Choose option B',
            explanation: 'B is right',
            options: ['A', 'B', 'C'],
            correctIndex: 1,
          ),
          LessonQuestion(
            id: 'q2',
            type: QuestionType.fillBlank,
            prompt: 'Fill the blank',
            explanation: 'hello is correct',
            sentence: 'Say ___ to me',
            options: ['hello', 'bye'],
            correctAnswer: 'hello',
          ),
          LessonQuestion(
            id: 'q3',
            type: QuestionType.sentenceBuilder,
            prompt: 'Assemble',
            explanation: 'I love English',
            words: ['I', 'love', 'English'],
            correctSentence: 'I love English',
          ),
          LessonQuestion(
            id: 'q4',
            type: QuestionType.matchPairs,
            prompt: 'Match pairs',
            explanation: 'Matched successfully',
            pairs: [
              MatchPair(left: 'A', right: '1'),
              MatchPair(left: 'B', right: '2'),
            ],
          ),
        ],
      );
    });

    test('Initial state has 5 hearts, 0 XP, and 0 question index', () {
      final controller = LessonController(repo, testLesson);
      expect(controller.state.hearts, 5);
      expect(controller.state.xpEarned, 0);
      expect(controller.state.currentQuestionIndex, 0);
      expect(controller.state.phase, LessonPhase.question);
    });

    test('Multiple Choice: Correct answer gives XP and triggers feedback phase', () {
      final controller = LessonController(repo, testLesson);
      controller.selectAnswer(1); // Option B

      final isCorrect = controller.checkAnswer();

      expect(isCorrect, isTrue);
      expect(controller.state.isLastAnswerCorrect, isTrue);
      expect(controller.state.phase, LessonPhase.feedback);
      expect(controller.state.xpEarned, greaterThan(0));
      expect(controller.state.hearts, 5);
    });

    test('Multiple Choice: Incorrect answer deducts 1 heart', () {
      final controller = LessonController(repo, testLesson);
      controller.selectAnswer(0); // Option A (Wrong)

      final isCorrect = controller.checkAnswer();

      expect(isCorrect, isFalse);
      expect(controller.state.isLastAnswerCorrect, isFalse);
      expect(controller.state.phase, LessonPhase.feedback);
      expect(controller.state.hearts, 4);
      expect(controller.state.xpEarned, 0);
    });

    test('Fill Blank: Correct case-insensitive answer validation', () {
      final controller = LessonController(repo, testLesson);
      // Skip to question 1
      controller.continueNext();
      expect(controller.state.currentQuestionIndex, 1);

      controller.selectAnswer('Hello'); // capitalized
      final isCorrect = controller.checkAnswer();

      expect(isCorrect, isTrue);
      expect(controller.state.isLastAnswerCorrect, isTrue);
    });

    test('Sentence Builder: Correct order assembly validation', () {
      final controller = LessonController(repo, testLesson);
      // Advance to question 2
      controller.continueNext();
      controller.continueNext();
      expect(controller.state.currentQuestionIndex, 2);

      controller.selectAnswer(['I', 'love', 'English']);
      expect(controller.checkAnswer(), isTrue);

      // Reset and test wrong order
      final controllerWrong = LessonController(repo, testLesson);
      controllerWrong.continueNext();
      controllerWrong.continueNext();
      controllerWrong.selectAnswer(['English', 'I', 'love']);
      expect(controllerWrong.checkAnswer(), isFalse);
    });

    test('Match Pairs: All pairs correctly matched verification', () {
      final controller = LessonController(repo, testLesson);
      // Advance to question 3
      controller.continueNext();
      controller.continueNext();
      controller.continueNext();
      expect(controller.state.currentQuestionIndex, 3);

      controller.selectAnswer({'A': '1', 'B': '2'});
      expect(controller.checkAnswer(), isTrue);

      final controllerWrong = LessonController(repo, testLesson);
      controllerWrong.continueNext();
      controllerWrong.continueNext();
      controllerWrong.continueNext();
      controllerWrong.selectAnswer({'A': '2', 'B': '1'});
      expect(controllerWrong.checkAnswer(), isFalse);
    });

    test('Hearts drop to 0 enters outOfHearts phase', () {
      final controller = LessonController(repo, testLesson);
      // Fail 4 times on question 0, 1, 2, 3
      // Q0: multiple choice
      controller.selectAnswer(0); // wrong
      controller.checkAnswer();
      expect(controller.state.hearts, 4);
      controller.continueNext();

      // Q1: fill blank
      controller.selectAnswer('wrong_word');
      controller.checkAnswer();
      expect(controller.state.hearts, 3);
      controller.continueNext();

      // Q2: sentence builder
      controller.selectAnswer(['Wrong', 'sentence']);
      controller.checkAnswer();
      expect(controller.state.hearts, 2);
      controller.continueNext();

      // Q3: match pairs
      controller.selectAnswer({'A': 'wrong'});
      controller.checkAnswer();
      expect(controller.state.hearts, 1);

      // Now repeat failure when still on question 3: simulate retrying question with heart deduction
      final freshController = LessonController(repo, testLesson);
      // hearts in repo is now 1!
      expect(freshController.state.hearts, 1);

      freshController.selectAnswer(0); // wrong
      freshController.checkAnswer();

      expect(freshController.state.hearts, 0);
      expect(freshController.state.phase, LessonPhase.outOfHearts);
    });

    test('Refill hearts resets hearts to 5', () {
      final controller = LessonController(repo, testLesson);
      controller.selectAnswer(0); // wrong
      controller.checkAnswer();
      expect(controller.state.hearts, 4);

      controller.refillHearts();
      expect(controller.state.hearts, 5);
      expect(controller.state.phase, LessonPhase.question);
    });
  });
}

