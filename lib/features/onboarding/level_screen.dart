import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/choice_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/secondary_button.dart';
import '../../app/providers.dart';

/// Screen where the user self-rates their English level, or opts for a placement test.
class LevelScreen extends ConsumerStatefulWidget {
  const LevelScreen({super.key});

  @override
  ConsumerState<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends ConsumerState<LevelScreen> {
  String? _selected;

  static const _levels = [
    ('🌱', 'Beginner', 'I know very little or no English yet.'),
    ('📖', 'Elementary', 'I can handle simple everyday phrases.'),
    ('🗣️', 'Intermediate', 'I can hold most everyday conversations.'),
    ('🚀', 'Advanced', 'I can discuss complex topics fluently.'),
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
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'How would you rate\nyour English?',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: colors.text,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Be honest — it helps us match your lessons.",
                style: textTheme.bodyMedium?.copyWith(color: colors.mutedText),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.separated(
                  itemCount: _levels.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final (emoji, title, description) = _levels[i];
                    final isSelected = _selected == title;
                    return ChoiceCard(
                      text: title,
                      subtitle: description,
                      state: isSelected
                          ? ChoiceCardState.selected
                          : ChoiceCardState.normal,
                      onTap: () => setState(() => _selected = title),
                      leading: Text(emoji, style: const TextStyle(fontSize: 28)),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Continue',
                onPressed: _selected == null
                    ? null
                    : () async {
                        await ref
                            .read(userPreferencesProvider.notifier)
                            .setEnglishLevel(_selected!);
                        if (context.mounted) {
                          context.go('/onboarding/daily-goal');
                        }
                      },
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                label: 'Take a placement test instead',
                onPressed: () => context.go('/onboarding/placement'),
              ),
              const SizedBox(height: AppSpacing.screenMargin),
            ],
          ),
        ),
      ),
    );
  }
}
