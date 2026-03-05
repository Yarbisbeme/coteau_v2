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
    // Inicializamos como vacío en lugar de una URL externa propensa a CORS
    String imageUrl = ''; 
    var unescape = HtmlUnescape();

    if (json['_embedded'] != null && 
        json['_embedded']['wp:featuredmedia'] != null &&
        json['_embedded']['wp:featuredmedia'].isNotEmpty) {
      imageUrl = json['_embedded']['wp:featuredmedia'][0]['source_url'] ?? '';
    }

    String author = 'Admin';
    if (json['_embedded'] != null && json['_embedded']['author'] != null) {
      author = json['_embedded']['author'][0]['name'] ?? 'Admin';
    }

    return WpPost(
      title: unescape.convert(json['title']['rendered'] ?? 'Sin título'),
      excerpt: unescape.convert(json['excerpt']['rendered'] ?? '')
                .replaceAll('<p>', '')
                .replaceAll('</p>', '')
                .trim(),
      content: json['content']['rendered'] ?? '',
      // Si está vacía, el widget usará un AssetImage de respaldo
      featuredImageUrl: imageUrl, 
      authorName: author,
      date: (json['date'] ?? '').split('T')[0], 
    );
  }
}