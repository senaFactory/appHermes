import 'dart:convert';
import 'package:maqueta/models/student.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';
import 'package:maqueta/services/network_service.dart';

class StudentService {
  final UrlStorage urlStorage = UrlStorage();
  final TokenStorage tokenStorage = TokenStorage();
  final NetworkService _networkService = NetworkService();

  // Mapa para convertir roles a los endpoints correctos
  final Map<String, String> roleEndpoints = {
    "APRENDIZ": "student",
    "COORDINADOR": "coordinator",
    "ADMIN": "admin",
    "SUPER ADMIN": "superAdmin", // Mantiene la A mayúscula
    "SEGURIDAD": "vigilant",
    "INVITADO": "guest",
    "INSTRUCTOR": "teacher",
    "ADMINISTRATIVO": "administrativo",
  };

  Future<void> sendImageBase64(String base64Image, int document) async {
    var token = await tokenStorage.getToken();

    try {
      await _networkService.makeRequest(
        '/api/api/v1/hermesapp/person/updatePhoto/$document',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: {
          "data": {
            "photo": base64Image,
          }
        },
      );
    } catch (e) {
      print('Error sending image: $e');
      throw Exception('Error al enviar la imagen: $e');
    }
  }

  Future<Student> getUserData() async {
    try {
      var token = await tokenStorage.getToken();
      if (token == null) throw Exception('Token is null or expired');

      var decodeToken = await tokenStorage.decodeJwtToken();
      var document = decodeToken['sub'];
      var role = await tokenStorage.getPrimaryRole();
      if (role == null) throw Exception('Role is not available in the token');

      // Usar el mapa para obtener el endpoint correcto
      final String roleEndpoint = roleEndpoints[role] ??
        'superAdmin'; // Valor por defecto si no se encuentra el rol

      if (!roleEndpoints.containsKey(role)) {
        print('Warning: Unknown role: $role, using default endpoint');
      }

      // Construir el endpoint completo con el formato correcto
      final String endpoint = '/api/api/v1/hermesapp/card/$roleEndpoint/$document';

      final response = await _networkService.makeRequest(
        endpoint,
        method: 'GET',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response != null && response is Map<String, dynamic>) {
        return Student(
          dateBirth: response['dateBirth'] ?? 'N/A',
          bloodType: response['bloodType']?.trim() ?? 'N/A',
          address: response['address'] ?? 'N/A',
        );
      } else {
        throw Exception('User data not available or invalid format');
      }
    } catch (e) {
      print('Error details in student service: $e');
      throw Exception('Error getting user data: $e');
    }
  }

  Future<void> updateStudentData(Student student, int document) async {
    try {
      var token = await tokenStorage.getToken();

      await _networkService.makeRequest(
        '/api/api/v1/hermesapp/person/updateCard/$document',
        method: 'PUT',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: {
          'data': {
            "date_birth": student.dateBirth,
            "blood_type": student.bloodType,
            "address": student.address,
          },
        },
      );
    } catch (e) {
      print('Error updating student data: $e');
      throw Exception('Error al actualizar los datos: $e');
    }
  }
}
