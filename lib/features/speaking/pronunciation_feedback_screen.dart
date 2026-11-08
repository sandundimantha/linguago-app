import 'package:flutter/material.dart';
import '../../core/services/speech_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/tts_service.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';

class PronunciationFeedbackScreen extends StatelessWidget {
  final PronunciationResult result;
  final VoidCallback onRetry;

  const PronunciationFeedbackScreen({
    super.key,
    required this.result,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final scoreInt = result.overallScore.round();
    final Color scoreColor;
    final String scoreBadge;

    if (scoreInt >= 85) {
      scoreColor = colors.success;
      scoreBadge = 'Excellent! 🌟';
    } else if (scoreInt >= 65) {
      scoreColor = colors.accent;
      scoreBadge = 'Good job! 👍';
    } else {
      scoreColor = colors.danger;
      scoreBadge = 'Needs Practice 🎯';
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Pronunciation Feedback',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.vGapMd,

              // Overall Score Hero Card
              AppCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: result.overallScore / 100.0,
                            strokeWidth: 10,
                            backgroundColor: colors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$scoreInt%',
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: colors.text,
                              ),
                            ),
                            Text(
                              'ACCURACY',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.mutedText,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      scoreBadge,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scoreColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      result.feedbackTip,
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapLg,

              // Word-by-Word Color Breakdown
              Text(
                'Word-by-Word Analysis',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _Legend(color: colors.success, label: 'Perfect'),
                  const SizedBox(width: 14),
                  _Legend(color: colors.accent, label: 'Almost'),
                  const SizedBox(width: 14),
                  _Legend(color: colors.danger, label: 'Needs Focus'),
                ],
              ),

              AppSpacing.vGapMd,

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: AppSpacing.brCard,
                  border: Border.all(color: colors.border),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: result.wordScores.map((ws) {
                    final Color wordBg;
                    final Color wordText;

                    switch (ws.status) {
                      case WordScoreStatus.correct:
                        wordBg = colors.successTint;
                        wordText = colors.success;
                        break;
                      case WordScoreStatus.almost:
                        wordBg = colors.accentTint;
                        wordText = colors.accentDarker;
                        break;
                      case WordScoreStatus.incorrect:
                        wordBg = colors.dangerTint;
                        wordText = colors.danger;
                        break;
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: wordBg,
                        borderRadius: AppSpacing.brButton,
                        border: Border.all(color: wordText.withValues(alpha: 0.4)),
                      ),
                      child: Text(
                        ws.targetWord,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: wordText,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              AppSpacing.vGapMd,

              // What Was Heard
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WHAT WE HEARD:',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.mutedText,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      result.recognizedSentence.isNotEmpty
                          ? '"${result.recognizedSentence}"'
                          : '(No speech detected)',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.text,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapLg,

              // Try Again Button
              PrimaryButton(
                label: 'Try Again 🎙️',
                onPressed: onRetry,
              ),

              AppSpacing.vGapSm,

              // Listen to Native Model
              OutlinedButton.icon(
                icon: Icon(Icons.volume_up_rounded, color: colors.primary),
                label: Text(
                  'Listen to Native Model',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: colors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.brButton,
                  ),
                ),
                onPressed: () => TtsService().speak(result.targetSentence),
              ),

              AppSpacing.vGapMd,
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;

  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}

