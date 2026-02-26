import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // --- TEMA CLARO ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueAccent,
      splashColor:  const Color(0xFF3B82F6),
      fontFamily: GoogleFonts.inter().fontFamily,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // CORRECCIÓN: Usamos CardThemeData
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        titleMedium: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFFA0A0A0), fontSize: 14), // Texto secundario gris
      ),
      useMaterial3: true,
    );
  }

  // --- TEMA OSCURO ---
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF00E5FF),
      splashColor:  const Color(0xFF3B82F6),
      canvasColor: const Color(0xFFE5CFA8),
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D0D0D),
        elevation: 0,
      ),
      // CORRECCIÓN: Usamos CardThemeData
      cardTheme: CardThemeData(
        color: const Color(0xFF141414),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32, letterSpacing: -1),
        titleMedium: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFFA0A0A0), fontSize: 14), // Texto secundario gris
        titleSmall: GoogleFonts.inter(color: Colors.grey[600], fontSize: 11),
      ),
      useMaterial3: true,
    );
  }
}