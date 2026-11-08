import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../app/providers.dart';
import '../../app/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDarkMode = currentThemeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.card,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Settings',
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

            // Preferences Section
            Text(
              'APP PREFERENCES',
              style: textTheme.labelSmall?.copyWith(
                color: colors.mutedText,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    secondary: Icon(
                      isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      color: colors.primary,
                    ),
                    title: Text(
                      'Dark Theme',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                      ),
                    ),
                    subtitle: Text(
                      isDarkMode ? 'Dark slate palette' : 'Light clean palette',
                      style: textTheme.bodySmall?.copyWith(color: colors.mutedText),
                    ),
                    value: isDarkMode,
                    activeTrackColor: colors.primary,
                    activeThumbColor: Colors.white,
                    onChanged: (enabled) {
                      ref.read(themeModeProvider.notifier).state =
                          enabled ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Icon(Icons.notifications_active_outlined,
                        color: colors.primary),
                    title: Text(
                      'Notifications & Reminders',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/settings/notifications'),
                  ),
                ],
              ),
            ),

            AppSpacing.vGapLg,

            // Support & About Section
            Text(
              'SUPPORT & ABOUT',
              style: textTheme.labelSmall?.copyWith(
                color: colors.mutedText,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    leading:
                        Icon(Icons.help_outline_rounded, color: colors.primary),
                    title: Text(
                      'Help & Frequently Asked Questions',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/help-faq'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading:
                        Icon(Icons.info_outline_rounded, color: colors.primary),
                    title: Text(
                      'About LinguaGo',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.text,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push('/about'),
                  ),
                ],
              ),
            ),

            AppSpacing.vGapLg,

            // Log out
            TextButton.icon(
              icon: Icon(Icons.logout_rounded, color: colors.danger),
              label: Text(
                'Log Out',
                style: TextStyle(
                  color: colors.danger,
                  fontWeight: FontWeight.w800,
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: AppSpacing.brCard),
                    title: const Text('Log Out'),
                    content: const Text(
                        'Are you sure you want to log out of LinguaGo?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          context.go('/auth/login');
                        },
                        child: Text('Log Out',
                            style: TextStyle(color: colors.danger)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

