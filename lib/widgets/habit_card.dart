// lib/widgets/habit_card.dart

import 'package:flutter/material.dart';
import 'package:habit_tracker/model/habit.dart';
import '../theme/app_theme.dart';


class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback? onTap;

  const HabitCard({
    super.key,
    required this.habit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Water still gets the mint "large card" treatment by name (see home_screen.dart);
    // everything else is a small black card. Colors no longer branch on `type`
    // since every habit is HabitType.counter now.
    final bool isWater = habit.name == 'water';
    final Color background = isWater ? AppColors.mint : AppColors.black;
    final Color textColor = isWater ? AppColors.textDark : AppColors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(24),
        ),
        child: isWater ? _buildLargeCard(textColor) : _buildSmallCard(textColor),
      ),
    );
  }

  // Small card layout: emoji, name, and current/target progress.
  Widget _buildSmallCard(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(habit.emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 20),
        Text(
          habit.name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${habit.currentValue} / ${habit.targetValue}',
          style: TextStyle(
            fontSize: 13,
            color: textColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  // Large card layout (water): emoji + name, then 3 stats in a row.
  Widget _buildLargeCard(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(habit.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Text(
              habit.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statColumn('glasses', '${habit.currentValue}/${habit.targetValue}', textColor),
            _statColumn('max', '${habit.targetValue} glasses', textColor),
            _statColumn('streaks', '${habit.streakDays} days', textColor),
          ],
        ),
      ],
    );
  }

  Widget _statColumn(String label, String value, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: textColor.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}