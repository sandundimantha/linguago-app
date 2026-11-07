import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/models/home_data.dart';

/// Daily Goal Card with circular progress ring and time-remaining indicators.
class DailyGoalCard extends StatelessWidget {
  final DailyGoal goal;

  const DailyGoalCard({
    super.key,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      padding: AppSpacing.pMd,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Circular Progress Ring (80px x 80px)
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 68,
                  height: 68,
                  child: CircularProgressIndicator(
                    value: goal.progressPercentage / 100.0,
                    strokeWidth: 7.0,
                    strokeCap: StrokeCap.round,
                    backgroundColor: colors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(colors.success),
                  ),
                ),
                Text(
                  '${goal.progressPercentage}%',
                  style: textTheme.headlineSmall?.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.hGapMd,

          // Goal Meta Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tag & Current/Target Mins
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'DAILY GOAL',
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.success,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${goal.completedMinutes} / ${goal.targetMinutes} mins',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.mutedText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 3.0),

                // Remaining Minutes Headline
                Text(
                  goal.remainingMinutesMessage,
                  style: textTheme.headlineSmall?.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2.0),

                // Streak Alive Subtitle
                Text(
                  goal.encouragementMessage,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.mutedText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

