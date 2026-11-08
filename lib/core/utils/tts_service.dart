import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;

  Future<void> _init() async {
    if (_isInitialized) return;
    try {
      _flutterTts = FlutterTts();
      await _flutterTts?.setLanguage('en-US');
      await _flutterTts?.setSpeechRate(0.45);
      await _flutterTts?.setVolume(1.0);
      await _flutterTts?.setPitch(1.0);
      _isInitialized = true;
    } catch (_) {
      // Fallback gracefully on environments without TTS native engine
      _isInitialized = false;
    }
  }

  Future<void> speak(String text) async {
    await _init();
    try {
      await _flutterTts?.stop();
      await _flutterTts?.speak(text);
    } catch (_) {
      // Silent catch if platform audio not ready
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts?.stop();
    } catch (_) {}
  }
}

