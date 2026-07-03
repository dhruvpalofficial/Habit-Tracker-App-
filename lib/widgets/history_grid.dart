// lib/widgets/history_grid.dart

import 'package:flutter/material.dart';
import 'package:habit_tracker/model/habit.dart';
import 'package:habit_tracker/provider/habit_provider.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

class HistoryGrid extends StatelessWidget {
  final Habit habit;

  const HistoryGrid({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().day; // used to highlight "today" like day 30 in the design

    return GridView.builder(
      itemCount: 30, // days 1–30
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final day = index + 1;
        final isCompleted = habit.history[day] ?? false;
        final isToday = day == today;

        return GestureDetector(
          onTap: () {
            context.read<HabitProvider>().toggleHistoryDay(habit.id, day);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isToday
                  ? AppColors.black
                  : (isCompleted ? AppColors.mint : AppColors.scaffoldLight),
              border: isToday
                  ? null
                  : Border.all(color: AppColors.divider),
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isToday
                      ? AppColors.white
                      : (isCompleted ? AppColors.textDark : AppColors.textGrey),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}