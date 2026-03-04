import 'package:html_unescape/html_unescape.dart';

class WpPost {
  final String title;
  final String excerpt;
  final String content;
  final String featuredImageUrl;
  final String authorName;
  final String date;

  WpPost({
    required this.title,
    required this.excerpt,
    required this.content,
    required this.featuredImageUrl,
    required this.authorName,
    required this.date,
  });

  factory WpPost.fromJson(Map<String, dynamic> json) {
    // 1. Instanciamos el limpiador de texto
    var unescape = HtmlUnescape();

    // Lógica para extraer la imagen destacada (si usas el campo incrustado)
    String imageUrl = '';
    if (json['_embedded'] != null && json['_embedded']['wp:featuredmedia'] != null) {
      imageUrl = json['_embedded']['wp:featuredmedia'][0]['source_url'] ?? '';
    }

    // Lógica para el autor
    String author = 'Admin';
    if (json['_embedded'] != null && json['_embedded']['author'] != null) {
      author = json['_embedded']['author'][0]['name'] ?? 'Admin';
    }

    return WpPost(
      // 2. Pasamos el título y el extracto por el limpiador "unescape.convert()"
      title: unescape.convert(json['title']['rendered'] ?? 'Sin título'),
      
      // Limpiamos el extracto y le quitamos las etiquetas <p> sobrantes si las tiene
      excerpt: unescape.convert(json['excerpt']['rendered'] ?? '')
               .replaceAll('<p>', '')
               .replaceAll('</p>', '')
               .trim(),
               
      content: json['content']['rendered'] ?? '',
      featuredImageUrl: imageUrl,
      authorName: author,
      
      // Formateo simple de fecha (cortamos la "T" y la hora que trae WordPress)
      date: (json['date'] ?? '').split('T')[0], 
    );
  }
}