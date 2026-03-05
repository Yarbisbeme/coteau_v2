import 'package:flutter/material.dart';
import '../../models/wp_post_model.dart';
import '../../services/wp_post_service.dart';
// Importa tu widget de tarjeta (ajusta la ruta si es diferente en tu proyecto)
import '../widgets/_BuildNewsCard.dart'; 

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  late Future<List<WpPost>> _postsFuture;

  @override
  void initState() {
    super.initState();
    // Inicializamos el Future una sola vez en el initState (Regla de QA de rendimiento)
    _postsFuture = _newsService.fetchPosts();
  }

  // Método para el Pull-to-Refresh
  Future<void> _refreshNews() async {
    setState(() {
      _postsFuture = _newsService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
        title: Text(
          'News',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Botón extra de recarga en el AppBar
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _refreshNews,
            tooltip: 'Actualizar noticias',
          ),
        ],
      ),
      body: FutureBuilder<List<WpPost>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // ESTADO 1: Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: theme.primaryColor));
          } 
          // ESTADO 2: Error
          else if (snapshot.hasError) {
            return _buildErrorState(theme);
          } 
          // ESTADO 3: Vacío
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState(theme);
          }

          // ESTADO 4: ¡Éxito! Tenemos datos
          final posts = snapshot.data!;

          return RefreshIndicator(
            color: theme.primaryColor,
            backgroundColor: theme.colorScheme.surface,
            onRefresh: _refreshNews,
            child: ListView.builder(
              // Este physics es vital para que el RefreshIndicator funcione aunque haya pocas noticias
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.all(20),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: DevNewsCard(
                    title: post.title,
                    excerpt: post.excerpt,
                    imageUrl: post.featuredImageUrl,
                    author: post.authorName,
                    date: post.date,
                    onTap: () {
                      // Usamos la ruta exacta que definiste en tu main.dart
                      Navigator.pushNamed(context, '/news_detail_screen', arguments: post);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // --- COMPONENTES DE ESTADOS VISUALES PREMIUM ---

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 80, color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
            const SizedBox(height: 24),
            Text('¡Señal Perdida!', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(
              'No pudimos conectar con el blog de WordPress. Verifica tu internet y vuelve a intentarlo.',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _refreshNews,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.onSurface,
                foregroundColor: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 80, color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          Text(
            'No hay noticias publicadas aún.',
            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}