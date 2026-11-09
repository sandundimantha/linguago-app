
enum QuestionType {
  multipleChoice('multiple_choice'),
  fillBlank('fill_blank'),
  sentenceBuilder('sentence_builder'),
  matchPairs('match_pairs'),
  listening('listening'),
  speaking('speaking');

  final String value;
  const QuestionType(this.value);

  static QuestionType fromString(String val) {
    return QuestionType.values.firstWhere(
      (e) => e.value == val,
      orElse: () => QuestionType.multipleChoice,
    );
  }
}

class MatchPair {
  final String left;
  final String right;

  const MatchPair({required this.left, required this.right});

  factory MatchPair.fromJson(Map<String, dynamic> json) {
    return MatchPair(
      left: json['left'] as String? ?? '',
      right: json['right'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'left': left, 'right': right};
}

class LessonQuestion {
  final String id;
  final QuestionType type;
  final String prompt;
  final String explanation;

  // Type specific properties
  final List<String> options;
  final int? correctIndex;
  final String? sentence;
  final String? correctAnswer;
  final List<String> words;
  final String? correctSentence;
  final List<MatchPair> pairs;
  final String? audioText;
  final String? targetText;
  final String? phoneticHint;

  const LessonQuestion({
    required this.id,
    required this.type,
    required this.prompt,
    required this.explanation,
    this.options = const [],
    this.correctIndex,
    this.sentence,
    this.correctAnswer,
    this.words = const [],
    this.correctSentence,
    this.pairs = const [],
    this.audioText,
    this.targetText,
    this.phoneticHint,
  });

  factory LessonQuestion.fromJson(Map<String, dynamic> json) {
    final type = QuestionType.fromString(json['type'] as String? ?? '');

    List<MatchPair> parsedPairs = [];
    if (json['pairs'] != null) {
      parsedPairs = (json['pairs'] as List)
          .map((e) => MatchPair.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return LessonQuestion(
      id: json['id'] as String? ?? '',
      type: type,
      prompt: json['prompt'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      options: (json['options'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      correctIndex: json['correctIndex'] as int?,
      sentence: json['sentence'] as String?,
      correctAnswer: json['correctAnswer'] as String?,
      words: (json['words'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      correctSentence: json['correctSentence'] as String?,
      pairs: parsedPairs,
      audioText: json['audioText'] as String?,
      targetText: json['targetText'] as String?,
      phoneticHint: json['phoneticHint'] as String?,
    );
  }
}

class LessonModel {
  final String id;
  final String unitId;
  final String title;
  final String subtitle;
  final int xpReward;
  final List<LessonQuestion> questions;

  const LessonModel({
    required this.id,
    required this.unitId,
    required this.title,
    required this.subtitle,
    required this.xpReward,
    required this.questions,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    final qList = (json['questions'] as List?)
            ?.map((e) => LessonQuestion.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return LessonModel(
      id: json['id'] as String? ?? '',
      unitId: json['unitId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      xpReward: json['xpReward'] as int? ?? 20,
      questions: qList,
    );
  }
}

class UnitModel {
  final String id;
  final int unitNumber;
  final String title;
  final String description;
  final String color;
  final String icon;
  final List<LessonModel> lessons;

  const UnitModel({
    required this.id,
    required this.unitNumber,
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.lessons,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    final lList = (json['lessons'] as List?)
            ?.map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return UnitModel(
      id: json['id'] as String? ?? '',
      unitNumber: json['unitNumber'] as int? ?? 1,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      color: json['color'] as String? ?? '0xFF4F46E5',
      icon: json['icon'] as String? ?? 'book',
      lessons: lList,
    );
  }
}

