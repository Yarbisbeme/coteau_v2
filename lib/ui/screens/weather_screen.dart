import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../models/Weather_model.dart'; 

class WeatherScreen extends StatelessWidget {
  // 1. Pedimos el clima explícitamente como un requerimiento
  final Weather weather;

  const WeatherScreen({super.key, required this.weather});

  String getWeatherAnimation(String? mainCondition) {
    // ... (Mantén tu función de animación Lottie exactamente igual) ...
    final hour = DateTime.now().hour;
    final isNight = hour >= 18 || hour < 6;

    if (mainCondition == null) return isNight ? 'assets/animations/weather/night.json' : 'assets/animations/weather/sunny.json';
    
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/animations/weather/clouds.json';
      case 'rain': 
      case 'drizzle':
      case 'shower rain':
        return isNight ? 'assets/animations/weather/partly_shower_night.json' : 'assets/animations/weather/partly_shower.json';
      case 'thunderstorm':
        return 'assets/animations/weather/storm.json';
      case 'clear':
        return isNight ? 'assets/animations/weather/night.json' : 'assets/animations/weather/sunny.json';
      default:
        return isNight ? 'assets/animations/weather/partly_cloudy_night.json' : 'assets/animations/weather/partly_cloudy.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 2. ELIMINAMOS LA LÍNEA DE ModalRoute PORQUE YA TENEMOS LA VARIABLE ARRIBA
    
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    final isNight = hour >= 18 || hour < 6;

    final List<Color> bgColors = isNight
        ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
        : [const Color(0xFF2962FF), const Color(0xFF1565C0), const Color(0xFF0D47A1)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: bgColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // --- APP BAR PERSONALIZADO ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Live Weather',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 48), // Espaciador para centrar el título
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- SECCIÓN HERO (Animación y Temperatura) ---
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weather.cityName.toUpperCase(),
                      style: const TextStyle(color: Colors.white70, fontSize: 28, letterSpacing: 4),
                    ),
                    const SizedBox(height: 20),
                    // Usamos tu animación Lottie
                    Lottie.asset(
                      getWeatherAnimation(weather.mainCondition),
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${weather.temperature.round()}°',
                      style: const TextStyle(color: Colors.white, fontSize: 100, fontWeight: FontWeight.w900, height: 1.0),
                    ),
                    Text(
                      weather.mainCondition,
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Max: ${weather.maxTemp.round()}°  •  Min: ${weather.minTemp.round()}°', // Usamos H y L de tu modelo
                      style: const TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  ],
                ),
              ),

              // --- PANEL INFERIOR BENTO (Detalles Extra) ---
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildExtraDetailCard(Icons.water_drop_outlined, "Humedad", "${weather.humidity}%", theme),
                    _buildExtraDetailCard(Icons.air_outlined, "Viento", "${weather.windSpeed} km/h", theme),
                    _buildExtraDetailCard(Icons.thermostat_outlined, "Sensación", "${weather.feelsLike.round()}°", theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExtraDetailCard(IconData icon, String label, String value, ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ]
          ),
          child: Icon(icon, color: Colors.blueAccent, size: 28),
        ),
        const SizedBox(height: 12),
        Text(value, style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}