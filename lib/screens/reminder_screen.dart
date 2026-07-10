import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterreminder/services/reminder_service.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  bool remindersEnabled = false;
  int reminderType = 2;

  final ReminderService _reminderService = ReminderService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      remindersEnabled = prefs.getBool('remindersEnabled') ?? false;
      reminderType = prefs.getInt('reminderType') ?? 2;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remindersEnabled', remindersEnabled);
    await prefs.setInt('reminderType', reminderType);
    await _reminderService.startReminders(
      enabled: remindersEnabled,
      reminderType: reminderType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enable toggle card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: SwitchListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: const Text(
                  'Enable Reminders',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Get notified to drink water'),
                value: remindersEnabled,
                onChanged: (value) {
                  setState(() => remindersEnabled = value);
                  _saveSettings();
                },
              ),
            ),

            const SizedBox(height: 16),

            // Interval card
            AnimatedOpacity(
              opacity: remindersEnabled ? 1.0 : 0.4,
              duration: const Duration(milliseconds: 300),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 12, bottom: 8),
                        child: Text(
                          'Reminder Interval',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      _intervalOption(1, 'Every 1 Hour'),
                      _intervalOption(2, 'Every 2 Hours'),
                      _intervalOption(3, 'Every 3 Hours'),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _intervalOption(int value, String label) {
    return RadioListTile<int>(
      value: value,
      groupValue: reminderType,
      title: Text(label),
      contentPadding: EdgeInsets.zero,
      onChanged: remindersEnabled
          ? (v) {
              if (v == null) return;
              setState(() => reminderType = v);
              _saveSettings();
            }
          : null,
    );
  }
}
