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
      Equipment equipment, Map<dynamic, dynamic> token) async {
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

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        body: json.encode(payload),
      );

      if (response.statusCode != 200) {
      } else {
        throw Exception('Error al registrar el equipo: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Equipment>> fetchEquipments(List<int> equipmentIds) async {
    var token = await tokenStorage.getToken();
    final String baseUrl = '$virtualPort$urlEquipment/by-id/';
    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      var responses = await Future.wait(equipmentIds.map((id) {
        return http.get(Uri.parse('$baseUrl$id'), headers: headers);
      }));

      return responses
          .where((response) => response.statusCode == 200)
          .map((response) {
        var jsonResponse = json.decode(response.body);
        return Equipment.fromJson(jsonResponse['data']);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> editEquipment(Equipment equipment) async {
    var token = await tokenStorage.getToken();
    final String baseUrl = '$virtualPort$urlEquipment';
    final url = Uri.parse('$baseUrl/update/${equipment.id}');

    // Decodificar el token y obtener el documento asociado
    var decodeToken = await tokenStorage.decodeJwtToken();
    var document = decodeToken['sub'];
    equipment.setDocumentId = document;

    // Crear el payload con los datos del equipo
    final Map<String, dynamic> payload = {
      'data': equipment.toJson(),
    };

    // DEBUGGING: Imprimir información antes de enviar la solicitud
    print('--- DEBUGGING editEquipment ---');
    print('URL: $url');
    print('Token: $token');
    print('Decoded Document ID: $document');
    print('Payload: ${jsonEncode(payload)}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      // DEBUGGING: Imprimir información de la respuesta HTTP
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception(
            'Error al editar el equipo - Código: ${response.statusCode}');
      }

      print('Equipo editado correctamente');
    } catch (e) {
      // DEBUGGING: Capturar y mostrar el error
      print('Error durante editEquipment: $e');
      rethrow; // Re-lanza la excepción después de imprimirla
    }
  }

  Future<void> toggleEquipmentState(Equipment equipment) async {
    // Cambia el estado localmente (de activo a inactivo o viceversa)
    equipment.state = equipment.state == true ? false : true;

    // Realiza una actualización en el backend con el nuevo estado
    await editEquipment(equipment);
  }
}
