import 'dart:convert';

/// User preferences model storing the onboarding selections.
class UserPreferences {
  final String? nativeLanguage;
  final String? learningGoal;
  final String? englishLevel;
  final int? placementScore;
  final String? assessedLevel;
  final int dailyGoalMinutes;
  final bool isOnboardingCompleted;

  const UserPreferences({
    this.nativeLanguage,
    this.learningGoal,
    this.englishLevel,
    this.placementScore,
    this.assessedLevel,
    this.dailyGoalMinutes = 10,
    this.isOnboardingCompleted = false,
  });

  UserPreferences copyWith({
    String? nativeLanguage,
    String? learningGoal,
    String? englishLevel,
    int? placementScore,
    String? assessedLevel,
    int? dailyGoalMinutes,
    bool? isOnboardingCompleted,
  }) {
    return UserPreferences(
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      learningGoal: learningGoal ?? this.learningGoal,
      englishLevel: englishLevel ?? this.englishLevel,
      placementScore: placementScore ?? this.placementScore,
      assessedLevel: assessedLevel ?? this.assessedLevel,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      isOnboardingCompleted: isOnboardingCompleted ?? this.isOnboardingCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nativeLanguage': nativeLanguage,
      'learningGoal': learningGoal,
      'englishLevel': englishLevel,
      'placementScore': placementScore,
      'assessedLevel': assessedLevel,
      'dailyGoalMinutes': dailyGoalMinutes,
      'isOnboardingCompleted': isOnboardingCompleted,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      nativeLanguage: map['nativeLanguage'] as String?,
      learningGoal: map['learningGoal'] as String?,
      englishLevel: map['englishLevel'] as String?,
      placementScore: map['placementScore'] as int?,
      assessedLevel: map['assessedLevel'] as String?,
      dailyGoalMinutes: (map['dailyGoalMinutes'] as int?) ?? 10,
      isOnboardingCompleted: (map['isOnboardingCompleted'] as bool?) ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserPreferences.fromJson(String source) =>
      UserPreferences.fromMap(json.decode(source) as Map<String, dynamic>);
}

