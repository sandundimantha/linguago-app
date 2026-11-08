import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
          'About LinguaGo',
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
            children: [
              AppSpacing.vGapLg,

              // App Logo / Mascot
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: colors.primaryTint,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.primary, width: 2),
                ),
                child: const Center(
                  child: Text('🦉', style: TextStyle(fontSize: 54)),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'LinguaGo',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colors.text,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Version 1.0.0 (Build 101)',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.mutedText,
                  fontWeight: FontWeight.w600,
                ),
              ),

              AppSpacing.vGapXl,

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OUR MISSION',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'LinguaGo empowers language learners worldwide with joyful, gamified daily mastery. By combining cognitive spaced repetition with real-time speech feedback and contextual dialogues, we make English fluency accessible, structured, and fun.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.text,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapMd,

              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Terms of Service',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(
                        'Privacy Policy',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      title: Text(
                        'Open Source Licenses',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => showLicensePage(
                        context: context,
                        applicationName: 'LinguaGo',
                        applicationVersion: '1.0.0',
                        applicationLegalese: '© 2026 LinguaGo Team. All rights reserved.',
                      ),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapLg,

              Text(
                'Crafted with passion for learners everywhere ❤️',
                style: textTheme.bodySmall?.copyWith(
                  color: colors.mutedText,
                ),
              ),

              AppSpacing.vGapMd,
            ],
          ),
        ),
      ),
    );
  }
}

