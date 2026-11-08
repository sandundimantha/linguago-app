class VocabWord {
  final String id;
  final String word;
  final String phonetic;
  final String partOfSpeech;
  final String definition;
  final String example;
  final List<String> synonyms;
  final String category;
  final String level;

  const VocabWord({
    required this.id,
    required this.word,
    required this.phonetic,
    required this.partOfSpeech,
    required this.definition,
    required this.example,
    required this.synonyms,
    required this.category,
    required this.level,
  });

  factory VocabWord.fromJson(Map<String, dynamic> json) {
    return VocabWord(
      id: json['id'] as String? ?? '',
      word: json['word'] as String? ?? '',
      phonetic: json['phonetic'] as String? ?? '',
      partOfSpeech: json['partOfSpeech'] as String? ?? '',
      definition: json['definition'] as String? ?? '',
      example: json['example'] as String? ?? '',
      synonyms: (json['synonyms'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      category: json['category'] as String? ?? 'General',
      level: json['level'] as String? ?? 'Intermediate',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'phonetic': phonetic,
    'partOfSpeech': partOfSpeech,
    'definition': definition,
    'example': example,
    'synonyms': synonyms,
    'category': category,
    'level': level,
  };
}

class GrammarRule {
  final String title;
  final String explanation;
  final String exampleCorrect;
  final String exampleIncorrect;

  const GrammarRule({
    required this.title,
    required this.explanation,
    required this.exampleCorrect,
    required this.exampleIncorrect,
  });

  factory GrammarRule.fromJson(Map<String, dynamic> json) {
    return GrammarRule(
      title: json['title'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      exampleCorrect: json['exampleCorrect'] as String? ?? '',
      exampleIncorrect: json['exampleIncorrect'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'explanation': explanation,
    'exampleCorrect': exampleCorrect,
    'exampleIncorrect': exampleIncorrect,
  };
}

class GrammarExercise {
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const GrammarExercise({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  factory GrammarExercise.fromJson(Map<String, dynamic> json) {
    return GrammarExercise(
      prompt: json['prompt'] as String? ?? '',
      options: (json['options'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      correctIndex: json['correctIndex'] as int? ?? 0,
      explanation: json['explanation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'prompt': prompt,
    'options': options,
    'correctIndex': correctIndex,
    'explanation': explanation,
  };
}

class GrammarTopic {
  final String id;
  final String title;
  final String level;
  final String description;
  final String formula;
  final List<GrammarRule> rules;
  final List<GrammarExercise> exercises;

  const GrammarTopic({
    required this.id,
    required this.title,
    required this.level,
    required this.description,
    required this.formula,
    required this.rules,
    required this.exercises,
  });

  factory GrammarTopic.fromJson(Map<String, dynamic> json) {
    final rulesList = (json['rules'] as List?)
            ?.map((e) => GrammarRule.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final exercisesList = (json['exercises'] as List?)
            ?.map((e) => GrammarExercise.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return GrammarTopic(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      level: json['level'] as String? ?? 'Intermediate',
      description: json['description'] as String? ?? '',
      formula: json['formula'] as String? ?? '',
      rules: rulesList,
      exercises: exercisesList,
    );
  }
}

