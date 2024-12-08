import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/user.dart';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';
import 'package:maqueta/services/equipment_service.dart';

class CardService {
  final String virtualPort = UrlStorage().virtualPort;
  final EquipmentService _equipmentService = EquipmentService();
  final TokenStorage tokenStorage = TokenStorage();
  final UrlStorage urlStorage = UrlStorage();

  Future<User?> getUser() async {
    try {
      // Obtén el token y decodifícalo para obtener el rol y el documento
      var token = await tokenStorage.getToken();
      print('[DEBUG] Token: $token'); // Ver el token

      if (token == null) {
        throw Exception('Token is null or expired');
      }

      // Usamos el TokenStorage para obtener el rol directamente
      var role = await tokenStorage.getPrimaryRole();
      print('[DEBUG] Role: $role'); // Ver el rol

      if (role == null) {
        throw Exception('Role is not available in the token');
      }

      // Obtén el documento directamente desde el token (en este caso, 'sub' es el documento)
      var decodeToken = await tokenStorage.decodeJwtToken();
      var document = decodeToken['sub'];
      print('[DEBUG] Document: $document'); // Ver el documento

      if (document == null) {
        throw Exception('Document is not available in the token');
      }

      // Usa el rol para obtener la URL adecuada
      final String url = urlStorage.getRoleUrl(role, document);
      print('[DEBUG] Request URL: $url'); // Ver la URL de la petición

      // Realiza la petición al backend con el rol y documento
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print(
          '[DEBUG] Response Status: ${response.statusCode}'); // Ver el estado de la respuesta
      print(
          '[DEBUG] Response Body: ${response.body}'); // Ver el cuerpo de la respuesta

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print(
            '[DEBUG] Decoded JSON Response: $jsonResponse'); // Ver la respuesta JSON decodificada

        if (jsonResponse.isNotEmpty) {
          final userData = jsonResponse;

          // Verifica si 'equipments' es una lista antes de intentar mapearla
          if (userData['equipments'] != null &&
              userData['equipments'] is List) {
            List<int> equipmentIds =
                List<int>.from(userData['equipments'].map((e) => e['id']));
            print(
                '[DEBUG] Equipment IDs: $equipmentIds'); // Ver los IDs de los equipos

            // Obtén la lista de equipos asociados al usuario
            List<Equipment> equipmentList =
                await _equipmentService.fetchEquipments(equipmentIds);
            print(
                '[DEBUG] Equipment List: $equipmentList'); // Ver la lista de equipos

            // Crea el objeto User a partir del json y usa copyWith
            User user = User.fromJson(userData);
            print('[DEBUG] User Created: $user'); // Ver el objeto User creado

            // Ahora puedes usar copyWith para agregar los equipos
            return user.copyWith(equipments: equipmentList);
          } else {
            print('[DEBUG] Equipments field is null or not a list');
            // Si no hay equipos, podemos crear el usuario sin equipos
            User user = User.fromJson(userData);
            return user.copyWith(equipments: []);
          }
        } else {
          throw Exception('User data not available');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('[ERROR] Error: $e'); // Ver el error
      throw Exception('Error getting user data: $e');
    }
  }
}
