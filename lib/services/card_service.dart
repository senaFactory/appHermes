import 'dart:convert';
import 'package:maqueta/models/user.dart';
import 'package:maqueta/models/equipment.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';
import 'package:maqueta/services/equipment_service.dart';
import 'package:maqueta/services/network_service.dart';

class CardService {
  final UrlStorage urlStorage = UrlStorage();
  final EquipmentService _equipmentService = EquipmentService();
  final TokenStorage tokenStorage = TokenStorage();
  final NetworkService _networkService = NetworkService();

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

      // Obtén el documento directamente desde el token
      var decodeToken = await tokenStorage.decodeJwtToken();
      var document = decodeToken['sub'];

      if (document == null) {
        throw Exception('Document is not available in the token');
      }

      // Usa el rol para obtener la URL adecuada
      final String fullUrl = urlStorage.getRoleUrl(role, document);
      final Uri uri = Uri.parse(fullUrl);
      // Extraer el endpoint relativo (todo después del dominio)
      final String endpoint = uri.path + (uri.query.isEmpty ? '' : '?${uri.query}');

      // Realiza la petición al backend usando NetworkService
      final response = await _networkService.makeRequest(
        endpoint,
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response != null) {
        if (response is Map<String, dynamic> && response.isNotEmpty) {
          // Verifica si 'equipments' es una lista antes de intentar mapearla
          if (response['equipments'] != null && response['equipments'] is List) {
            List<int> equipmentIds = List<int>.from(response['equipments'].map((e) => e['id']));

            // Obtén la lista de equipos asociados al usuario
            List<Equipment> equipmentList = await _equipmentService.fetchEquipments(equipmentIds);

            // Crea el objeto User a partir del json y usa copyWith
            User user = User.fromJson(response);
            return user.copyWith(equipments: equipmentList);
          } else {
            // Si no hay equipos, podemos crear el usuario sin equipos
            User user = User.fromJson(response);
            return user.copyWith(equipments: []);
          }
        } else {
          throw Exception('User data not available');
        }
      } else {
        throw Exception('No response from server');
      }
    } catch (e) {
      print('Error details: $e');
      throw Exception('Error getting user data: $e');
    }
  }
}
