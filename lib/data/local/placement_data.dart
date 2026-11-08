/// Placement test question model.
class PlacementQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const PlacementQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

/// 5 placement-test questions ordered easiest → hardest.
const List<PlacementQuestion> placementQuestions = [
  PlacementQuestion(
    question: 'Choose the correct word:\n"She ___ to school every day."',
    options: ['go', 'goes', 'going', 'gone'],
    correctIndex: 1,
  ),
  PlacementQuestion(
    question: 'Which sentence is correct?',
    options: [
      'He don\'t like coffee.',
      'He doesn\'t likes coffee.',
      'He doesn\'t like coffee.',
      'He not like coffee.',
    ],
    correctIndex: 2,
  ),
  PlacementQuestion(
    question: 'Choose the correct tense:\n"By next year, I ___ here for five years."',
    options: [
      'will work',
      'will have worked',
      'am working',
      'have worked',
    ],
    correctIndex: 1,
  ),
  PlacementQuestion(
    question: 'What does "ubiquitous" mean?',
    options: [
      'Very rare',
      'Found everywhere',
      'Extremely large',
      'Quite beautiful',
    ],
    correctIndex: 1,
  ),
  PlacementQuestion(
    question: 'Choose the best word:\n"The manager\'s decision was ___; no one could change it."',
    options: [
      'irrevocable',
      'inevitable',
      'inconceivable',
      'indispensable',
    ],
    correctIndex: 0,
  ),
];

/// Map a raw score (0-5) to a proficiency level label.
String levelFromScore(int score) {
  if (score <= 1) return 'Beginner';
  if (score <= 2) return 'Elementary';
  if (score <= 3) return 'Intermediate';
  return 'Advanced';
}

