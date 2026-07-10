class DrinkEntry {
  final int amount;
  final DateTime time;

  DrinkEntry({
    required this.amount,
    required this.time,
  });

  String toStorageString() {
    return '$amount|${time.toIso8601String()}';
  }

  factory DrinkEntry.fromStorageString(
      String value,
      ) {
    final parts = value.split('|');

    return DrinkEntry(
      amount: int.parse(parts[0]),
      time: DateTime.parse(parts[1]),
    );
  }
}