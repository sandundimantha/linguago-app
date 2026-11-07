import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/core_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            StreakPill(count: '7'),
            AppSpacing.hGapSm,
            XpBadge(xp: '420 XP'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Design System Preview',
            onPressed: () => context.push('/preview'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            onPressed: () => context.go('/profile'),
          ),
          AppSpacing.hGapSm,
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding.copyWith(
            top: AppSpacing.sm,
            bottom: AppSpacing.xl,
          ),
          children: [
            // Greeting & Motivation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Good morning, Alex!',
                          style: textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        AppSpacing.hGapXs,
                        const Text('👋', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                    AppSpacing.vGapXs,
                    Text(
                      'Keep your momentum going today.',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colors.primaryTint,
                  child: Icon(
                    Icons.school_rounded,
                    color: colors.primary,
                    size: 26,
                  ),
                ),
              ],
            ),

            AppSpacing.vGapLg,

            // Stats Strip
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: AppSpacing.pSm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const StreakPill(count: '18 Days'),
                        AppSpacing.vGapXs,
                        Text(
                          'STREAK',
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppSpacing.hGapSm,
                Expanded(
                  child: AppCard(
                    padding: AppSpacing.pSm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const XpBadge(xp: '1,450 XP'),
                        AppSpacing.vGapXs,
                        Text(
                          'TOTAL XP',
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AppSpacing.hGapSm,
                Expanded(
                  child: AppCard(
                    padding: AppSpacing.pSm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeartsCounter(count: 5),
                        AppSpacing.vGapXs,
                        Text(
                          'HEARTS',
                          style: textTheme.labelSmall?.copyWith(
                            color: colors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            AppSpacing.vGapXl,

            // Hero Continue Lesson Card
            AppCard(
              backgroundColor: colors.primary,
              borderColor: colors.primaryDarker,
              padding: AppSpacing.pLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: AppSpacing.brFull,
                        ),
                        child: Text(
                          'UNIT 3 • CONVERSATIONAL FLUENCY',
                          style: textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const XpBadge(
                        xp: '+30 XP',
                        backgroundColor: Color(0xFFFFDDB8),
                        textColor: Color(0xFF684000),
                        iconColor: Color(0xFF684000),
                      ),
                    ],
                  ),
                  AppSpacing.vGapMd,
                  Text(
                    'Lesson 4: Ordering at a Café',
                    style: textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  AppSpacing.vGapXs,
                  Text(
                    'Polite requests & ordering etiquette',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  AppSpacing.vGapMd,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      Text(
                        'Step 3 of 5',
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGapXs,
                  const AppProgressBar(
                    value: 0.6,
                    trackColor: Color(0x33FFFFFF),
                    fillColor: Color(0xFF6BFF8F),
                  ),
                  AppSpacing.vGapLg,
                  PrimaryButton(
                    label: 'Continue Lesson',
                    icon: const Icon(Icons.arrow_forward_rounded),
                    backgroundColor: Colors.white,
                    bottomEdgeColor: const Color(0xFFE2E8F0),
                    textColor: colors.primary,
                    onPressed: () => context.push('/lesson/4'),
                  ),
                ],
              ),
            ),

            AppSpacing.vGapXl,

            // Quick Shortcut to Theme Preview
            AppCard(
              onTap: () => context.push('/preview'),
              child: Row(
                children: [
                  Icon(Icons.palette_rounded, color: colors.primary, size: 28),
                  AppSpacing.hGapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Design System Preview',
                          style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        AppSpacing.vGapXs,
                        Text(
                          'Test light & dark themes, tactile push buttons, and choice states.',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded, color: colors.mutedText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
