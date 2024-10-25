import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/equipment.dart';

class EquipmentService {
  final String baseUrl = 'https://hhj97mdq-8081.use2.devtunnels.ms/api/v1/hermesapp/equipment/by-id/1';

  // Método para agregar equipo con manejo detallado de errores
  Future<void> addEquipment(Equipment equipment) async {
    final url = Uri.parse(baseUrl);
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(equipment.toJson()),
      );

      if (response.statusCode == 200) {
        print('Equipo registrado exitosamente');
      } else {
        // Imprimir la respuesta del servidor en caso de error
        print('Error en la respuesta del servidor: ${response.body}');
        throw Exception('Error al registrar el equipo: ${response.statusCode}');
      }
    } catch (e) {         
      print('Exception al registrar equipo: $e');
      rethrow; // Volver a lanzar la excepción para manejarla en otro nivel si es necesario
    }
  }

  // Método para obtener equipos por ID de persona con manejo de errores
  Future<List<Equipment>> getEquipmentsByPersonId(int personId) async {
    final url = Uri.parse('$baseUrl/all/$personId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((e) => Equipment.fromJson(e)).toList();
      } else {
        // Imprimir la respuesta del servidor en caso de error
        print('Error en la respuesta del servidor: ${response.body}');
        throw Exception('Error al obtener equipos: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception al obtener equipos: $e');
      rethrow; // Volver a lanzar la excepción para manejo superior
    }
  }
}
