import 'package:flutter/material.dart';
import 'package:waterreminder/models/drink_entry.dart';
import 'package:waterreminder/services/preferences_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentWater = 800;
  final int dailyGoal = 2000;
  List<DrinkEntry> drinkHistory = [];

  final PreferencesService _prefs = PreferencesService();

  @override
  void initState() {
    super.initState();
    _loadWater();
  }

  Future<void> _saveWater() async {
    await _prefs.setCurrentMl(currentWater);
  }

  Future<void> _loadWater() async {
    final saved = await _prefs.getCurrentMl();
    setState(() {
      currentWater = saved ?? currentWater;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = (dailyGoal > 0) ? (currentWater / dailyGoal) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.water_drop,
                          color: Colors.blue,
                          size: 30,
                        ),

                        const SizedBox(width: 10),

                        const Expanded(
                          child: Text(
                            "Today's Progress",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.local_drink,
                          color: Colors.green,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 12,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "$currentWater ml / $dailyGoal ml",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentWater += 250;
                    drinkHistory.add(
                      DrinkEntry(
                        amount: 250,
                        time: DateTime.now(),
                      ),
                    );

                    if (currentWater > dailyGoal) {
                      currentWater = dailyGoal;
                    }
                  });
                  _saveWater();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),

                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.water_drop),
                    SizedBox(width: 8),
                    Text("Drink 250 ml"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentWater += 500;
                    drinkHistory.add(
                      DrinkEntry(
                        amount: 500,
                        time: DateTime.now(),
                      ),
                    );

                    if (currentWater > dailyGoal) {
                      currentWater = dailyGoal;
                    }
                  });
                  _saveWater();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),

                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.water_drop),
                    SizedBox(width: 8),
                    Text("Drink 500 ml"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentWater += 750;
                    drinkHistory.add(
                      DrinkEntry(
                        amount: 750,
                        time: DateTime.now(),
                      ),
                    );

                    if (currentWater > dailyGoal) {
                      currentWater = dailyGoal;
                    }
                  });
                  _saveWater();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),

                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.water_drop),
                    SizedBox(width: 8),
                    Text("Drink 750 ml"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    currentWater = 0;
                    drinkHistory.clear();
                  });
                  _saveWater();
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),

                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text("Reset"),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: drinkHistory.length,
                itemBuilder: (context, index) {
                  final drink = drinkHistory[drinkHistory.length - 1 - index];

                  return ListTile(
                    leading: const Icon(Icons.local_drink),
                    title: Text("${drink.amount} ml"),
                    subtitle: Text(
                      "${drink.time.hour}:"
                          "${drink.time.minute.toString().padLeft(2, '0')}",
                    ),
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }

}
