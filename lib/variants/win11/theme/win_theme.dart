import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WinTheme {
  static const Color accentBlue = Color(0xFF0067C0);
  static const Color darkMica = Color(0xF2202024);
  static const Color lightMica = Color(0xF2F3F3F3);
  static const Color darkBorder = Color(0x24FFFFFF);
  static const Color lightBorder = Color(0x1F000000);

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0D0D11),
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        surface: Color(0xFF202024),
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF3F3F3),
      colorScheme: const ColorScheme.light(
        primary: accentBlue,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        ThemeData(brightness: Brightness.light).textTheme,
      ),
    );
  }
}
