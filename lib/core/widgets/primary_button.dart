import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Micro-tactile 3D push button inspired by modern gamified apps.
/// Features a 4px darker bottom extrusion edge that compresses downward 2-3px when tapped.
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? bottomEdgeColor;
  final Color? textColor;
  final bool isFullWidth;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.bottomEdgeColor,
    this.textColor,
    this.isFullWidth = true,
    this.isLoading = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (widget.onPressed == null || widget.isLoading) return;
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (widget.onPressed == null || widget.isLoading) return;
    setState(() => _isPressed = false);
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    if (widget.onPressed == null || widget.isLoading) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final isEnabled = widget.onPressed != null && !widget.isLoading;
    final baseColor = widget.backgroundColor ?? colors.primary;
    final bottomColor = widget.bottomEdgeColor ?? colors.primaryDarker;
    final contentColor = widget.textColor ?? Colors.white;

    // Disabled appearance
    final effectiveBase = isEnabled ? baseColor : colors.border;
    final effectiveBottom = isEnabled ? bottomColor : colors.border.withValues(alpha: 0.6);
    final effectiveText = isEnabled ? contentColor : colors.mutedText;

    const double buttonHeight = AppSpacing.buttonHeight; // 56.0
    const double extrusionHeight = 4.0;
    const double pressOffset = 3.0; // Moves down 3px when pressed
    final double faceHeight = buttonHeight - extrusionHeight; // 52.0

    final Widget buttonContent = SizedBox(
      height: buttonHeight,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          // 4px Darker Bottom Base Extrusion
          Positioned(
            top: extrusionHeight,
            left: 0,
            right: 0,
            height: faceHeight,
            child: Container(
              decoration: BoxDecoration(
                color: effectiveBottom,
                borderRadius: AppSpacing.brButton,
              ),
            ),
          ),

          // Tactile Top Face (Translates down when pressed)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 60),
            curve: Curves.easeOut,
            top: _isPressed ? pressOffset : 0,
            left: 0,
            right: 0,
            height: faceHeight,
            child: Container(
              decoration: BoxDecoration(
                color: effectiveBase,
                borderRadius: AppSpacing.brButton,
                boxShadow: isEnabled && !_isPressed
                    ? [
                        BoxShadow(
                          color: effectiveBottom.withValues(alpha: 0.25),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(effectiveText),
                        ),
                      )
                    : Row(
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
          ),
        ],
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

