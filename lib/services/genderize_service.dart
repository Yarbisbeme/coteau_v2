
import 'dart:convert';

import 'package:coteau_v2/core/constants.dart';
import 'package:coteau_v2/models/gender_model.dart';
import 'package:http/http.dart' as http;

class GenderService {

  Future<GenderModel> fetchGender(String name) async {
    try {
      final response = await http.get(Uri.parse('${AppConstants.genderizeBaseUrl}?name=$name'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return GenderModel.fromJson(data);
      } else {
        throw Exception('Ha Ocurrido un error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ocurrio en error en la conexion: $e'); 
    }
  }

}