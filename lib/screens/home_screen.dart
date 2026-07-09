import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentWater = 800;
  final int dailyGoal = 2000;

  @override
  Widget build(BuildContext context) {
    final progress = currentWater / dailyGoal;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Water Reminder"),
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

                        const Text(
                          "Today's Progress",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    LinearProgressIndicator(
                      value: progress,
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

            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentWater += 250;

                  if (currentWater > dailyGoal) {
                    currentWater = dailyGoal;
                  }
                });
              },
              child: const Text("Drink 250 ml"),
            ),

            const SizedBox(height: 15),

            OutlinedButton(
              onPressed: () {
                setState(() {
                  currentWater = 0;
                });
              },
              child: const Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }
}