import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson_models.dart';

class LessonRepository {
  final SharedPreferences _prefs;
  List<UnitModel>? _cachedUnits;

  LessonRepository(this._prefs);

  static const String _completedLessonsKey = 'completed_lessons_ids';
  static const String _userHeartsKey = 'user_current_hearts';
  static const String _userTotalXpKey = 'user_total_xp';
  static const String _userStreakKey = 'user_active_streak';
  static const String _dailyXpHistoryKey = 'user_daily_xp_history'; // Map<YYYY-MM-DD, int>
  static const String _streakDatesKey = 'user_active_streak_dates'; // List<YYYY-MM-DD>

  Future<List<UnitModel>> loadUnits() async {
    if (_cachedUnits != null) return _cachedUnits!;

    final jsonString = await rootBundle.loadString('assets/lessons.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    final list = (data['units'] as List)
        .map((u) => UnitModel.fromJson(u as Map<String, dynamic>))
        .toList();

    _cachedUnits = list;
    return list;
  }

  Future<LessonModel?> getLessonById(String id) async {
    final units = await loadUnits();
    for (final u in units) {
      for (final l in u.lessons) {
        if (l.id == id) return l;
      }
    }
    return null;
  }

  Set<String> getCompletedLessonIds() {
    final list = _prefs.getStringList(_completedLessonsKey) ?? [];
    return list.toSet();
  }

  Future<void> markLessonCompleted(String lessonId) async {
    final set = getCompletedLessonIds();
    set.add(lessonId);
    await _prefs.setStringList(_completedLessonsKey, set.toList());
  }

  int getHearts() {
    return _prefs.getInt(_userHeartsKey) ?? 5;
  }

  Future<void> setHearts(int count) async {
    await _prefs.setInt(_userHeartsKey, count.clamp(0, 5));
  }

  int getTotalXp() {
    return _prefs.getInt(_userTotalXpKey) ?? 150;
  }

  Future<void> addXp(int xp) async {
    final current = getTotalXp();
    await _prefs.setInt(_userTotalXpKey, current + xp);

    // Record today's XP
    final today = dateKey(DateTime.now());
    final history = getDailyXpHistory();
    history[today] = (history[today] ?? 0) + xp;
    await _prefs.setString(_dailyXpHistoryKey, json.encode(history));

    // Record active date in streak
    final streakDates = getStreakDates();
    if (!streakDates.contains(today)) {
      streakDates.add(today);
      await _prefs.setStringList(_streakDatesKey, streakDates);
    }
  }

  int getStreak() {
    return _prefs.getInt(_userStreakKey) ?? 7;
  }

  Future<void> setStreak(int streak) async {
    await _prefs.setInt(_userStreakKey, streak);
  }

  Map<String, int> getDailyXpHistory() {
    final raw = _prefs.getString(_dailyXpHistoryKey);
    if (raw == null) {
      // Seed with last 7 days of realistic progress data
      final now = DateTime.now();
      return {
        dateKey(now.subtract(const Duration(days: 6))): 25,
        dateKey(now.subtract(const Duration(days: 5))): 40,
        dateKey(now.subtract(const Duration(days: 4))): 30,
        dateKey(now.subtract(const Duration(days: 3))): 55,
        dateKey(now.subtract(const Duration(days: 2))): 45,
        dateKey(now.subtract(const Duration(days: 1))): 50,
        dateKey(now): 60,
      };
    }
    try {
      final decoded = json.decode(raw) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v as int));
    } catch (_) {
      return {};
    }
  }

  List<String> getStreakDates() {
    final list = _prefs.getStringList(_streakDatesKey);
    if (list == null || list.isEmpty) {
      final now = DateTime.now();
      return List.generate(7, (i) => dateKey(now.subtract(Duration(days: i))));
    }
    return list;
  }

  static String dateKey(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }
}
