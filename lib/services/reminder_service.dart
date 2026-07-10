import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notification_service.dart';

class ReminderService {
  final NotificationService notificationService = NotificationService();

  Future<void> startReminders({
    required bool enabled,
    required int reminderType,
  }) async {
    if (!enabled) {
      await notificationService.cancelAll();
      return;
    }

    final interval = reminderType == 1
        ? RepeatInterval.hourly
        : RepeatInterval.everyMinute; // everyMinute for dev; swap to daily for production

    await notificationService.startRepeatingReminder(interval: interval);
  }

  Future<void> stopReminders() async {
    await notificationService.cancelAll();
  }

  Future<void> updateReminders({
    required int currentWater,
    required int dailyGoal,
    required bool enabled,
    required int reminderType,
  }) async {
    if (!enabled) return;

    if (currentWater >= dailyGoal) {
      await stopReminders();
      return;
    }

    await startReminders(enabled: enabled, reminderType: reminderType);
  }
}
