// lib/models/habit.dart — only the changed lines shown

class Habit {
  final String id; // id stays final — it's the permanent identifier
  String name; // was: final String name
  String emoji; // was: final String emoji
  final HabitType type;

  int currentValue;
  int targetValue; // was: final int targetValue
  int streakDays;

  final String? subtitle;
  bool isCompleted;

  Map<int, bool> history;

  Habit({
    required this.id,
    required this.name,
    required this.emoji,
    required this.type,
    this.currentValue = 0,
    this.targetValue = 0,
    this.streakDays = 0,
    this.subtitle,
    this.isCompleted = false,
    Map<int, bool>? history,
  }) : history = history ?? {};
}

enum HabitType {
  counter,
  streak,
  duration,
}