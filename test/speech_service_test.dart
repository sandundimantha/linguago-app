import 'package:flutter_test/flutter_test.dart';
import 'package:linguago/core/services/speech_service.dart';
import 'package:linguago/core/services/speech_service_impl.dart';

void main() {
  group('SpeechService Evaluation & Scoring Tests', () {
    late SpeechService speechService;

    setUp(() {
      speechService = SpeechServiceImpl();
    });

    test('Exact sentence match gives 100% score and all words green', () {
      const sentence = 'Good morning could I please get coffee';
      final result = speechService.evaluatePronunciation(
        targetSentence: sentence,
        spokenSentence: sentence,
      );

      expect(result.overallScore, 100.0);
      expect(result.wordScores.length, 7);
      expect(
        result.wordScores.every((w) => w.status == WordScoreStatus.correct),
        isTrue,
      );
    });

    test('Case-insensitivity and punctuation stripping', () {
      const target = 'Hello, world! How are you?';
      const spoken = 'hello world how are you';

      final result = speechService.evaluatePronunciation(
        targetSentence: target,
        spokenSentence: spoken,
      );

      expect(result.overallScore, 100.0);
      expect(
        result.wordScores.every((w) => w.status == WordScoreStatus.correct),
        isTrue,
      );
    });

    test('Partial fuzzy match flags word as almost (amber)', () {
      const target = 'She gave an eloquent presentation';
      // 'eloquent' slightly misspelled / phonetic shift to 'eloquence'
      const spoken = 'She gave an eloquence presentation';

      final result = speechService.evaluatePronunciation(
        targetSentence: target,
        spokenSentence: spoken,
      );

      expect(result.overallScore, greaterThan(70.0));
      expect(result.overallScore, lessThan(100.0));

      final eloquentScore = result.wordScores
          .firstWhere((w) => w.targetWord.toLowerCase().contains('eloquent'));
      expect(eloquentScore.status, WordScoreStatus.almost);
    });

    test('Missing / completely wrong words flag as incorrect (red)', () {
      const target = 'Finding my dream apartment was serendipity';
      const spoken = 'Finding my car';

      final result = speechService.evaluatePronunciation(
        targetSentence: target,
        spokenSentence: spoken,
      );

      expect(result.overallScore, lessThan(50.0));

      final serendipityScore = result.wordScores
          .firstWhere((w) => w.targetWord.toLowerCase().contains('serendipity'));
      expect(serendipityScore.status, WordScoreStatus.incorrect);
    });
  });
}

