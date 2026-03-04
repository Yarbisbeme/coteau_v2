import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/university_model.dart';
import '../../services/university_service.dart';

class UniversityScreen extends StatefulWidget {
  const UniversityScreen({super.key});

  @override
  State<UniversityScreen> createState() => _UniversityScreenState();
}

class _UniversityScreenState extends State<UniversityScreen> {
  final TextEditingController _countryController = TextEditingController();
  final UniversityService _service = UniversityService();
  
  List<UniversityModel> _universities = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchUniversities() async {
    final country = _countryController.text.trim();
    if (country.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _universities = [];
    });

    try {
      final results = await _service.getUniversitiesByCountry(country);
      setState(() {
        _universities = results;
        if (results.isEmpty) {
          _errorMessage = 'No se encontraron universidades en "$country". Intenta en inglés (ej. Dominican Republic).';
        }
      });
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _launchURL(String urlString) async {
    if (urlString.isEmpty) return;
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir el enlace: $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // AQUÍ ESTÁ LA MAGIA: Extraemos el tema actual (Claro u Oscuro)
    final theme = Theme.of(context);

    return Scaffold(
      // Usamos el fondo del tema dinámico
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('University Search', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        // El color del ícono (flecha de atrás) ya lo maneja theme.dart automáticamente
      ),
      body: Column(
        children: [
          // BARRA DE BÚSQUEDA
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _countryController,
              // Texto dinámico: Blanco en oscuro, Negro en claro
              style: TextStyle(color: theme.colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Search by country (e.g. Dominican Republic)',
                hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                filled: true,
                // Fondo del input dinámico
                fillColor: theme.colorScheme.surface,
                prefixIcon: Icon(Icons.search, color: theme.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _searchUniversities(),
            ),
          ),

          // CABECERA DE RESULTADOS
          if (_universities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TOP INSTITUTIONS', style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2)),
                  Text('${_universities.length} Results', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12)),
                ],
              ),
            ),

          // MANEJO DE ESTADOS
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: theme.primaryColor))
                : _errorMessage.isNotEmpty
                    ? Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(_errorMessage, style: const TextStyle(color: Colors.redAccent), textAlign: TextAlign.center)))
                    : _universities.isEmpty
                        ? Center(child: Text('Busca un país para ver sus universidades.', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            itemCount: _universities.length,
                            itemBuilder: (context, index) {
                              // Le pasamos el theme al método para que construya la tarjeta
                              return _buildUniversityCard(_universities[index], theme);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  // DISEÑO DE LA TARJETA: Minimalista, Contemporáneo y Premium
  Widget _buildUniversityCard(UniversityModel uni, ThemeData theme) {
    // Extraemos la primera letra de la universidad para hacer un logo elegante
    final String initial = uni.name.isNotEmpty ? uni.name[0].toUpperCase() : 'U';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SECCIÓN SUPERIOR: Logo, Nombre y País
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // Textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      uni.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                        const SizedBox(width: 4),
                        Text(
                          uni.country,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // El "Monograma" (Logo dinámico)
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          // DIVISOR SUTIL
          Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.05), height: 1),
          const SizedBox(height: 16),
          
          // SECCIÓN INFERIOR: Dominio y Botón de acción
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Dominio con estilo de "tag"
              Row(
                children: [
                  Icon(Icons.link, size: 16, color: theme.primaryColor),
                  const SizedBox(width: 6),
                  Text(
                    uni.domain,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              // Botón minimalista de alto contraste
              ElevatedButton(
                onPressed: () => _launchURL(uni.webPage),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.onSurface, // Color opuesto al fondo
                  foregroundColor: theme.colorScheme.surface,   // Texto del color del fondo
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size.zero, // Permite que el botón sea más compacto
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Visit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_outward, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}