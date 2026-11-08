import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'primary_button.dart';

/// Screen displayed when internet connectivity is unavailable or network requests fail.
class NoInternetScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? message;

  const NoInternetScreen({
    super.key,
    this.onRetry,
    this.message,
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
                    label: 'No internet connection icon',
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size: 52,
                        color: colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'No Connection',
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colors.text,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    message ??
                        'Please check your internet connection or Wi-Fi settings and try again.',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.mutedText,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 36),
                  if (onRetry != null)
                    Semantics(
                      button: true,
                      label: 'Try connecting again',
                      child: PrimaryButton(
                        label: 'Try Again',
                        onPressed: onRetry,
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

