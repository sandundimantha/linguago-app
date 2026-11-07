import 'package:flutter/material.dart';

/// Baseline spacing, grid, and dimensional tokens for LinguaGo.
/// Governed strictly by the 8pt spatial baseline and 20px mobile margins.
class AppSpacing {
  AppSpacing._();

  // Screen layout margins
  static const double screenMargin = 20.0;
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: screenMargin);

  // 8pt Spatial Grid
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  // Convenient EdgeInsets
  static const EdgeInsets pXs = EdgeInsets.all(xs);
  static const EdgeInsets pSm = EdgeInsets.all(sm);
  static const EdgeInsets pMd = EdgeInsets.all(md);
  static const EdgeInsets pLg = EdgeInsets.all(lg);
  static const EdgeInsets pXl = EdgeInsets.all(xl);

  // Vertical Gaps
  static const SizedBox vGapXs = SizedBox(height: xs);
  static const SizedBox vGapSm = SizedBox(height: sm);
  static const SizedBox vGapMd = SizedBox(height: md);
  static const SizedBox vGapLg = SizedBox(height: lg);
  static const SizedBox vGapXl = SizedBox(height: xl);
  static const SizedBox vGapXxl = SizedBox(height: xxl);

  // Horizontal Gaps
  static const SizedBox hGapXs = SizedBox(width: xs);
  static const SizedBox hGapSm = SizedBox(width: sm);
  static const SizedBox hGapMd = SizedBox(width: md);
  static const SizedBox hGapLg = SizedBox(width: lg);
  static const SizedBox hGapXl = SizedBox(width: xl);
  static const SizedBox hGapXxl = SizedBox(width: xxl);

  // Component Heights & Touch Targets
  static const double buttonHeight = 56.0;
  static const double minTouchTarget = 48.0;
  static const double progressBarHeight = 8.0;
  static const double navBarHeight = 64.0;

  // Radii
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusButton = 16.0;
  static const double radiusCard = 20.0;
  static const double radiusFull = 9999.0;

  // BorderRadius objects
  static final BorderRadius brXs = BorderRadius.circular(radiusXs);
  static final BorderRadius brSm = BorderRadius.circular(radiusSm);
  static final BorderRadius brMd = BorderRadius.circular(radiusMd);
  static final BorderRadius brButton = BorderRadius.circular(radiusButton);
  static final BorderRadius brCard = BorderRadius.circular(radiusCard);
  static final BorderRadius brFull = BorderRadius.circular(radiusFull);
}

