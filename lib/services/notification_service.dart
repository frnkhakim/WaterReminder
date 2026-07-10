import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings =
    InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin
        .initialize(settings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification() async {
    const androidDetails =
    AndroidNotificationDetails(
      'water_channel',
      'Water Reminder',
      channelDescription:
      'Water reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details =
    NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      '💧 Water Reminder',
      'Time to drink some water!',
      details,
    );
  }

  Future<void> scheduleNotification() async {
    const androidDetails =
    AndroidNotificationDetails(
      'water_channel',
      'Water Reminder',
      channelDescription:
      'Water reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details =
    NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin
        .zonedSchedule(
      1,
      '💧 Water Reminder',
      'Time to drink some water!',
      tz.TZDateTime.now(
        tz.local,
      ).add(
        const Duration(seconds: 10),
      ),
      details,
      androidScheduleMode:
      AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin
        .cancelAll();
  }
}