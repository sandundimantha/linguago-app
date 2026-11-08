import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';

/// Feedback Bottom Sheet displayed immediately after an answer is verified.
/// Shows a joyful green drawer on success, or a distinct red banner on error.
class FeedbackBottomSheet extends StatelessWidget {
  final bool isCorrect;
  final String message;
  final VoidCallback onContinue;

  const FeedbackBottomSheet({
    super.key,
    required this.isCorrect,
    required this.message,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final bgColor = isCorrect ? colors.successTint : colors.dangerTint;
    final borderColor = isCorrect ? colors.success : colors.danger;
    final iconColor = isCorrect ? colors.success : colors.danger;
    final title = isCorrect ? 'Nicely done! 🎉' : 'Correct solution:';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenMargin,
        18,
        AppSpacing.screenMargin,
        AppSpacing.screenMargin,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: iconColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: iconColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Text(
                message,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.text,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Continue',
              backgroundColor: isCorrect ? colors.success : colors.danger,
              bottomEdgeColor: isCorrect ? colors.successDarker : colors.dangerDarker,
              onPressed: onContinue,
            ),
          ],
        ),
      ),
    );
  }
}

