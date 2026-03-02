import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/wp_post_model.dart'; // Verifica que aquí esté la clase Weather
import 'package:geolocator/geolocator.dart';

class WeatherService {
  // Forma correcta de acceder a las variables de entorno
  String get baseUrl => dotenv.env['WEATHER_BASE_URL'] ?? '';
  String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  Future<Weather> getWeatherCoords(double lat, double lon) async {
    // Es buena práctica usar Uri.https o Uri.parse directamente
    final url = '$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Asegúrate de que sea fromJson (con J mayúscula)
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}