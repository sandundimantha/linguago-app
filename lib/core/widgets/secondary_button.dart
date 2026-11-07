import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Secondary / Outline Button (56px high, 16px radius, 2px border).
class SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? borderColor;
  final Color? textColor;
  final Color? backgroundColor;
  final bool isFullWidth;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.borderColor,
    this.textColor,
    this.backgroundColor,
    this.isFullWidth = true,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final isEnabled = widget.onPressed != null;
    final effectiveBorder = widget.borderColor ?? colors.border;
    final effectiveText = isEnabled ? (widget.textColor ?? colors.primary) : colors.mutedText;
    final effectiveBg = widget.backgroundColor ?? colors.card;

    final Widget buttonContent = AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 60),
      child: Container(
        height: AppSpacing.buttonHeight,
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: AppSpacing.brButton,
          border: Border.all(
            color: effectiveBorder,
            width: 2.0,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                IconTheme(
                  data: IconThemeData(color: effectiveText, size: 20),
                  child: widget.icon!,
                ),
                AppSpacing.hGapSm,
              ],
              Text(
                widget.label,
                style: textTheme.labelLarge?.copyWith(
                  color: effectiveText,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      behavior: HitTestBehavior.opaque,
      child: widget.isFullWidth ? SizedBox(width: double.infinity, child: buttonContent) : buttonContent,
    );
  }
}

