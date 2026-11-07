import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Standard interactive card surface with 20px radius, 1px border, and soft ambient shadow.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = borderRadius ?? AppSpacing.brCard;

    final defaultShadow = [
      BoxShadow(
        color: colors.shadow,
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];

    final cardWidget = Container(
      padding: padding ?? AppSpacing.pMd,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.card,
        borderRadius: radius,
        border: Border.all(
          color: borderColor ?? colors.border,
          width: borderWidth,
        ),
        boxShadow: boxShadow ?? defaultShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          splashColor: colors.primary.withValues(alpha: 0.08),
          highlightColor: colors.primary.withValues(alpha: 0.04),
          child: cardWidget,
        ),
      );
    }

    return cardWidget;
  }
}

