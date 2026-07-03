// lib/screens/habit_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:habit_tracker/model/habit.dart';
import 'package:habit_tracker/provider/habit_provider.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

import '../widgets/history_grid.dart';
import '../widgets/edit_habit_dialog.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habit; // which habit this screen is tracking

  const HabitDetailScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    // Watch the provider so the counter updates live as +/- are tapped.
    final habitProvider = context.watch<HabitProvider>();

    // Re-fetch the latest version of this habit by id (in case it changed).
    // If it was just deleted (via the edit dialog), fall back safely to
    // popping back to Home instead of crashing on firstWhere.
    final matches = habitProvider.habits.where((h) => h.id == habit.id);
    if (matches.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final current = matches.first;

    return Scaffold(
      backgroundColor: AppColors.mint,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: back arrow, title, settings gear
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleIconButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    '${current.emoji} ${current.name}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  _circleIconButton(
                    icon: Icons.settings,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => EditHabitDialog(habit: current),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: AppColors.textDark.withOpacity(0.1), thickness: 1),
              const SizedBox(height: 40),

              // Center counter row: - big number +
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _circleIconButton(
                          icon: Icons.remove,
                          filled: false,
                          onTap: () => context
                              .read<HabitProvider>()
                              .decrementHabit(current.id),
                        ),
                        const SizedBox(width: 24),
                        Text(
                          '${current.currentValue}',
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(width: 24),
                        _circleIconButton(
                          icon: Icons.add,
                          filled: true,
                          onTap: () => context
                              .read<HabitProvider>()
                              .incrementHabit(current.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text.rich(
                      TextSpan(
                        text: 'of ${current.targetValue} ${current.name} ',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: '/ day',
                            style: TextStyle(
                              color: AppColors.textDark.withOpacity(0.5),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'streak: ${current.streakDays} days',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textDark.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Habit history card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'habit history',
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
                      const SizedBox(height: 16),
                      Expanded(child: HistoryGrid(habit: current)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? AppColors.black : Colors.transparent,
          border: filled
              ? null
              : Border.all(color: AppColors.textDark.withOpacity(0.3)),
        ),
        child: Icon(
          icon,
          color: filled ? AppColors.white : AppColors.textDark,
          size: 20,
        ),
      ),
    );
  }
}
