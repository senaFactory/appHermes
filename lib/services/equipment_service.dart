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

  Future<void> addEquipment(
      Equipment equipment, Future<Map<dynamic, dynamic>> token) async {
    var token = await tokenStorage.getToken();
    var decodeToken = await tokenStorage.decodeJwtToken();
    var document = decodeToken['sub'];

    final String baseUrl = '$virtualPort$urlEquipment';
    final url = Uri.parse('$baseUrl/add');

    try {
      equipment.setDocumentId = document;

      // Crea el objeto con 'data'
      final Map<String, dynamic> payload = {
        'data': equipment.toJson(),
      };

      print(payload);

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        print('Equipo registrado exitosamente');
      } else {
        print('Error en la respuesta del servidor: ${response.body}');
        throw Exception('Error al registrar el equipo: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception al registrar equipo: $e');
      rethrow;
    }
  }

  Future<List<Equipment>> fetchEquipments(List<int> equipmentIds) async {
    var token = await tokenStorage.getToken();
    final String baseUrl = '$virtualPort$urlEquipment/by-id/';

    List<Equipment> equipmentList = [];

    for (int id in equipmentIds) {
      final response = await http.get(
        Uri.parse('$baseUrl$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(response.body);

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
      } else {}
    }
    return equipmentList;
  }
}
