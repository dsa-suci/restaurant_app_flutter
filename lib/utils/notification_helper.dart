import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationHelper {
  static final _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iOSInit,
    );

    await _notifications.initialize(initSettings);
  }

  Future<void> showDailyAt11AM() async {
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    final now = tz.TZDateTime.now(tz.local);
    final scheduleTime =
        tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          11,
          0,
        ).isBefore(now)
        ? tz.TZDateTime(tz.local, now.year, now.month, now.day + 1, 11, 0)
        : tz.TZDateTime(tz.local, now.year, now.month, now.day, 11, 0);

    await _notifications.zonedSchedule(
      0,
      'Waktunya Makan Siang!',
      'Ayo cari restoran favoritmu sekarang',
      scheduleTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
