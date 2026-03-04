import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<PokemonModel> getPokemon(String name) async {
    try {
      // Pasamos a minúsculas porque la API es estricta con eso
      final response = await http.get(Uri.parse('$_baseUrl/${name.toLowerCase().trim()}'));

      if (response.statusCode == 200) {
        return PokemonModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pokémon no encontrado. Intenta con "pikachu" o "charizard".');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Pokémon no encontrado')) rethrow;
      throw Exception('Error de conexión. Verifica tu internet.');
    }
  }
}