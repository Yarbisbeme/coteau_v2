import 'package:coteau_v2/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'core/theme.dart'; // Importamos nuestro nuevo archivo de temas

void main() {
  runApp(const ToolboxApp());
}

class ToolboxApp extends StatelessWidget {
  const ToolboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Toolbox App',
      // Aplicamos nuestros temas personalizados
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Cambia automáticamente según el celular
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}