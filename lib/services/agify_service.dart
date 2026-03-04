import 'dart:convert';
import 'package:coteau_v2/core/constants.dart';
import 'package:http/http.dart' as http;
import '../models/age_model.dart';

class AgeService {

  Future<AgeModel> predictAge(String name) async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.agifyBaseUrl}?name=$name'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AgeModel.fromJson(data);
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión. Verifica tu internet.');
    }
  }
}