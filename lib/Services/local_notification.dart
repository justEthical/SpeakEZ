import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
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

    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    _initialized = true;
  }

  // ---------- PERMISSION ----------
Future<bool> requestNotificationPermission() async {
  final status = await Permission.notification.request();
  return status.isGranted;
}

  // ---------- SCHEDULE DAILY ----------
  Future<void> scheduleDailyReminder({
    required String time, // "HH:mm"
    int notificationId = 0,
  }) async {
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

    await _plugin.zonedSchedule(
      notificationId,
      'Time to practice English 🎤',
      'Just 5 minutes of speaking today',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'practice_channel',
          'Practice Reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode:
          AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:
          DateTimeComponents.time,
    );
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

}
