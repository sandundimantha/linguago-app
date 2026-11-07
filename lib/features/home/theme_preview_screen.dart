import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/core_widgets.dart';

/// Preview screen showcasing the LinguaGo Design System & Reusable Widgets
/// in both Light and Dark modes.
class ThemePreviewScreen extends ConsumerStatefulWidget {
  const ThemePreviewScreen({super.key});

  @override
  ConsumerState<ThemePreviewScreen> createState() => _ThemePreviewScreenState();
}

class _ThemePreviewScreenState extends ConsumerState<ThemePreviewScreen> {
  // Interactive state for ChoiceCard demo
  int _selectedChoice = 1;
  double _demoProgress = 0.6;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Design System Preview',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Row(
            children: [
              Icon(
                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                color: colors.primary,
                size: 20,
              ),
              AppSpacing.hGapXs,
              Switch.adaptive(
                value: isDark,
                activeThumbColor: colors.primary,
                onChanged: (val) {
                  ref.read(themeModeProvider.notifier).state =
                      val ? ThemeMode.dark : ThemeMode.light;
                },
              ),
              AppSpacing.hGapSm,
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding.copyWith(
            top: AppSpacing.md,
            bottom: AppSpacing.xxl,
          ),
          children: [
            // Mode Banner
            AppCard(
              backgroundColor: colors.primaryTint,
              borderColor: colors.primary.withValues(alpha: 0.3),
              padding: AppSpacing.pMd,
              child: Row(
                children: [
                  Icon(
                    isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                    color: colors.primary,
                    size: 28,
                  ),
                  AppSpacing.hGapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDark ? 'Dark Theme Active' : 'Light Theme Active',
                          style: textTheme.headlineSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        AppSpacing.vGapXs,
                        Text(
                          'Derived faithfully from the #4F46E5 Indigo palette.',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            AppSpacing.vGapXl,

            // Top Status Bar Widgets (Streak, Hearts, XP)
            const SectionHeader(title: 'Gamification Chips & Counters'),
            AppSpacing.vGapMd,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const StreakPill(count: '18 Days'),
                const StreakPill(count: '7'),
                const HeartsCounter(count: 5, showMax: true),
                const HeartsCounter(count: 3),
                const XpBadge(xp: '+30 XP'),
                const XpBadge(xp: '1,450 XP'),
              ],
            ),

            AppSpacing.vGapXl,

            // Progress Bar Section
            SectionHeader(
              title: 'App Progress Bar (8px)',
              actionText: 'Next (+20%)',
              onActionTap: () {
                setState(() {
                  _demoProgress = (_demoProgress + 0.2) > 1.05 ? 0.2 : _demoProgress + 0.2;
                });
              },
            ),
            AppSpacing.vGapSm,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lesson 4 Progress',
                  style: textTheme.bodyMedium,
                ),
                Text(
                  '${(_demoProgress * 100).round()}%',
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.success,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            AppSpacing.vGapSm,
            AppProgressBar(value: _demoProgress),

            AppSpacing.vGapXl,

            // Buttons Section
            const SectionHeader(title: 'Tactile Push Buttons (56px)'),
            AppSpacing.vGapMd,
            PrimaryButton(
              label: 'Continue Lesson',
              icon: const Icon(Icons.arrow_forward_rounded),
              onPressed: () {},
            ),
            AppSpacing.vGapMd,
            PrimaryButton(
              label: 'Success Completed Button',
              icon: const Icon(Icons.check_rounded),
              backgroundColor: colors.success,
              bottomEdgeColor: colors.successDarker,
              onPressed: () {},
            ),
            AppSpacing.vGapMd,
            SecondaryButton(
              label: 'Secondary / View Details',
              icon: const Icon(Icons.menu_book_rounded),
              onPressed: () {},
            ),
            AppSpacing.vGapMd,
            const PrimaryButton(
              label: 'Disabled Tactile Button',
              onPressed: null,
            ),

            AppSpacing.vGapXl,

            // Cards & Surface Depth
            const SectionHeader(
              title: 'AppCard (20px radius, 1px border)',
              actionText: 'View All',
            ),
            AppSpacing.vGapMd,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daily Goal Widget',
                        style: textTheme.headlineSmall?.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const XpBadge(xp: '+15 XP'),
                    ],
                  ),
                  AppSpacing.vGapSm,
                  Text(
                    'Practice polite requests & conversational fluency at a café.',
                    style: textTheme.bodyMedium,
                  ),
                  AppSpacing.vGapMd,
                  Row(
                    children: [
                      const StreakPill(count: 'Active'),
                      AppSpacing.hGapSm,
                      Text(
                        '8 / 10 mins completed',
                        style: textTheme.labelSmall?.copyWith(
                          color: colors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppSpacing.vGapXl,

            // Choice Cards (All 4 States)
            const SectionHeader(title: 'ChoiceCard States (Interactive)'),
            AppSpacing.vGapSm,
            Text(
              'Tap each card to test interactive states (Normal, Selected, Correct, Wrong):',
              style: textTheme.bodyMedium,
            ),
            AppSpacing.vGapMd,
            ChoiceCard(
              optionIndex: 'A',
              text: 'Normal State: "Could I have a black coffee, please?"',
              state: _selectedChoice == 0 ? ChoiceCardState.selected : ChoiceCardState.normal,
              onTap: () => setState(() => _selectedChoice = 0),
            ),
            AppSpacing.vGapMd,
            ChoiceCard(
              optionIndex: 'B',
              text: 'Selected State (Indigo border & soft tint)',
              state: _selectedChoice == 1 ? ChoiceCardState.selected : ChoiceCardState.normal,
              onTap: () => setState(() => _selectedChoice = 1),
            ),
            AppSpacing.vGapMd,
            ChoiceCard(
              optionIndex: 'C',
              text: 'Correct State (Emerald border & green tint)',
              state: _selectedChoice == 2 ? ChoiceCardState.selected : ChoiceCardState.correct,
              onTap: () => setState(() => _selectedChoice = 2),
            ),
            AppSpacing.vGapMd,
            ChoiceCard(
              optionIndex: 'D',
              text: 'Wrong State (Crimson border & red tint)',
              state: _selectedChoice == 3 ? ChoiceCardState.selected : ChoiceCardState.wrong,
              onTap: () => setState(() => _selectedChoice = 3),
            ),

            AppSpacing.vGapXl,

            // Typography Specimen
            const SectionHeader(title: 'Nunito Sans Type Scale'),
            AppSpacing.vGapMd,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Headline Large (24px / 800)', style: textTheme.headlineLarge),
                  AppSpacing.vGapSm,
                  Text('Headline Medium (20px / 700)', style: textTheme.headlineMedium),
                  AppSpacing.vGapSm,
                  Text('Headline Small (18px / 700)', style: textTheme.headlineSmall),
                  AppSpacing.vGapSm,
                  Text('Body Large (16px / 500) - Scanning & reading', style: textTheme.bodyLarge),
                  AppSpacing.vGapSm,
                  Text('Body Medium (14px / 500) - Auxiliary text & prompts', style: textTheme.bodyMedium),
                  AppSpacing.vGapSm,
                  Text('LABEL LARGE (16px / 800) - ACTION BUTTONS', style: textTheme.labelLarge),
                  AppSpacing.vGapSm,
                  Text('Label Medium (13px / 700) - Tags & Chips', style: textTheme.labelMedium),
                  AppSpacing.vGapSm,
                  Text('LABEL SMALL (11px / 700) - BADGES & PILLS', style: textTheme.labelSmall),
                ],
              ),
            ),

            AppSpacing.vGapXl,

            // Palette Swatches
            const SectionHeader(title: 'Theme Color Swatches'),
            AppSpacing.vGapMd,
            AppCard(
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _ColorSwatch(name: 'Primary', color: colors.primary, textColor: Colors.white),
                  _ColorSwatch(name: 'Bottom Edge', color: colors.primaryDarker, textColor: Colors.white),
                  _ColorSwatch(name: 'Success', color: colors.success, textColor: Colors.white),
                  _ColorSwatch(name: 'Danger', color: colors.danger, textColor: Colors.white),
                  _ColorSwatch(name: 'Accent', color: colors.accent, textColor: Colors.white),
                  _ColorSwatch(name: 'Background', color: colors.background, textColor: colors.text, hasBorder: true),
                  _ColorSwatch(name: 'Card', color: colors.card, textColor: colors.text, hasBorder: true),
                  _ColorSwatch(name: 'Text', color: colors.text, textColor: colors.card),
                  _ColorSwatch(name: 'Border', color: colors.border, textColor: colors.text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final String name;
  final Color color;
  final Color textColor;
  final bool hasBorder;

  const _ColorSwatch({
    required this.name,
    required this.color,
    required this.textColor,
    this.hasBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = context.appColors.border;
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppSpacing.brMd,
        border: hasBorder ? Border.all(color: border) : null,
      ),
      child: Column(
        children: [
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '#${(color.toARGB32() & 0x00FFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}',
            style: TextStyle(
              color: textColor.withValues(alpha: 0.8),
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
