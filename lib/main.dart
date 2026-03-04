import 'package:coteau_v2/ui/screens/age_screen.dart';
import 'package:coteau_v2/ui/screens/contratame_screen.dart';
import 'package:coteau_v2/ui/screens/gender_screen.dart';
import 'package:coteau_v2/ui/screens/home_screen.dart';
import 'package:coteau_v2/ui/screens/news_detail.dart';
import 'package:coteau_v2/ui/screens/news_screen.dart';
import 'package:coteau_v2/ui/screens/pokemon_screen.dart';
import 'package:coteau_v2/ui/screens/universities_screen.dart';
import 'package:flutter/material.dart';
import 'core/theme.dart'; // Importamos nuestro nuevo archivo de temas
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Carga el archivo
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
        '/gender_screen': (context) => const GenderScreen(),// Ruta para detalles de noticias
        '/age_screen': (context) => const AgeScreen(), // Ruta para detalles de noticias
        '/universities_screen': (context) => const UniversityScreen(), // Ruta para detalles de noticias
        '/pokemon_screen': (context) => const PokemonScreen(), // Ruta para detalles de noticias
        '/contratame_screen': (context) => const ContratameScreen(), // Ruta para detalles de noticias
        '/news_screen': (context) => const NewsScreen(), // Ruta para detalles de noticias
        '/news_detail_screen': (context) => const NewsDetailsScreen(), // Ruta para detalles de noticias
      },
    );
  }
}