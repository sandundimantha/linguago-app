import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      const androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      );

      await _notifications.initialize(settings: initSettings);
      _isInitialized = true;
    } catch (_) {
      _isInitialized = false;
    }
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required bool enabled,
  }) async {
    await init();
    try {
      await _notifications.cancel(1001); // Cancel existing reminder

      if (!enabled) return;

      const androidDetails = AndroidNotificationDetails(
        'daily_study_reminders',
        'Daily Study Reminders',
        channelDescription: 'Friendly reminders to maintain your English streak',
        importance: Importance.high,
        priority: Priority.high,
      );
      const noticeDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      // Instant demonstration trigger / sample reminder
      await _notifications.show(
        id: 1001,
        title: 'Time for English! 🦉',
        body: 'Keep your streak burning! Complete a 5-minute practice session today.',
        notificationDetails: noticeDetails,
      );
    } catch (_) {}
  }
}

