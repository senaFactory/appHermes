import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/features/auth/user.dart';
import 'package:maqueta/features/equipment/equipment.dart';
import 'package:maqueta/core/provider/token_storage.dart';
import 'package:maqueta/core/network/url_storage.dart';
import 'package:maqueta/features/equipment/equipment_service.dart';

class CardService {
  final String virtualPort = UrlStorage().virtualPort;
  final EquipmentService _equipmentService = EquipmentService();
  final TokenStorage tokenStorage = TokenStorage();
  final UrlStorage urlStorage = UrlStorage();

  Future<User?> getUser() async {
    try {
      // Obtén el token y decodifícalo para obtener el rol y el documento
      var token = await tokenStorage.getToken();

      if (token == null) {
        throw Exception('Token is null or expired');
      }

      // Usamos el TokenStorage para obtener el rol directamente
      var role = await tokenStorage.getPrimaryRole();

      if (role == null) {
        throw Exception('Role is not available in the token');
      }

      // Obtén el documento directamente desde el token (en este caso, 'sub' es el documento)
      var decodeToken = await tokenStorage.decodeJwtToken();
      var document = decodeToken['sub'];

      if (document == null) {
        throw Exception('Document is not available in the token');
      }

      // Usa el rol para obtener la URL adecuada
      final String url = urlStorage.getRoleUrl(role, document);

      // Realiza la petición al backend con el rol y documento
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      // Ver el cuerpo de la respuesta

      if (response.statusCode == 200) {
        // Intentar decodificar utilizando una limpieza adicional
        String body = utf8.decode(response.bodyBytes);
        final jsonResponse = json.decode(body) as Map<String, dynamic>;

        if (jsonResponse.isNotEmpty) {
          final userData = jsonResponse;

          // Verifica si 'equipments' es una lista antes de intentar mapearla
          if (userData['equipments'] != null &&
              userData['equipments'] is List) {
            List<int> equipmentIds =
                List<int>.from(userData['equipments'].map((e) => e['id']));

            // Obtén la lista de equipos asociados al usuario
            List<Equipment> equipmentList =
                await _equipmentService.fetchEquipments(equipmentIds);

            // Crea el objeto User a partir del json y usa copyWith
            User user = User.fromJson(userData);

            // Ahora puedes usar copyWith para agregar los equipos
            return user.copyWith(equipments: equipmentList);
          } else {
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
      throw Exception('Error getting user data');
    }
  }
}
