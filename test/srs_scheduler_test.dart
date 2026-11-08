import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linguago/data/repositories/spaced_repetition_scheduler.dart';

void main() {
  group('SpacedRepetitionScheduler Tests', () {
    late SharedPreferences prefs;
    late SpacedRepetitionScheduler srs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      srs = SpacedRepetitionScheduler(prefs);
    });

    test('Initial word is due and starts at Box 1', () {
      expect(srs.isDue('v1'), isTrue);
      expect(srs.getBox('v1'), 1);
    });

    test('Knowing word advances box from 1 to 2 and extends interval by 3 days', () async {
      await srs.reviewWord(wordId: 'v1', knewIt: true);

      expect(srs.getBox('v1'), 2);
      // Immediately after review, it should no longer be due
      expect(srs.isDue('v1'), isFalse);

      final record = srs.getAllRecords()['v1']!;
      expect(record.timesReviewed, 1);
      final diffDays = record.nextReviewDate.difference(DateTime.now()).inDays;
      expect(diffDays, inInclusiveRange(2, 3));
    });

    test('Progressing word through Box 2 -> 3 -> 4', () async {
      await srs.reviewWord(wordId: 'v2', knewIt: true); // box 2
      expect(srs.getBox('v2'), 2);

      await srs.reviewWord(wordId: 'v2', knewIt: true); // box 3
      expect(srs.getBox('v2'), 3);

      await srs.reviewWord(wordId: 'v2', knewIt: true); // box 4
      expect(srs.getBox('v2'), 4);

      // Max box is 4
      await srs.reviewWord(wordId: 'v2', knewIt: true);
      expect(srs.getBox('v2'), 4);
    });

    test('Failure (Still learning) resets word back to Box 1', () async {
      await srs.reviewWord(wordId: 'v3', knewIt: true);
      await srs.reviewWord(wordId: 'v3', knewIt: true);
      expect(srs.getBox('v3'), 3);

      // Failed review
      await srs.reviewWord(wordId: 'v3', knewIt: false);
      expect(srs.getBox('v3'), 1);

      final record = srs.getAllRecords()['v3']!;
      expect(record.box, 1);
      final diffDays = record.nextReviewDate.difference(DateTime.now()).inDays;
      expect(diffDays, inInclusiveRange(0, 1));
    });

    test('Due count calculation across a word list', () async {
      final words = ['v1', 'v2', 'v3'];
      expect(srs.getDueCount(words), 3);

      await srs.reviewWord(wordId: 'v1', knewIt: true);
      expect(srs.getDueCount(words), 2);

      await srs.reviewWord(wordId: 'v2', knewIt: true);
      expect(srs.getDueCount(words), 1);
    });
  });
}

