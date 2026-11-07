import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/home_data.dart';
import 'widgets/continue_lesson_card.dart';
import 'widgets/daily_goal_card.dart';
import 'widgets/home_greeting_section.dart';
import 'widgets/home_stats_strip.dart';
import 'widgets/home_top_bar.dart';
import 'widgets/mascot_cheer_banner.dart';
import 'widgets/quick_practice_grid.dart';
import 'widgets/word_of_the_day_card.dart';

/// Complete Home Dashboard Screen matching design/home_dashboard/screen.png.
class HomeScreen extends StatelessWidget {
  final HomeData? customData;

  const HomeScreen({
    super.key,
    this.customData,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final data = customData ?? HomeData.mock();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: HomeTopBar(stats: data.stats),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding.copyWith(
            top: AppSpacing.sm,
            bottom: AppSpacing.xxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Greeting with Student Avatar
              HomeGreetingSection(user: data.user),

              AppSpacing.vGapLg,

              // 2. 3-Column Gamification Stats Strip (Streak, Total XP, Hearts)
              HomeStatsStrip(stats: data.stats),

              AppSpacing.vGapLg,

              // 3. Daily Goal Circular Progress Card
              DailyGoalCard(goal: data.goal),

              AppSpacing.vGapLg,

              // 4. Dark Indigo Continue Lesson Hero Card
              ContinueLessonCard(lesson: data.lesson),

              AppSpacing.vGapLg,

              // 5. Quick Practice 2x2 Interactive Grid
              QuickPracticeGrid(items: data.quickPracticeItems),

              AppSpacing.vGapLg,

              // 6. Word of the Day Card with Audio & CTA
              WordOfTheDayCard(wordOfTheDay: data.wordOfTheDay),

              AppSpacing.vGapLg,

              // 7. Lingo Owl Mascot League Cheer Banner
              MascotCheerBanner(mascotCheer: data.mascotCheer),

              AppSpacing.vGapMd,
            ],
          ),
        ),
      ),
    );
  }
}
