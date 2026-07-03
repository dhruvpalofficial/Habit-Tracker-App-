// lib/providers/habit_provider.dart

import 'package:flutter/material.dart';
import 'package:habit_tracker/model/habit.dart';


class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [
    Habit(
      id: '1',
      name: 'water',
      emoji: '🪣',
      type: HabitType.counter,
      currentValue: 0,
      targetValue: 10,
      streakDays: 0,
    ),
  ];

  List<Habit> get habits => List.unmodifiable(_habits);

  List<Habit> get completedHabits =>
      _habits.where((h) => h.isCompleted).toList();

  Habit get waterHabit => _habits.firstWhere((h) => h.type == HabitType.counter);

  void addHabit({
    required String name,
    required String emoji,
    int targetValue = 10,
  }) {
    final newHabit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      emoji: emoji,
      type: HabitType.counter,
      currentValue: 0,
      targetValue: targetValue,
      streakDays: 0,
    );
    _habits.add(newHabit);
    notifyListeners();
  }

  // Edit an existing habit's name, emoji, and/or target.
  // currentValue, streakDays, and history are left untouched.
  void editHabit({
    required String id,
    required String name,
    required String emoji,
    required int targetValue,
  }) {
    final habit = _habits.firstWhere((h) => h.id == id);
    habit.name = name;
    habit.emoji = emoji;
    habit.targetValue = targetValue;
    notifyListeners();
  }

  // Remove a habit entirely.
  void deleteHabit(String id) {
    _habits.removeWhere((h) => h.id == id);
    notifyListeners();
  }

  void incrementHabit(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    if (habit.currentValue < habit.targetValue) {
      habit.currentValue++;
      if (habit.currentValue == habit.targetValue) {
        habit.streakDays++;
      }
      notifyListeners();
    }
  }

  void decrementHabit(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    if (habit.currentValue > 0) {
      habit.currentValue--;
      notifyListeners();
    }
  }

  void markCompleted(String id) {
    final habit = _habits.firstWhere((h) => h.id == id);
    habit.isCompleted = true;
    notifyListeners();
  }

  void toggleHistoryDay(String id, int day) {
    final habit = _habits.firstWhere((h) => h.id == id);
    habit.history[day] = !(habit.history[day] ?? false);
    notifyListeners();
  }
}