import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../models/pokemon_model.dart';
import '../../services/poke_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PokemonService _service = PokemonService();
  final AudioPlayer _audioPlayer = AudioPlayer(); // Nuestro reproductor
  
  PokemonModel? _pokemon;
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchPokemon() async {
    final name = _searchController.text.trim();
    if (name.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _pokemon = null;
    });

    try {
      final result = await _service.getPokemon(name);
      setState(() {
        _pokemon = result;
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _playCry() async {
    if (_pokemon != null && _pokemon!.cryUrl.isNotEmpty) {
      await _audioPlayer.play(UrlSource(_pokemon!.cryUrl));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _audioPlayer.dispose(); // Regla de QA: Siempre liberar la memoria de los reproductores
    super.dispose();
  }

  // Mapa de colores según el tipo de Pokémon (como en tu diseño)
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire': return const Color(0xFFFA6C6C);
      case 'water': return const Color(0xFF6890F0);
      case 'grass': return const Color(0xFF48CFB2);
      case 'electric': return const Color(0xFFFFCE4B);
      case 'psychic': return const Color(0xFFFA92B2);
      case 'ice': return const Color(0xFF98D8D8);
      case 'dragon': return const Color(0xFF7038F8);
      case 'dark': return const Color(0xFF705848);
      case 'fairy': return const Color(0xFFEE99AC);
      case 'normal': return const Color(0xFFA8A878);
      case 'poison': return const Color(0xFFA040A0);
      case 'ground': return const Color(0xFFE0C068);
      case 'flying': return const Color(0xFFA890F0);
      case 'bug': return const Color(0xFFA8B820);
      case 'rock': return const Color(0xFFB8A038);
      case 'ghost': return const Color(0xFF705898);
      case 'steel': return const Color(0xFFB8B8D0);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Obtenemos el color dinámico del fondo según el Pokémon actual
    Color bgColor = _pokemon != null && _pokemon!.types.isNotEmpty 
        ? _getTypeColor(_pokemon!.types[0]) 
        : theme.scaffoldBackgroundColor;

    Color appBarElementsColor = _pokemon != null && _pokemon!.types.isNotEmpty 
        ? _getTypeColor(_pokemon!.types[0]) 
        : theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: appBarElementsColor, 
        ),
        title: Text(
          'PokéDex Finder', 
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: appBarElementsColor, 
          )
        ),
      ),
      body: Column(
        children: [
          // BARRA DE BÚSQUEDA
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search (e.g. Charizard, Pikachu)',
                hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                filled: true,
                fillColor: theme.colorScheme.surface,
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
              onSubmitted: (_) => _searchPokemon(),
            ),
          ),

          // CONTENIDO PRINCIPAL
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
                // 🔥 CAMBIO AQUÍ: Si hay error, mostramos el nuevo estado visual
                : _errorMessage.isNotEmpty
                    ? _buildErrorState(theme, _errorMessage) 
                    : _pokemon == null
                        ? Center(child: Icon(Icons.catching_pokemon, size: 100, color: theme.colorScheme.onSurface.withValues(alpha: 0.1)))
                        : SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: _buildPokemonCard(theme, bgColor),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonCard(ThemeData theme, Color primaryColor) {
    // Matemáticas de diseño para evitar que la imagen pise el texto
    const double imageHeight = 310.0;
    const double cardMarginTop = imageHeight / 2; // La tarjeta empieza a la mitad de la imagen
    const double contentPaddingTop = (imageHeight / 3); // El texto empieza después de la imagen + 20px de respiro

    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // 1. LA TARJETA DEL FONDO
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: cardMarginTop), 
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3), // Un brillo un poco más suave
                  blurRadius: 40, 
                  spreadRadius: 5, 
                  offset: const Offset(0, 10)
                )
              ]
            ),
            child: Padding(
              // Aquí está la magia: Usamos el contentPaddingTop calculado
              padding: const EdgeInsets.only(top: contentPaddingTop, left: 24, right: 24, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // NOMBRE
                  Text(
                    _pokemon!.name[0].toUpperCase() + _pokemon!.name.substring(1),
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  
                  // TIPOS (Pills)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _pokemon!.types.map((type) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getTypeColor(type).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type.toUpperCase(),
                        style: TextStyle(color: _getTypeColor(type), fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: 32),

                  // ESTADÍSTICAS (Altura, Peso, Exp)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn(theme, 'Height', '${_pokemon!.height}m'),
                      _buildStatColumn(theme, 'Weight', '${_pokemon!.weight}kg'),
                      _buildStatColumn(theme, 'Base Exp', _pokemon!.baseExperience.toString(), textColor: Colors.redAccent),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // BARRA DE EXPERIENCIA
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Base Experience', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600)),
                          Text('${_pokemon!.baseExperience} / 300', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: (_pokemon!.baseExperience / 300).clamp(0.0, 1.0),
                        backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                        color: Colors.deepOrange,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // HABILIDADES
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Abilities', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: _pokemon!.abilities.map((ability) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, size: 12, color: Colors.green),
                          const SizedBox(width: 6),
                          Text(ability[0].toUpperCase() + ability.substring(1), style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 12)),
                        ],
                      ),
                    )).toList(),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // BOTÓN DE REPRODUCIR GRITO
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _playCry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF35353),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.volume_up),
                      label: const Text('Play Cry', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 2. LA IMAGEN DEL POKÉMON
          Positioned(
            top: -50,
            child: Hero(
              tag: _pokemon!.name,
              child: Image.network(
                _pokemon!.imageUrl,
                height: imageHeight, // Usamos la variable constante
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStatColumn(ThemeData theme, String label, String value, {Color? textColor}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: textColor ?? theme.colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // DISEÑO PREMIUM PARA EL ESTADO "NO ENCONTRADO"
  Widget _buildErrorState(ThemeData theme, String message) {
    // Verificamos si es un error de "no encontrado" o de conexión
    final bool isNotFound = message.contains('not found') || message.contains('no encontrado');
    
    // Extracción limpia del texto para evitar imprimir el objeto completo
    final String searchedName = _searchController.text.trim(); 
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Iconografía temática minimalista (Una Pokebola "vacía")
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.1), width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))
                ]
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.catching_pokemon, size: 100, color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
                  Positioned(
                    top: 40,
                    right: 40,
                    child: Icon(Icons.question_mark_rounded, size: 40, color: theme.colorScheme.onSurface.withValues(alpha: 0.2)),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Texto de Título
            Text(
              isNotFound ? '¡Un $searchedName salvaje huyó!' : '¡Error de Conexión!',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: theme.colorScheme.onSurface,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Texto de descripción (Ahora con la variable limpia)
            Text(
              isNotFound 
                ? 'El oráculo de datos no pudo encontrar al Pokémon "$searchedName". Revisa la ortografía e intenta de nuevo.'
                : 'Parece que el Equipo Rocket cortó los cables del servidor. Intenta buscar de nuevo en unos momentos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 15,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Apilamiento de Botones
            Column(
              children: [
                // 1. Botón de Búsqueda en la Web (Solo aparece si el error es que no se encontró)
                if (isNotFound)
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Construimos la URL para buscar en Google
                      final url = Uri.parse('https://www.google.com/search?q=pokemon+$searchedName');
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.onSurface, // Alto contraste
                      foregroundColor: theme.colorScheme.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.travel_explore, size: 20),
                    label: const Text('Buscar en la Web', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                
                if (isNotFound) const SizedBox(height: 12),

                // 2. Botón para limpiar (El que ya teníamos)
                TextButton.icon(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _errorMessage = '';
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text('Limpiar y buscar otro', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}