import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Centralizamos tus colores insignia
  static const Color accentBlue = Color(0xFF3B82F6); 
  static const Color avatarBackground = Color(0xFFE5CFA8);

  // --- TEMA CLARO ---
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueAccent,
      splashColor: accentBlue, // Para el punto de Toolbox.
      canvasColor: avatarBackground, // Para el fondo del ícono
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      
      // EL MOTOR MODERNO: Aquí Flutter sabrá qué colores usar por defecto
      colorScheme: const ColorScheme.light(
        primary: accentBlue,
        surface: Colors.white, // Color de las tarjetas en modo claro
        onSurface: Colors.black, // Color del texto principal en modo claro
        surfaceContainerHighest: Color(0xFFE5E7EB), // Bordes sutiles
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      dividerColor: Colors.black54,
      
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      
      // TUS FUENTES EXACTAS
      textTheme: TextTheme(
        titleLarge: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 32, letterSpacing: -1),
        titleMedium: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 22),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFF666666), fontSize: 14), 
        titleSmall: GoogleFonts.inter(color: Colors.grey[600], fontSize: 11),
      ),
      useMaterial3: true,
    );
  }

  // --- TEMA OSCURO ---
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurpleAccent,
      splashColor: accentBlue, // Para el punto de Toolbox.
      canvasColor: avatarBackground, // Para el fondo del ícono
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      
      // EL MOTOR MODERNO
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        surface: Color(0xFF141414), // Tarjetas gris oscuro
        onSurface: Colors.white, // Texto blanco
        surfaceContainerHighest: Color(0xFF222222), // Bordes sutiles
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      dividerColor: Colors.white,
      
      cardTheme: CardThemeData(
        color: const Color(0xFF141414),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      
      // TUS FUENTES EXACTAS
      textTheme: TextTheme(
        titleLarge: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32, letterSpacing: -1),
        titleMedium: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 22),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFFA0A0A0), fontSize: 14),
        titleSmall: GoogleFonts.inter(color: Colors.grey[400], fontSize: 11),
      ),
      useMaterial3: true,
    );
  }
}