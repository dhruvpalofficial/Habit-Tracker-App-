// lib/widgets/edit_habit_dialog.dart

import 'package:flutter/material.dart';
import 'package:habit_tracker/model/habit.dart';
import 'package:habit_tracker/provider/habit_provider.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

class EditHabitDialog extends StatefulWidget {
  final Habit habit;

  const EditHabitDialog({super.key, required this.habit});

  @override
  State<EditHabitDialog> createState() => _EditHabitDialogState();
}

class _EditHabitDialogState extends State<EditHabitDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _targetController;

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

  late String _selectedEmoji;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields with the habit's existing data.
    _nameController = TextEditingController(text: widget.habit.name);
    _targetController = TextEditingController(
      text: widget.habit.targetValue.toString(),
    );
    _selectedEmoji = widget.habit.emoji;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final target =
        int.tryParse(_targetController.text.trim()) ?? widget.habit.targetValue;

    context.read<HabitProvider>().editHabit(
      id: widget.habit.id,
      name: name,
      emoji: _selectedEmoji,
      targetValue: target,
    );

    Navigator.of(context).pop(); // close dialog
  }

  void _delete() {
    // Confirm before deleting — irreversible action.
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('delete habit?'),
        content: Text('this will permanently remove "${widget.habit.name}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // just close confirm
            child: const Text('cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<HabitProvider>().deleteHabit(widget.habit.id);
              Navigator.of(context).pop(); // close confirm dialog
              Navigator.of(context).pop(); // close edit dialog
              Navigator.of(context).pop(); // close detail screen (back to Home)
            },
            child: const Text('delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'edit habit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),

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
                        color: isSelected ? AppColors.black : AppColors.divider,
                      ),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 20)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

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

            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'daily target',
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
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('save changes'),
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _delete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('delete habit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
