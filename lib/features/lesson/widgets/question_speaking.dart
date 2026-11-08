import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/lesson_models.dart';

class SpeakingQuestionView extends StatefulWidget {
  final LessonQuestion question;
  final bool isRecorded;
  final ValueChanged<bool> onRecorded;

  const SpeakingQuestionView({
    super.key,
    required this.question,
    required this.isRecorded,
    required this.onRecorded,
  });

  @override
  State<SpeakingQuestionView> createState() => _SpeakingQuestionViewState();
}

class _SpeakingQuestionViewState extends State<SpeakingQuestionView> {
  bool _isListening = false;

  void _toggleMic() {
    if (_isListening) return;

    setState(() => _isListening = true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        setState(() => _isListening = false);
        widget.onRecorded(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.question.prompt,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 36),

        // Target sentence card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: AppSpacing.brCard,
            border: Border.all(color: colors.border, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                widget.question.targetText ?? '',
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                  height: 1.3,
                ),
              ),
              if (widget.question.phoneticHint != null) ...[
                const SizedBox(height: 12),
                Text(
                  widget.question.phoneticHint!,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),

        const Spacer(),

        // Mic Button & State
        Center(
          child: GestureDetector(
            onTap: _toggleMic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: _isListening
                    ? colors.danger
                    : (widget.isRecorded ? colors.success : colors.primary),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? colors.danger : colors.primary)
                        .withValues(alpha: 0.35),
                    blurRadius: _isListening ? 24 : 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                _isListening
                    ? Icons.mic_rounded
                    : (widget.isRecorded
                        ? Icons.check_rounded
                        : Icons.mic_none_rounded),
                size: 56,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            _isListening
                ? 'Listening to your speech...'
                : (widget.isRecorded
                    ? 'Voice captured! Tap Check below.'
                    : 'Tap microphone and read aloud'),
            style: textTheme.bodyMedium?.copyWith(
              color: _isListening ? colors.danger : colors.mutedText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}

