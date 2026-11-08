import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'speech_service.dart';

class SpeechServiceImpl implements SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  @override
  bool get isAvailable => _isInitialized;

  @override
  bool get isListening => _speech.isListening;

  @override
  Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speech.initialize(
        onError: (val) {},
        onStatus: (val) {},
      );
      return _isInitialized;
    } catch (_) {
      _isInitialized = false;
      return false;
    }
  }

  @override
  Future<bool> hasMicrophonePermission() async {
    final status = await Permission.microphone.status;
    return status.isGranted;
  }

  @override
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  @override
  Future<void> startListening({
    required Function(String recognizedWords) onResult,
    required Function(String error) onError,
  }) async {
    final hasPerm = await hasMicrophonePermission();
    if (!hasPerm) {
      final granted = await requestMicrophonePermission();
      if (!granted) {
        onError(
            'Microphone access is required for speaking exercises. Please allow permission in Settings.');
        return;
      }
    }

    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) {
        onError('Speech recognition service is not available on this device.');
        return;
      }
    }

    try {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        listenMode: stt.ListenMode.confirmation,
        localeId: 'en_US',
      );
    } catch (e) {
      onError('Listening error: $e');
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      await _speech.stop();
    } catch (_) {}
  }

  @override
  PronunciationResult evaluatePronunciation({
    required String targetSentence,
    required String spokenSentence,
  }) {
    // Clean and split words
    final cleanTargetWords = targetSentence
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'));

    final cleanSpokenWords = spokenSentence
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .trim()
        .toLowerCase()
        .split(RegExp(r'\s+'));

    final originalWords = targetSentence.trim().split(RegExp(r'\s+'));

    final List<WordScore> wordScores = [];
    int matchCount = 0;

    for (int i = 0; i < cleanTargetWords.length; i++) {
      final target = cleanTargetWords[i];
      final original = i < originalWords.length ? originalWords[i] : target;

      // Look for exact or fuzzy match in spoken words
      if (cleanSpokenWords.contains(target)) {
        wordScores.add(WordScore(
          targetWord: original,
          spokenWord: target,
          status: WordScoreStatus.correct,
          confidence: 1.0,
        ));
        matchCount += 2; // full points
      } else {
        // Check partial / Levenshtein distance
        bool foundClose = false;
        String? closeWord;
        for (final sp in cleanSpokenWords) {
          final similarity = _stringSimilarity(target, sp);
          if (similarity >= 0.6) {
            foundClose = true;
            closeWord = sp;
            break;
          }
        }

        if (foundClose) {
          wordScores.add(WordScore(
            targetWord: original,
            spokenWord: closeWord,
            status: WordScoreStatus.almost,
            confidence: 0.6,
          ));
          matchCount += 1; // partial points
        } else {
          wordScores.add(WordScore(
            targetWord: original,
            spokenWord: null,
            status: WordScoreStatus.incorrect,
            confidence: 0.0,
          ));
        }
      }
    }

    final double maxPoints = (cleanTargetWords.length * 2).toDouble();
    final double overallScore =
        maxPoints > 0 ? ((matchCount / maxPoints) * 100).clamp(0.0, 100.0) : 0.0;

    String feedbackTip;
    if (overallScore >= 90) {
      feedbackTip =
          'Outstanding native-like pronunciation and natural cadence!';
    } else if (overallScore >= 75) {
      feedbackTip =
          'Great clarity! Focus on the amber-highlighted words to sound even crisper.';
    } else if (overallScore >= 50) {
      feedbackTip =
          'Good attempt! Slow down slightly and articulate individual consonant clusters.';
    } else {
      feedbackTip =
          'Keep practicing! Listen to the audio model carefully and try imitating the rhythm.';
    }

    return PronunciationResult(
      targetSentence: targetSentence,
      recognizedSentence: spokenSentence,
      overallScore: overallScore,
      wordScores: wordScores,
      feedbackTip: feedbackTip,
    );
  }

  double _stringSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    final int distance = _levenshteinDistance(s1, s2);
    final int maxLen = max(s1.length, s2.length);
    return (1.0 - (distance / maxLen)).clamp(0.0, 1.0);
  }

  int _levenshteinDistance(String a, String b) {
    List<List<int>> d = List.generate(
      a.length + 1,
      (i) => List.filled(b.length + 1, 0),
    );

    for (int i = 0; i <= a.length; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= b.length; j++) {
      d[0][j] = j;
    }

    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        final cost = (a[i - 1] == b[j - 1]) ? 0 : 1;
        d[i][j] = min(
          d[i - 1][j] + 1,
          min(d[i][j - 1] + 1, d[i - 1][j - 1] + cost),
        );
      }
    }
    return d[a.length][b.length];
  }
}

