import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../app/providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    final repo = ref.watch(lessonRepositoryProvider);
    final userPrefs = ref.watch(userPreferencesProvider);
    final streak = repo.getStreak();
    final totalXp = repo.getTotalXp();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        title: Text(
          'My Profile',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.vGapMd,

              // User Info Card
              AppCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: colors.primaryTint,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.primary, width: 2),
                      ),
                      child: const Center(
                        child: Text('👨‍💻', style: TextStyle(fontSize: 38)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sandun Dimantha',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colors.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Goal: ${userPrefs.learningGoal ?? "Everyday Conversation"}',
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.mutedText,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.primaryTint,
                              borderRadius: AppSpacing.brFull,
                            ),
                            child: Text(
                              userPrefs.englishLevel ?? 'Intermediate (B2)',
                              style: textTheme.labelSmall?.copyWith(
                                color: colors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_rounded, color: colors.primary),
                      onPressed: () => context.push('/profile/edit'),
                    ),
                  ],
                ),
              ),

              AppSpacing.vGapLg,

              // Overall Statistics Grid
              Row(
                children: [
                  Expanded(
                    child: _ProfileStatCard(
                      icon: '🔥',
                      value: '$streak',
                      label: 'Day Streak',
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ProfileStatCard(
                      icon: '⚡',
                      value: '$totalXp',
                      label: 'Total XP',
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ProfileStatCard(
                      icon: '🏆',
                      value: '#4',
                      label: 'League Rank',
                      colors: colors,
                      textTheme: textTheme,
                    ),
                  ),
                ],
              ),

              AppSpacing.vGapLg,

              // Menu Actions
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _MenuTile(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profile Information',
                      onTap: () => context.push('/profile/edit'),
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.military_tech_outlined,
                      title: 'Achievements & Badges',
                      onTap: () => context.push('/progress/badges'),
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Notification Settings',
                      onTap: () => context.push('/settings/notifications'),
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Help & FAQ',
                      onTap: () => context.push('/help-faq'),
                    ),
                    const Divider(height: 1),
                    _MenuTile(
                      icon: Icons.info_outline_rounded,
                      title: 'About LinguaGo',
                      onTap: () => context.push('/about'),
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
}

class _ProfileStatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final AppCustomColors colors;
  final TextTheme textTheme;

  const _ProfileStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            value,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: colors.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colors.mutedText,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
