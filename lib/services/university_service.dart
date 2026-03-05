import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/university_model.dart';

class UniversityService {
  static const String _baseUrl = 'https://adamix.net/proxy.php';

  Future<List<UniversityModel>> getUniversitiesByCountry(String country) async {
    try {
      // Formateamos el país reemplazando espacios por '+' (ej. Dominican+Republic)
      final formattedCountry = country.trim().replaceAll(' ', '+');
      final response = await http.get(Uri.parse('$_baseUrl?country=$formattedCountry'));

      if (response.statusCode == 200) {
        // Decodificamos la respuesta como una Lista
        final List<dynamic> data = json.decode(response.body);
        
        // Mapeamos cada JSON de la lista a nuestro Modelo
        return data.map((json) => UniversityModel.fromJson(json)).toList();
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión. Verifica tu internet.');
    }
  }
}