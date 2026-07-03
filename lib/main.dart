// lib/main.dart

import 'package:flutter/material.dart';
import 'package:habit_tracker/provider/habit_provider.dart';
import 'package:habit_tracker/screens/home_screen.dart';
import 'package:habit_tracker/screens/intro_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme/app_theme.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HabitProvider(),
      child: MaterialApp(
        title: 'Habit Tracker',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const StartupDecider(),
      ),
    );
  }
}

// Decides whether to show the intro screen or go straight to Home,
// based on the "hasSeenIntro" flag saved in shared_preferences.
class StartupDecider extends StatefulWidget {
  const StartupDecider({super.key});

  @override
  State<StartupDecider> createState() => _StartupDeciderState();
}

class _StartupDeciderState extends State<StartupDecider> {
  bool? _hasSeenIntro; // null while we're still checking

  @override
  void initState() {
    super.initState();
    _checkIntroStatus();
  }

  Future<void> _checkIntroStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('hasSeenIntro') ?? false;
    setState(() {
      _hasSeenIntro = seen;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Still checking shared_preferences — show a blank/loading screen briefly.
    if (_hasSeenIntro == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Show Home if intro was already seen, otherwise show the intro screen.
    return _hasSeenIntro! ? const HomeScreen() : const IntroScreen();
  }
}