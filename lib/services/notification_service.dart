import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings
    androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings
    initializationSettings =
    InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails
    androidDetails =
    AndroidNotificationDetails(
      'water_channel',
      'Water Reminder',
      channelDescription:
      'Water reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails
    notificationDetails =
    NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin
        .show(
      0,
      '💧 Water Reminder',
      'Time to drink some water!',
      notificationDetails,
    );
  }

}



