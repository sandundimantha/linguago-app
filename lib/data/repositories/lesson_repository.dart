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
    return _prefs.getInt(_userTotalXpKey) ?? 120;
  }

  Future<void> addXp(int xp) async {
    final current = getTotalXp();
    await _prefs.setInt(_userTotalXpKey, current + xp);
  }

  int getStreak() {
    return _prefs.getInt(_userStreakKey) ?? 7;
  }

  Future<void> setStreak(int streak) async {
    await _prefs.setInt(_userStreakKey, streak);
  }
}

