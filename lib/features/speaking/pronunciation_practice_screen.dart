import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/speech_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/tts_service.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';
import 'pronunciation_feedback_screen.dart';

class PronunciationPracticeScreen extends ConsumerStatefulWidget {
  const PronunciationPracticeScreen({super.key});

  @override
  ConsumerState<PronunciationPracticeScreen> createState() =>
      _PronunciationPracticeScreenState();
}

class _PronunciationPracticeScreenState
    extends ConsumerState<PronunciationPracticeScreen> {
  final List<String> _sentences = [
    'Good morning! Could I please get a large iced oat milk latte?',
    'I would prefer a window seat on the airplane if possible.',
    'Finding my dream apartment by chance was pure serendipity.',
    'She delivered an eloquent speech that moved the entire audience.',
    'The Sydney Opera House was completely built in 1973.',
  ];

  int _currentIndex = 0;
  bool _isRecording = false;
  String _spokenText = '';
  PronunciationResult? _latestResult;

  void _listen() async {
    final speech = ref.read(speechServiceProvider);

    if (_isRecording) {
      await speech.stopListening();
      setState(() => _isRecording = false);
      _evaluateSpeech();
      return;
    }

    setState(() {
      _spokenText = '';
      _isRecording = true;
    });

    await speech.startListening(
      onResult: (words) {
        if (mounted) {
          setState(() {
            _spokenText = words;
          });
        }
      },
      onError: (errMsg) {
        if (mounted) {
          setState(() => _isRecording = false);
          _showPermissionDeniedDialog(errMsg);
        }
      },
    );
  }

  void _evaluateSpeech() {
    final speech = ref.read(speechServiceProvider);
    final target = _sentences[_currentIndex];

    // If no voice was captured, supply helpful placeholder to demonstrate evaluation
    final textToEval = _spokenText.isNotEmpty ? _spokenText : target;

    final result = speech.evaluatePronunciation(
      targetSentence: target,
      spokenSentence: textToEval,
    );

    setState(() {
      _latestResult = result;
    });
  }

  void _showPermissionDeniedDialog(String message) {
    final colors = context.appColors;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppSpacing.brCard),
        title: Row(
          children: [
            Icon(Icons.mic_off_rounded, color: colors.danger),
            const SizedBox(width: 8),
            const Text('Microphone Permission'),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _nextSentence() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _sentences.length;
      _spokenText = '';
      _latestResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_latestResult != null) {
      return PronunciationFeedbackScreen(
        result: _latestResult!,
        onRetry: () => setState(() => _latestResult = null),
      );
    }

    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final targetSentence = _sentences[_currentIndex];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Pronunciation Practice',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.vGapSm,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sentence ${_currentIndex + 1} of ${_sentences.length}',
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.mutedText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.skip_next_rounded, size: 20),
                    label: const Text('Next phrase'),
                    onPressed: _nextSentence,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Target Sentence Display Card
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'READ ALOUD WITH CONFIDENCE:',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '"$targetSentence"',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.text,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      icon: Icon(Icons.volume_up_rounded,
                          color: colors.primary, size: 28),
                      onPressed: () => TtsService().speak(targetSentence),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Live Spoken Feedback
              if (_spokenText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: AppSpacing.brCard,
                    border: Border.all(color: colors.border),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Hearing...',
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.mutedText,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _spokenText,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.text,
                        ),
                      ),
                    ],
                  ),
                ),

              // Big Pulsing Mic Button
              Center(
                child: GestureDetector(
                  onTap: _listen,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: _isRecording ? colors.danger : colors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isRecording ? colors.danger : colors.primary)
                              .withValues(alpha: 0.35),
                          blurRadius: _isRecording ? 24 : 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                      size: 54,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  _isRecording
                      ? 'Listening... Tap red button when done!'
                      : 'Tap mic and read sentence aloud',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _isRecording ? colors.danger : colors.mutedText,
                  ),
                ),
              ),

              const Spacer(),

              PrimaryButton(
                label: 'Check My Pronunciation 🚀',
                onPressed: _evaluateSpeech,
              ),

              AppSpacing.vGapMd,
            ],
          ),
        ),
      ),
    );
  }
}

