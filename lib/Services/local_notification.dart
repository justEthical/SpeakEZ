import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService._internal();
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  factory LocalNotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  // ---------- INIT ----------
  Future<void> init() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    _initialized = true;
  }

  // ---------- PERMISSION ----------
  Future<bool> requestNotificationPermission() async {
    await init();

    if (Platform.isIOS) {
      // For iOS, request permission through the plugin
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      debugPrint('iOS notification permission granted: $granted');
      return granted ?? false;
    } else {
      // For Android, request notification permission
      final notifStatus = await Permission.notification.request();
      debugPrint('Android notification permission: ${notifStatus.isGranted}');

      // For Android 12+, also request exact alarm permission
      final exactAlarmStatus = await Permission.scheduleExactAlarm.request();
      debugPrint('Android exact alarm permission: ${exactAlarmStatus.isGranted}');

      return notifStatus.isGranted;
    }
  }

  // ---------- SCHEDULE DAILY ----------
  Future<bool> scheduleDailyReminder({
    required String time, // "HH:mm"
    int notificationId = 0,
  }) async {
    try {
      await init();

      await _plugin.cancel(notificationId);

      final now = tz.TZDateTime.now(tz.local);
      final parts = time.split(':');

      var scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );

      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      debugPrint('Scheduling notification for: $scheduled (time: $time)');
      debugPrint('Current time: $now');
      debugPrint('Timezone: ${tz.local}');

      await _plugin.zonedSchedule(
        notificationId,
        'Time to practice English 🎤',
        'Just ${globalController.userProfile.value.dailyStudyDuration} of speaking today',
        scheduled,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'practice_channel',
            'Practice Reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('Daily reminder scheduled successfully for $time');
      return true;
    } catch (e, stackTrace) {
      debugPrint('Error scheduling notification: $e');
      debugPrint('Stack trace: $stackTrace');
      return false;
    }
  }

  // ---------- CANCEL ----------
  Future<void> cancelReminder({int notificationId = 0}) async {
    await _plugin.cancel(notificationId);
  }

  // ---------- UTILS ----------

  Future<bool> hasNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Test method to verify notifications work
  Future<void> showTestNotification() async {
    await init();
    debugPrint('Showing test notification...');
    await _plugin.show(
      999,
      'Test Notification',
      'If you see this, notifications are working!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'practice_channel',
          'Practice Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
    debugPrint('Test notification sent');
  }

  // Test scheduled notification (1 minute from now)
  Future<void> testScheduledNotification() async {
    await init();
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = now.add(const Duration(minutes: 1));

    debugPrint('Current time: $now');
    debugPrint('Scheduling test for: $scheduledTime');

    await _plugin.zonedSchedule(
      998,
      'Scheduled Test',
      'This was scheduled 1 minute ago!',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'practice_channel',
          'Practice Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    debugPrint('Test notification scheduled for 1 minute from now');
  }

}
