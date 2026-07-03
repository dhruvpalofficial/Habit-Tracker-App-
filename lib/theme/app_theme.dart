import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Backgrounds
  static const Color scaffoldLight = Color(0xFFFFFFFF);

  // Habit card colors (from the design)
  static const Color mint = Color(0xFFDDEDEC);
  static const Color peach = Color(0xFFFBEBCC);
  static const Color black = Color(0xFF101010);

  // Text
  static const Color textDark = Color(0xFF101010);
  static const Color textGrey = Color(0xFF9A9A9A);
  static const Color white = Color(0xFFFFFFFF);

  // Borders / dividers
  static const Color divider = Color(0xFFE4E4E4);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.scaffoldLight,
      fontFamily: GoogleFonts.manrope().fontFamily,
      textTheme: GoogleFonts.manropeTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.black,
        brightness: Brightness.light,
      ),
    );
  }
}
