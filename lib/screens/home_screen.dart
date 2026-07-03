// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:habit_tracker/model/habit.dart';
import 'package:habit_tracker/provider/habit_provider.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

import '../widgets/habit_card.dart';
import '../widgets/add_habit_dialog.dart';
import 'habit_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();
    final habits = habitProvider.habits;

    // Split habits: small cards vs the large water-style card.
    // For now "water" is the only large card by name — see note below.
    final largeHabits = habits.where((h) => h.name == 'water').toList();
    final smallHabits = habits.where((h) => h.name != 'water').toList();
    final completedHabits = habitProvider.completedHabits;

    void openDetail(Habit habit) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: habit)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: avatar + greeting + add button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'morning, Martin Kenter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const AddHabitDialog(),
                      );
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.black,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: AppColors.divider, thickness: 1),
              const SizedBox(height: 20),

              Text(
                'track',
                style: TextStyle(fontSize: 13, color: AppColors.textGrey),
              ),
              const SizedBox(height: 4),
              Text(
                'your habits',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 20),

              // Row of small habit cards — only shows once user adds habits
              // beyond water, since new users start with water only.
              if (smallHabits.isNotEmpty)
                Row(
                  children: smallHabits.map((habit) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SizedBox(
                          height: 140,
                          child: HabitCard(
                            habit: habit,
                            onTap: () => openDetail(habit),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              if (smallHabits.isNotEmpty) const SizedBox(height: 16),

              // Large card(s) — water by default, tappable like every other card.
              ...largeHabits.map(
                (habit) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: HabitCard(
                      habit: habit,
                      onTap: () => openDetail(habit),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // "habits completed" section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'habits completed',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: AppColors.textDark,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (completedHabits.isEmpty)
                Text(
                  'nothing completed yet',
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                ),
              ...completedHabits.map(
                (habit) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.divider),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.black,
                          child: Text(
                            habit.emoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${habit.name} — ${habit.currentValue}/${habit.targetValue}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
