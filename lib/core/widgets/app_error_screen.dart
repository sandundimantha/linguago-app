import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'primary_button.dart';

/// Screen displayed when an unexpected error or exception occurs.
class AppErrorScreen extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final VoidCallback? onGoHome;

  const AppErrorScreen({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.onGoHome,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'Something went wrong alert',
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: colors.danger.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 52,
                        color: colors.danger,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    title ?? 'Something Went Wrong',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message ??
                        'We ran into an unexpected issue while loading this page. Please try again.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.mutedText,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 36),
                  if (onRetry != null) ...[
                    Semantics(
                      button: true,
                      label: 'Retry action',
                      child: PrimaryButton(
                        label: 'Try Again',
                        onPressed: onRetry,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (onGoHome != null)
                    Semantics(
                      button: true,
                      label: 'Go back to home',
                      child: OutlinedButton(
                        onPressed: onGoHome,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          side: BorderSide(color: colors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppSpacing.brButton,
                          ),
                        ),
                        child: Text(
                          'Back to Home',
                          style: TextStyle(
                            color: colors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

