// lib/widgets/add_habit_dialog.dart

import 'package:flutter/material.dart';
import 'package:habit_tracker/provider/habit_provider.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetController = TextEditingController(
    text: '10',
  ); // default daily target

  final List<String> _emojiOptions = [
    '🚭',
    '🌿',
    '🪣',
    '🏃',
    '📚',
    '💪',
    '🧘',
    '🥗',
    '😴',
    '🚴',
    '💊',
    '🎯',
  ];

  String _selectedEmoji = '🪣';

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return; // require a name

    final target = int.tryParse(_targetController.text.trim()) ?? 10;

    context.read<HabitProvider>().addHabit(
      name: name,
      emoji: _selectedEmoji,
      targetValue: target,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'add a habit',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),

              // Emoji picker grid
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _emojiOptions.map((emoji) {
                  final isSelected = emoji == _selectedEmoji;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedEmoji = emoji),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.mint
                            : AppColors.scaffoldLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.black
                              : AppColors.divider,
                        ),
                      ),
                      child: Text(emoji, style: const TextStyle(fontSize: 20)),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Habit name field
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'habit name',
                  filled: true,
                  fillColor: AppColors.scaffoldLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Daily target — every habit is a counter now, so this
              // controls what "100%" means for its +/- tracking.
              TextField(
                controller: _targetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'daily target (e.g. 10)',
                  filled: true,
                  fillColor: AppColors.scaffoldLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('add habit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
