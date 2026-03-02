import 'package:coteau_v2/models/wp_post_model.dart';
import 'package:coteau_v2/services/weather_service.dart';
import 'package:coteau_v2/ui/widgets/_buildWeatherCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Inicializamos el servicio (la API Key se lee del .env internamente)
  final _weatherService = WeatherService();
  Weather? _weather;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  // Lógica para obtener ubicación y clima
  Future<void> _fetchWeather() async {
    try {
      Position position = await _weatherService.getCurrentLocation();
      final weather = await _weatherService.getWeatherCoords(
        position.latitude, 
        position.longitude
      );

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error cargando clima: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchWeather, // Permite deslizar hacia abajo para actualizar
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), 
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 24),
                
                // Lógica de carga del WeatherCard
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_weather != null)
                  WeatherCard(weather: _weather!)
                else
                  const Text("No se pudo cargar el clima", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DASHBOARD',
              style: theme.textTheme.titleSmall!
                  .copyWith(letterSpacing: 2, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                text: 'ToolBox',
                style: theme.textTheme.titleLarge,
                children: [
                  TextSpan(
                    text: '.',
                    style: TextStyle(color: theme.splashColor),
                  )
                ],
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset(
              'assets/svg/toolbox.svg',
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
    );
  }
}