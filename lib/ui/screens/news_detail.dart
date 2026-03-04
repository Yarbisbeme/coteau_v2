import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../models/wp_post_model.dart'; // Ajusta la ruta si es necesario

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 🔥 LA MAGIA DEL ENRUTAMIENTO: Capturamos el post que viene en la "mochila"
    final WpPost post = ModalRoute.of(context)!.settings.arguments as WpPost;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // Usamos un AppBar transparente para un look más limpio
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. IMAGEN DESTACADA (Si tiene)
            if (post.featuredImageUrl.isNotEmpty)
              Container(
                width: double.infinity,
                height: 250,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    post.featuredImageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.image_not_supported, color: Colors.grey, size: 50),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // 2. TÍTULO Y METADATOS (Autor y Fecha)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge decorativo
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'TECH NEWS',
                      style: TextStyle(color: theme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Título principal
                  Text(
                    post.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Fila de Autor y Fecha
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
                        child: Icon(Icons.person, size: 16, color: theme.primaryColor),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.authorName,
                              style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              post.date,
                              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.05), height: 1),
            const SizedBox(height: 16),

            // 3. EL CONTENIDO DE LA NOTICIA (Renderizado de HTML)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Html(
                // OJO AQUÍ: Asegúrate de que tu modelo WpPost tenga una propiedad para el contenido completo (usualmente json['content']['rendered']). 
                // Si en tu modelo lo llamaste 'content', usa post.content.
                data: post.content, 
                style: {
                  "body": Style(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    fontSize: FontSize(16.0),
                    lineHeight: const LineHeight(1.6),
                    margin: Margins.zero,
                  ),
                  "a": Style(
                    color: theme.primaryColor,
                    textDecoration: TextDecoration.none,
                  ),
                  "h1": Style(color: theme.colorScheme.onSurface),
                  "h2": Style(color: theme.colorScheme.onSurface),
                  "h3": Style(color: theme.colorScheme.onSurface),
                },
              ),
            ),
            
            const SizedBox(height: 40), // Espacio extra al final para que respire
          ],
        ),
      ),
    );
  }
}