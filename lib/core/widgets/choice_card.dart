import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum ChoiceCardState {
  normal,
  selected,
  correct,
  wrong,
}

/// Multiple choice exercise card with 20px radius and tactile feedback.
/// Supports normal, selected, correct, and wrong validation states.
class ChoiceCard extends StatelessWidget {
  final String text;
  final ChoiceCardState state;
  final VoidCallback? onTap;
  final String? optionIndex; // e.g., "A", "B", "1", "2"
  final Widget? trailing;
  final Widget? leading;   // optional leading widget (emoji, icon, etc.)
  final String? subtitle;  // optional secondary label beneath [text]

  const ChoiceCard({
    super.key,
    required this.text,
    this.state = ChoiceCardState.normal,
    this.onTap,
    this.optionIndex,
    this.trailing,
    this.leading,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    // Resolve border color & background color dynamically based on theme and state
    final Color borderColor;
    final Color backgroundColor;
    final Color textColor;
    final Color indexBgColor;
    final Color indexTextColor;

    switch (state) {
      case ChoiceCardState.normal:
        borderColor = colors.border;
        backgroundColor = colors.card;
        textColor = colors.text;
        indexBgColor = colors.background;
        indexTextColor = colors.mutedText;
        break;

      case ChoiceCardState.selected:
        borderColor = colors.primary;
        backgroundColor = colors.primaryTint;
        textColor = colors.primary;
        indexBgColor = colors.primary;
        indexTextColor = Colors.white;
        break;

      case ChoiceCardState.correct:
        borderColor = colors.success;
        backgroundColor = colors.successTint;
        textColor = colors.success;
        indexBgColor = colors.success;
        indexTextColor = Colors.white;
        break;

      case ChoiceCardState.wrong:
        borderColor = colors.danger;
        backgroundColor = colors.dangerTint;
        textColor = colors.danger;
        indexBgColor = colors.danger;
        indexTextColor = Colors.white;
        break;
    }

    Widget? stateIcon;
    if (state == ChoiceCardState.correct) {
      stateIcon = Icon(Icons.check_circle_rounded, color: colors.success, size: 24);
    } else if (state == ChoiceCardState.wrong) {
      stateIcon = Icon(Icons.cancel_rounded, color: colors.danger, size: 24);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppSpacing.brCard,
        border: Border.all(
          color: borderColor,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppSpacing.brCard,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.brCard,
          splashColor: borderColor.withValues(alpha: 0.12),
          highlightColor: borderColor.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14.0),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  AppSpacing.hGapMd,
                ],
                if (optionIndex != null) ...[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: indexBgColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      optionIndex!,
                      style: textTheme.labelMedium?.copyWith(
                        color: indexTextColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  AppSpacing.hGapMd,
                ],
                Expanded(
                  child: subtitle != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: textTheme.bodyLarge?.copyWith(
                                color: textColor,
                                fontWeight: state == ChoiceCardState.selected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle!,
                              style: textTheme.bodySmall?.copyWith(
                                color: textColor.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          text,
                          style: textTheme.bodyLarge?.copyWith(
                            color: textColor,
                            fontWeight: state == ChoiceCardState.selected
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                        ),
                ),
                if (stateIcon != null) ...[
                  AppSpacing.hGapSm,
                  stateIcon,
                ] else if (trailing != null) ...[
                  AppSpacing.hGapSm,
                  trailing!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

