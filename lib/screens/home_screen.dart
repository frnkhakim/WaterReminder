import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterreminder/models/drink_entry.dart';
import 'package:waterreminder/services/notification_service.dart';
import 'package:waterreminder/services/preferences_service.dart';
import 'package:waterreminder/services/reminder_service.dart';
import 'package:waterreminder/screens/reminder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentWater = 0;
  int dailyGoal = 2000;
  List<DrinkEntry> drinkHistory = [];

  bool remindersEnabled = false;
  int reminderType = 2;

  final PreferencesService _prefs = PreferencesService();
  final NotificationService _notifications = NotificationService();
  final ReminderService _reminderService = ReminderService();

  @override
  void initState() {
    super.initState();
    _loadWater();
    _loadDailyGoal();
    loadHistory();
    loadReminderSettings().then((_) async {
      if (remindersEnabled) {
        await _reminderService.startReminders(
          enabled: remindersEnabled,
          reminderType: reminderType,
        );
      }
    });
  }

  void addWater(int amount) {
    setState(() {
      currentWater += amount;
      drinkHistory.add(DrinkEntry(amount: amount, time: DateTime.now()));
      if (currentWater > dailyGoal) currentWater = dailyGoal;
    });
    _saveWater();
    saveHistory();
    _reminderService.updateReminders(
      currentWater: currentWater,
      dailyGoal: dailyGoal,
      enabled: remindersEnabled,
      reminderType: reminderType,
    );
  }

  String getMotivation() {
    final progress = dailyGoal > 0 ? currentWater / dailyGoal : 0.0;
    if (progress >= 1) return "🎉 Goal achieved!";
    if (progress >= 0.75) return "🔥 Almost there!";
    if (progress >= 0.5) return "💧 Keep drinking!";
    return "Start hydrating today!";
  }

  Future<void> _saveWater() async => _prefs.setCurrentMl(currentWater);

  Future<void> _loadWater() async {
    final saved = await _prefs.getCurrentMl();
    setState(() => currentWater = saved ?? currentWater);
  }

  Future<void> _saveDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dailyGoal', dailyGoal);
  }

  Future<void> _loadDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => dailyGoal = prefs.getInt('dailyGoal') ?? 2000);
  }

  void _showGoalPicker() {
    int tempGoal = dailyGoal;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Set Daily Goal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$tempGoal ml',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 12),
              Slider(
                value: tempGoal.toDouble(),
                min: 500,
                max: 5000,
                divisions: 90, // steps of 50ml
                label: '$tempGoal ml',
                onChanged: (value) {
                  setDialogState(() => tempGoal = value.round());
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('500 ml',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Text('5000 ml',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => dailyGoal = tempGoal);
                _saveDailyGoal();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'drinkHistory',
      drinkHistory.map((d) => d.toStorageString()).toList(),
    );
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final strings = prefs.getStringList('drinkHistory') ?? [];
    setState(() {
      drinkHistory = strings.map(DrinkEntry.fromStorageString).toList();
    });
  }

  Future<void> loadReminderSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      remindersEnabled = prefs.getBool('remindersEnabled') ?? false;
      reminderType = prefs.getInt('reminderType') ?? 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        (dailyGoal > 0) ? (currentWater / dailyGoal).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Reminders',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReminderScreen()),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF64B5F6), Color(0xFFE3F2FD)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // Progress card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 28, horizontal: 24),
                    child: Column(
                      children: [
                        const Icon(Icons.water_drop,
                            size: 64, color: Colors.blue),
                        const SizedBox(height: 12),
                        Text(
                          "$currentWater ml",
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: _showGoalPicker,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "of $dailyGoal ml",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[600]),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.edit, size: 14, color: Colors.grey[400]),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            minHeight: 16,
                            value: progress,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getMotivation(),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${(progress * 100).toInt()}%",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Drink buttons
                Row(
                  children: [
                    _drinkButton("+250 ml", () => addWater(250)),
                    const SizedBox(width: 12),
                    _drinkButton("+500 ml", () => addWater(500)),
                    const SizedBox(width: 12),
                    _drinkButton("+750 ml", () => addWater(750)),
                  ],
                ),

                const SizedBox(height: 16),

                // Reset + Test row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            currentWater = 0;
                            drinkHistory.clear();
                          });
                          _saveWater();
                          saveHistory();
                        },
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const Text("Reset"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          foregroundColor: Colors.grey[800],
                          side: BorderSide(color: Colors.grey[400]!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _notifications.showNotification(),
                        icon: const Icon(Icons.notifications, size: 18),
                        label: const Text("Test"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          foregroundColor: Colors.teal,
                          side: const BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // History header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today's Log",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${drinkHistory.length} entries",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // History list
                Expanded(
                  child: drinkHistory.isEmpty
                      ? Center(
                          child: Text(
                            "No drinks logged yet",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          itemCount: drinkHistory.length,
                          itemBuilder: (context, index) {
                            final drink = drinkHistory[
                                drinkHistory.length - 1 - index];
                            return Card(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.local_drink,
                                    color: Colors.blue),
                                title: Text("${drink.amount} ml"),
                                trailing: Text(
                                  "${drink.time.hour}:"
                                  "${drink.time.minute.toString().padLeft(2, '0')}",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drinkButton(String label, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
