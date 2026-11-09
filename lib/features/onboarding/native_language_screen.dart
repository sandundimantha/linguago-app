import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/choice_card.dart';
import '../../core/widgets/primary_button.dart';
import '../../app/providers.dart';

/// Screen where the user picks their native language.
class NativeLanguageScreen extends ConsumerStatefulWidget {
  const NativeLanguageScreen({super.key});

  @override
  ConsumerState<NativeLanguageScreen> createState() =>
      _NativeLanguageScreenState();
}

class _NativeLanguageScreenState extends ConsumerState<NativeLanguageScreen> {
  String? _selected;

  static const _languages = [
    ('🇱🇰', 'Sinhala'),
    ('🇱🇰', 'Tamil'),
    ('🇮🇳', 'Hindi'),
    ('🇨🇳', 'Mandarin'),
    ('🇪🇸', 'Spanish'),
    ('🇸🇦', 'Arabic'),
    ('🇫🇷', 'French'),
    ('🇧🇷', 'Portuguese'),
    ('🇧🇩', 'Bengali'),
    ('🇯🇵', 'Japanese'),
    ('🇰🇷', 'Korean'),
    ('🇩🇪', 'German'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenMargin, 8,
                AppSpacing.screenMargin, 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What is your native\nlanguage?',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.text,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We'll personalise your lessons accordingly.",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.mutedText,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenMargin,
                  vertical: 4,
                ),
                itemCount: _languages.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final (flag, name) = _languages[i];
                  final isSelected = _selected == name;
                  return ChoiceCard(
                    text: name,
                    state: isSelected
                        ? ChoiceCardState.selected
                        : ChoiceCardState.normal,
                    onTap: () => setState(() => _selected = name),
                    leading: Text(flag, style: const TextStyle(fontSize: 24)),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenMargin),
              child: PrimaryButton(
                label: 'Continue',
                onPressed: _selected == null
                    ? null
                    : () async {
                        await ref
                            .read(userPreferencesProvider.notifier)
                            .setNativeLanguage(_selected!);
                        if (context.mounted) context.go('/onboarding/goal');
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
