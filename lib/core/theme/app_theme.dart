import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1C6DD0)),
      textTheme: GoogleFonts.interTextTheme(),
      useMaterial3: true,
    );
  }
}
