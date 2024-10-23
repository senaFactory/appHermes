import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/equipment.dart';

class EquipmentService {
  final String baseUrl =
      'https://hhj97mdq-8081.use2.devtunnels.ms/api/v1/hermesapp/equipment';

  // Obtener todos los equipos
  Future<List<Equipment>> getAllEquipments() async {
    final url = Uri.parse('$baseUrl/all');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Equipments: $jsonResponse');

        final List<dynamic> data = jsonResponse['data'];
        return data.map((e) => Equipment.fromJson(e)).toList();
      } else {
        throw Exception('Error al obtener equipos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching equipments: $e');
      rethrow;
    }
  }

  // Agregar un equipo
  // Agregar un equipo con datos anidados en "data"
  Future<void> addEquipment(Equipment equipment) async {
    final url = Uri.parse('$baseUrl/add');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "data": equipment.toJson(), // Enviar los datos bajo la clave "data"
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Error al agregar equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding equipment: $e');
      rethrow;
    }
  }
}



