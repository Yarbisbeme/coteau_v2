class WpPost {
  final int id;
  final String title;
  final String excerpt;
  final String content;
  final String featuredImageUrl;
  final String date;
  final String authorName;

  WpPost({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.featuredImageUrl,
    required this.date,
    required this.authorName,
  });

  factory WpPost.fromJson(Map<String, dynamic> json) {
    // Extraemos la imagen de la estructura _embedded de WordPress
    String imageUrl = 'https://via.placeholder.com/600x400'; 
    if (json['_embedded'] != null && 
        json['_embedded']['wp:featuredmedia'] != null) {
      imageUrl = json['_embedded']['wp:featuredmedia'][0]['source_url'];
    }

    // Limpiamos las etiquetas HTML del extracto (excerpt)
    String cleanExcerpt = json['excerpt']['rendered']
        .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');

    return WpPost(
      id: json['id'],
      title: json['title']['rendered'] ?? 'Sin título',
      excerpt: cleanExcerpt,
      content: json['content']['rendered'] ?? '',
      featuredImageUrl: imageUrl,
      date: json['date'].toString().split('T')[0], // Solo la fecha YYYY-MM-DD
      authorName: json['_embedded']?['author']?[0]?['name'] ?? 'Admin',
    );
  }
}