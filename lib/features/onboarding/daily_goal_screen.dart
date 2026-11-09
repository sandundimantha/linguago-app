import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/choice_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';

/// Screen where the user selects their daily learning goal (in minutes).
class DailyGoalScreen extends ConsumerStatefulWidget {
  const DailyGoalScreen({super.key});

  @override
  ConsumerState<DailyGoalScreen> createState() => _DailyGoalScreenState();
}

class _DailyGoalScreenState extends ConsumerState<DailyGoalScreen> {
  int _selectedMinutes = 10; // default

  static const _options = [
    (5, '☕', 'Casual', '5 minutes a day'),
    (10, '📚', 'Regular', '10 minutes a day'),
    (15, '💪', 'Serious', '15 minutes a day'),
    (20, '🔥', 'Intense', '20 minutes a day'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Set your daily\nlearning goal',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You can change this later in settings.',
                style: textTheme.bodyMedium?.copyWith(color: colors.mutedText),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: ListView.separated(
                  itemCount: _options.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final (mins, emoji, title, subtitle) = _options[i];
                    final isSelected = _selectedMinutes == mins;
                    return ChoiceCard(
                      text: title,
                      subtitle: subtitle,
                      state: isSelected
                          ? ChoiceCardState.selected
                          : ChoiceCardState.normal,
                      onTap: () => setState(() => _selectedMinutes = mins),
                      leading:
                          Text(emoji, style: const TextStyle(fontSize: 28)),
                    );
                  },
                ),
              ),

              PrimaryButton(
                label: 'Start Learning! 🎉',
                onPressed: () async {
                  final notifier =
                      ref.read(userPreferencesProvider.notifier);
                  await notifier.setDailyGoal(_selectedMinutes);
                  await notifier.completeOnboarding();
                  if (context.mounted) context.go('/onboarding/sign-up');
                },
              ),
              const SizedBox(height: AppSpacing.screenMargin),
            ],
          ),
        ),
      ),
    );
  }
}

