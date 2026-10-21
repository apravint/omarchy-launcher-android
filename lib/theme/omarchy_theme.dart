import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OmarchyTheme {
  static const Color cyan = Color(0xFF00F0FF);
  static const Color purple = Color(0xFFBD00FF);
  static const Color green = Color(0xFF00FF9D);
  static const Color darkBg = Color(0xFF090A0F);
  static const Color darkCard = Color(0xF212131C);
  static const Color borderCyan = Color(0x3300F0FF);

  static ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: cyan,
        secondary: purple,
        surface: darkCard,
        onSurface: Colors.white,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
    );
  }
}
