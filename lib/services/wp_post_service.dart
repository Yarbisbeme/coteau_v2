import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/wp_post_model.dart';

class NewsService {
  
  // 1. Quitamos la palabra "URL: " del string
  // Usamos el proxy AllOrigins con el parámetro "raw" para que nos devuelva el JSON limpio
  final String _baseUrl = "url=https://pokemonblog.com/wp-json/wp/v2/posts?_embed";

  Future<List<WpPost>> fetchPosts() async {
    try {
      // 2. Quitamos las comillas alrededor de la variable _baseUrl
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => WpPost.fromJson(item)).toList();
      } else {
        print("El servidor rechazó la conexión con el código: ${response.statusCode}"); 
        throw Exception("Fallo al conectar con la API de noticias");
      }
    } catch (e) {
      print("Error en NewsService: $e");
      return [];
    }
  }
}