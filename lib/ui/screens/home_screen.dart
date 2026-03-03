import 'package:coteau_v2/models/Weather_model.dart';
import 'package:coteau_v2/models/wp_post_model.dart';
import 'package:coteau_v2/services/weather_service.dart';
import 'package:coteau_v2/services/wp_post_service.dart'; // Importa tu nuevo servicio
import 'package:coteau_v2/ui/widgets/_buildActionCard.dart';
import 'package:coteau_v2/ui/widgets/_buildDiscoveryTile.dart';
import 'package:coteau_v2/ui/widgets/_buildWeatherCard.dart';
import 'package:coteau_v2/ui/widgets/_buildNewsCard.dart'; // Importa el widget de noticias
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherService = WeatherService();
  final _newsService = NewsService(); // Inicializamos el servicio de noticias
  
  Weather? _weather;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

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
          onRefresh: () async {
            await _fetchWeather();
            setState(() {}); // Refresca también el FutureBuilder de noticias
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), 
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 24),

                // Clima
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_weather != null)
                  WeatherCard(weather: _weather!)
                else
                  const Text("No se pudo cargar el clima"),
                
                const SizedBox(height: 32),

                // --- Identity Tools ---
                Text("Identity Tools", style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                Row(
                  children: [
                    QuickActionCard(
                      icon: Icons.face_retouching_natural,
                      title: "Genderize",
                      subtitle: "Name prediction",
                      accentColor: const Color(0xFFE91E63),
                      onTap: () => Navigator.pushNamed(context, '/gender'),
                    ),
                    const SizedBox(width: 16),
                    QuickActionCard(
                      icon: Icons.cake,
                      title: "Agify",
                      subtitle: "Age estimator",
                      accentColor: const Color(0xFFFF9800),
                      onTap: () => Navigator.pushNamed(context, '/age'),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // --- Discovery ---
                Text("Discovery", style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                DiscoveryTile(
                  icon: Icons.school,
                  title: "University Finder",
                  subtitle: "Global campus database",
                  iconColor: const Color(0xFF8BC34A),
                  onTap: () => Navigator.pushNamed(context, '/universities'),
                ),
                DiscoveryTile(
                  icon: Icons.catching_pokemon,
                  title: "PokéDex",
                  subtitle: "Complete entity catalog",
                  iconColor: const Color(0xFF03A9F4),
                  onTap: () => Navigator.pushNamed(context, '/pokemon'),
                ),

                const SizedBox(height: 32),

                // --- Dev News Section (WordPress API) ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dev News", style: theme.textTheme.titleMedium),
                    const Text("WORDPRESS API", style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // FutureBuilder para cargar las noticias dinámicamente
                FutureBuilder<List<WpPost>>(
                  future: _newsService.fetchPosts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Text("Error al cargar noticias");
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("No hay noticias disponibles");
                    }

                    // Renderizamos la lista de noticias usando el widget DevNewsCard
                    return Column(
                      children: snapshot.data!.map((post) => DevNewsCard(
                        title: post.title,
                        excerpt: post.excerpt,
                        imageUrl: post.featuredImageUrl,
                        author: post.authorName,
                        date: post.date,
                        onTap: () {
                          // Lógica para abrir la noticia completa
                        },
                      )).toList(),
                    );
                  },
                ),
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