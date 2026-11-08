enum WordScoreStatus {
  correct, // Green (> 80% match or exact)
  almost, // Amber (partial match / typo / close phonetic match)
  incorrect, // Red (missing, heavily mispronounced or completely wrong)
}

class WordScore {
  final String targetWord;
  final String? spokenWord;
  final WordScoreStatus status;
  final double confidence;

  const WordScore({
    required this.targetWord,
    this.spokenWord,
    required this.status,
    this.confidence = 1.0,
  });
}

class PronunciationResult {
  final String targetSentence;
  final String recognizedSentence;
  final double overallScore; // 0.0 to 100.0
  final List<WordScore> wordScores;
  final String feedbackTip;

  const PronunciationResult({
    required this.targetSentence,
    required this.recognizedSentence,
    required this.overallScore,
    required this.wordScores,
    required this.feedbackTip,
  });
}

abstract class SpeechService {
  /// Initialize speech recognition engine and permissions
  Future<bool> initialize();

  /// Check whether speech recognition is available on this device
  bool get isAvailable;

  /// Check if microphone permission is granted
  Future<bool> hasMicrophonePermission();

  /// Request microphone permission explicitly
  Future<bool> requestMicrophonePermission();

  /// Start live recording and speech-to-text listening
  Future<void> startListening({
    required Function(String recognizedWords) onResult,
    required Function(String error) onError,
  });

  /// Stop speech listening
  Future<void> stopListening();

  /// Whether currently actively listening to audio
  bool get isListening;

  /// Compares target sentence with user-spoken text and returns scoring with word-level feedback
  PronunciationResult evaluatePronunciation({
    required String targetSentence,
    required String spokenSentence,
  });
}

