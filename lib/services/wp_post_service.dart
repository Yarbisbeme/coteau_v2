import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wp_post_model.dart';

class NewsService {
  // Puedes usar esta URL de ejemplo o la de cualquier sitio WordPress
  final String _baseUrl = "https://techcrunch.com/wp-json/wp/v2/posts";

  Future<List<WpPost>> fetchPosts() async {
    try {
      // _embed es fundamental para traer imágenes y autores en el mismo JSON
      final response = await http.get(Uri.parse("$_baseUrl?_embed&per_page=5"));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => WpPost.fromJson(item)).toList();
      } else {
        throw Exception("Fallo al conectar con la API de noticias");
      }
    } catch (e) {
      print("Error en NewsService: $e");
      return [];
    }
  }
}