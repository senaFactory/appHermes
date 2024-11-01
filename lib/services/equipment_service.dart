import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';

class EquipmentService {
  final String virtualPort = UrlStorage().virtualPort;
  final String urlEquipment = UrlStorage().urlEquipment;
  final TokenStorage tokenStorage = TokenStorage();

  Future<void> addEquipment(Equipment equipment) async {
    final String baseUrl = '$virtualPort$urlEquipment';
    final url = Uri.parse('$baseUrl/add');

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

  Future<List<Equipment>> fetchEquipments(List<int> equipmentIds) async {
    var token = await tokenStorage.getToken();
    final String baseUrl = '$virtualPort$urlEquipment/by-id/';

    List<Equipment> equipmentList = [];

    try {
      for (int id in equipmentIds) {
        final response = await http.get(
          Uri.parse('$baseUrl$id'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonResponse = json.decode(response.body);

          for (final equipmentData in jsonResponse['data']) {
            equipmentList.add(Equipment(
              id: equipmentData['id'],
              brand: equipmentData['brand'] ?? 'N/A',
              serial: equipmentData['serial'] ?? 'N/A',
              model: equipmentData['model'] ?? 'N/A',
              color: equipmentData['color'] ?? 'N/A',
              state: equipmentData['state'] ?? false,
            ));
          }
        } else {
          print('Error fetching equipment with id: $id');
        }
      }
    } catch (e) {
      print(e);
    }
    return equipmentList;
  }
}
