import 'package:flutter/material.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _dailyReminderEnabled = true;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0); // 8:00 PM
  bool _streakFreezeAlerts = true;
  bool _friendActivityAlerts = false;

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _saveSettings() async {
    await NotificationService().scheduleDailyReminder(
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      enabled: _dailyReminderEnabled,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification settings updated & scheduled! 🔔'),
        ),
      );
    }
  }

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
          'Notifications',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: colors.text,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.vGapMd,

              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      title: Text(
                        'Daily Study Reminder',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.text,
                        ),
                      ),
                      subtitle: Text(
                        'Alert you to keep your active streak going',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.mutedText,
                        ),
                      ),
                      value: _dailyReminderEnabled,
                      activeTrackColor: colors.primary,
                      activeThumbColor: Colors.white,
                      onChanged: (val) =>
                          setState(() => _dailyReminderEnabled = val),
                    ),
                    if (_dailyReminderEnabled) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.access_time_rounded,
                            color: colors.primary),
                        title: Text(
                          'Reminder Time',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colors.primaryTint,
                            borderRadius: AppSpacing.brFull,
                          ),
                          child: Text(
                            _selectedTime.format(context),
                            style: textTheme.labelMedium?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        onTap: _pickTime,
                      ),
                    ],
                  ],
                ),
              ),

              AppSpacing.vGapLg,

              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      title: Text(
                        'Streak Freeze Warnings',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.text,
                        ),
                      ),
                      subtitle: Text(
                        'Notify 2 hours before midnight if you have not practiced',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.mutedText,
                        ),
                      ),
                      value: _streakFreezeAlerts,
                      activeTrackColor: colors.primary,
                      activeThumbColor: Colors.white,
                      onChanged: (val) =>
                          setState(() => _streakFreezeAlerts = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      title: Text(
                        'Friends Activity Updates',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colors.text,
                        ),
                      ),
                      subtitle: Text(
                        'When your friends complete units or overtake you',
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.mutedText,
                        ),
                      ),
                      value: _friendActivityAlerts,
                      activeTrackColor: colors.primary,
                      activeThumbColor: Colors.white,
                      onChanged: (val) =>
                          setState(() => _friendActivityAlerts = val),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              PrimaryButton(
                label: 'Save Preferences 🔔',
                onPressed: _saveSettings,
              ),

              AppSpacing.vGapMd,
            ],
          ),
        ),
      ),
    );
  }
}

