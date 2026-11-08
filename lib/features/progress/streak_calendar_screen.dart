import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../app/providers.dart';

class StreakCalendarScreen extends ConsumerWidget {
  const StreakCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final repo = ref.watch(lessonRepositoryProvider);
    final streak = repo.getStreak();
    final streakDates = repo.getStreakDates().toSet();

    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstWeekday = DateTime(now.year, now.month, 1).weekday; // 1 = Mon

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Streak Calendar',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.vGapMd,

              // Streak Flame Banner
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFEA580C), // Orange flame
                  borderRadius: AppSpacing.brCard,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEA580C).withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 54)),
                    const SizedBox(height: 8),
                    Text(
                      '$streak Day Streak!',
                      style: textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You are on fire! Practice daily to protect your flame.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapLg,

              // Monthly Grid Card
              AppCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_monthName(now.month)} ${now.year}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: colors.text,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.primaryTint,
                            borderRadius: AppSpacing.brFull,
                          ),
                          child: Text(
                            'Active Month',
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Day of week headers
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((d) {
                        return SizedBox(
                          width: 36,
                          child: Text(
                            d,
                            textAlign: TextAlign.center,
                            style: textTheme.labelSmall?.copyWith(
                              color: colors.mutedText,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),

                    // Calendar Days Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: (firstWeekday - 1) + daysInMonth,
                      itemBuilder: (context, index) {
                        if (index < firstWeekday - 1) {
                          return const SizedBox.shrink(); // empty leading cell
                        }

                        final dayNum = index - (firstWeekday - 1) + 1;
                        final dateStr =
                            '${now.year}-${now.month.toString().padLeft(2, '0')}-${dayNum.toString().padLeft(2, '0')}';
                        final isPracticed = streakDates.contains(dateStr);
                        final isToday = dayNum == now.day;

                        return Container(
                          decoration: BoxDecoration(
                            color: isPracticed
                                ? const Color(0xFFEA580C)
                                : (isToday ? colors.primaryTint : colors.card),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isToday
                                  ? colors.primary
                                  : (isPracticed
                                      ? const Color(0xFFEA580C)
                                      : colors.border),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$dayNum',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isPracticed
                                    ? Colors.white
                                    : (isToday ? colors.primary : colors.text),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapLg,

              // Streak Freeze Advice Card
              AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.cyan.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🧊', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Streak Freeze Active',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colors.text,
                            ),
                          ),
                          Text(
                            'You have 1 safety freeze ready if you miss a day.',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapMd,
            ],
          ),
        ),
      ),
    );
  }

  static String _monthName(int m) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[m - 1];
  }
}

