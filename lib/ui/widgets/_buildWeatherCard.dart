
import 'package:coteau_v2/models/wp_post_model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  // Función para determinar qué animación mostrar según el clima de OpenWeatherMap
  String getWeatherAnimation(String? mainCondition) {

    final hour = DateTime.now().hour;
    final isNight = hour >= 18 || hour < 6; // Consideramos noche entre las 6 PM y las 6 AM

    if (mainCondition == null) return isNight ? 'assets/animations/weather/night.json' : 'assets/animations/weather/sunny.json';
    
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/animations/weather/clouds.json';
      case 'mist':
        return 'assets/animations/weather/clouds.json';
      case 'smoke':
        return 'assets/animations/weather/clouds.json';
      case 'haze':
        return 'assets/animations/weather/clouds.json';
      case 'dust':
        return 'assets/animations/weather/clouds.json';
      case 'fog':
        return 'assets/animations/weather/clouds.json';
      case 'rain': 
        return isNight ? 'assets/animations/weather/partly_shower_night.json' : 'assets/animations/weather/partly_shower.json';
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // Degradado azul según tu diseño
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2962FF), Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weather.cityName,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${weather.temperature.round()}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                weather.mainCondition,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'H: 75° L: 60°', // Puedes mapear estos desde la API si quieres
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
            ],
          ),
          // Posicionamiento de la animación Lottie
          Positioned(
            right: 0,
            bottom: 30,
            child: Lottie.asset(
              getWeatherAnimation(weather.mainCondition),
              width: 120,
              height: 120,
            ),
          ),
          // Botón "Updated Now"
          
        ],
      ),
    );
  }
}