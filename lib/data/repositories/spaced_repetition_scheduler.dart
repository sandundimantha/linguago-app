import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Leitner Box Levels with interval days:
/// Box 1: 1 day
/// Box 2: 3 days
/// Box 3: 7 days
/// Box 4: 14 days
class SpacedRepetitionItem {
  final String wordId;
  final int box; // 1 to 4
  final DateTime nextReviewDate;
  final int timesReviewed;

  const SpacedRepetitionItem({
    required this.wordId,
    required this.box,
    required this.nextReviewDate,
    this.timesReviewed = 0,
  });

  static int intervalDaysForBox(int box) {
    switch (box) {
      case 1:
        return 1;
      case 2:
        return 3;
      case 3:
        return 7;
      case 4:
      default:
        return 14;
    }
  }

  SpacedRepetitionItem copyWithSuccess() {
    final nextBox = (box + 1).clamp(1, 4);
    final days = intervalDaysForBox(nextBox);
    return SpacedRepetitionItem(
      wordId: wordId,
      box: nextBox,
      nextReviewDate: DateTime.now().add(Duration(days: days)),
      timesReviewed: timesReviewed + 1,
    );
  }

  SpacedRepetitionItem copyWithFailure() {
    // Demote back to Box 1 for review tomorrow
    return SpacedRepetitionItem(
      wordId: wordId,
      box: 1,
      nextReviewDate: DateTime.now().add(const Duration(days: 1)),
      timesReviewed: timesReviewed + 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'wordId': wordId,
    'box': box,
    'nextReviewDate': nextReviewDate.toIso8601String(),
    'timesReviewed': timesReviewed,
  };

  factory SpacedRepetitionItem.fromJson(Map<String, dynamic> json) {
    return SpacedRepetitionItem(
      wordId: json['wordId'] as String? ?? '',
      box: json['box'] as int? ?? 1,
      nextReviewDate: json['nextReviewDate'] != null
          ? DateTime.tryParse(json['nextReviewDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      timesReviewed: json['timesReviewed'] as int? ?? 0,
    );
  }
}

class SpacedRepetitionScheduler {
  final SharedPreferences _prefs;
  static const String _keySrs = 'linguago_srs_records';

  SpacedRepetitionScheduler(this._prefs);

  Map<String, SpacedRepetitionItem> getAllRecords() {
    final raw = _prefs.getString(_keySrs);
    if (raw == null) return {};
    try {
      final decoded = json.decode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) =>
          MapEntry(k, SpacedRepetitionItem.fromJson(v as Map<String, dynamic>)));
    } catch (_) {
      return {};
    }
  }

  Future<void> saveRecord(SpacedRepetitionItem item) async {
    final records = getAllRecords();
    records[item.wordId] = item;
    final map = records.map((k, v) => MapEntry(k, v.toJson()));
    await _prefs.setString(_keySrs, json.encode(map));
  }

  Future<void> reviewWord({required String wordId, required bool knewIt}) async {
    final records = getAllRecords();
    final existing = records[wordId] ??
        SpacedRepetitionItem(
          wordId: wordId,
          box: 1,
          nextReviewDate: DateTime.now(),
        );

    final updated = knewIt ? existing.copyWithSuccess() : existing.copyWithFailure();
    await saveRecord(updated);
  }

  bool isDue(String wordId) {
    final records = getAllRecords();
    final item = records[wordId];
    if (item == null) return true; // not reviewed yet = due
    return DateTime.now().isAfter(item.nextReviewDate);
  }

  int getBox(String wordId) {
    final records = getAllRecords();
    return records[wordId]?.box ?? 1;
  }

  int getDueCount(List<String> allWordIds) {
    return allWordIds.where(isDue).length;
  }
}

