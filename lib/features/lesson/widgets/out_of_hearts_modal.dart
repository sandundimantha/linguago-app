import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';

/// Modal dialog presented when user runs out of hearts during a lesson.
class OutOfHeartsModal extends StatelessWidget {
  final VoidCallback onRefill;
  final VoidCallback onQuit;

  const OutOfHeartsModal({
    super.key,
    required this.onRefill,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.brCard),
      backgroundColor: colors.card,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colors.dangerTint,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('💔', style: TextStyle(fontSize: 40)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Out of Energy!',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You made several mistakes and ran out of hearts. Take a breath or refill your energy to keep learning.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.mutedText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Refill Hearts & Retry ❤️',
              backgroundColor: colors.danger,
              bottomEdgeColor: colors.dangerDarker,
              onPressed: onRefill,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onQuit,
              child: Text(
                'End Lesson',
                style: textTheme.labelLarge?.copyWith(
                  color: colors.mutedText,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

