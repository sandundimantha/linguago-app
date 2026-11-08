import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';

class FaqItem {
  final String question;
  final String answer;

  const FaqItem({required this.question, required this.answer});
}

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  static const List<FaqItem> _faqs = [
    FaqItem(
      question: 'How do streaks work in LinguaGo?',
      answer:
          'Your streak counts consecutive days where you complete at least one lesson or review session. Completing exercises before midnight preserves and increments your streak counter.',
    ),
    FaqItem(
      question: 'What is the Spaced Repetition (Leitner) system?',
      answer:
          'LinguaGo schedules vocabulary reviews into 4 memory boxes. Words you remember advance through 1-day, 3-day, 7-day, and 14-day intervals to lock them into permanent long-term recall. If you struggle with a word, it returns to Box 1 for review tomorrow.',
    ),
    FaqItem(
      question: 'How does pronunciation evaluation work?',
      answer:
          'Our AI tutor compares your spoken audio against native phonetics. Words highlighted in green were pronounced accurately, amber denotes minor phonetic shifts, and red highlights syllables needing extra articulation practice.',
    ),
    FaqItem(
      question: 'What happens when I run out of hearts?',
      answer:
          'Hearts represent your session energy. Each mistake deducts 1 heart. If all 5 hearts are lost, you can refill them instantly or review previous lessons to practice calmly.',
    ),
    FaqItem(
      question: 'Can I change my target English level or goal?',
      answer:
          'Yes! Visit your Profile tab, tap "Edit Profile Information", and update your target level (Beginner to Advanced) or primary learning goal anytime.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Help & FAQ',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            AppSpacing.vGapMd,
            Text(
              'Frequently Asked Questions',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 12),
            ..._faqs.map((faq) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  padding: EdgeInsets.zero,
                  child: ExpansionTile(
                    title: Text(
                      faq.question,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colors.text,
                      ),
                    ),
                    iconColor: colors.primary,
                    collapsedIconColor: colors.mutedText,
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      Text(
                        faq.answer,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.mutedText,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            AppSpacing.vGapMd,
          ],
        ),
      ),
    );
  }
}

