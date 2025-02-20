import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/features/profile/student.dart';
import 'package:maqueta/core/provider/token_storage.dart';
import 'package:maqueta/core/network/url_storage.dart';

class StudentService {
  final String baseUrl = UrlStorage().virtualPort + UrlStorage().urlStudent;
  final String baseUrlPerson =
      UrlStorage().virtualPort + UrlStorage().urlPerson;
  final TokenStorage tokenStorage = TokenStorage();
  final UrlStorage urlStorage = UrlStorage();

  Future<void> sendImageBase64(String base64Image, int document) async {
    final url = Uri.parse('$baseUrlPerson/updatePhoto/$document');
    var token = await tokenStorage.getToken();

    final body = jsonEncode({
      "data": {
        "photo": base64Image,
      }
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
      } else {
        throw Exception('Error al enviar la imagen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al enviar la imagen');
    }
  }

  Future<Student> getUserData() async {
    try {
      // Decodificar el token para obtener el rol y el documento
      var token = await tokenStorage.getToken();
      if (token == null) throw Exception('Token is null or expired');

      var decodeToken = await tokenStorage.decodeJwtToken();
      var document = decodeToken['sub'];
      var role = await tokenStorage.getPrimaryRole();
      if (role == null) throw Exception('Role is not available in the token');

      // Obtener la URL específica según el rol
      final String url = urlStorage.getRoleUrl(role, document);

      // Realizar la solicitud HTTP
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          // Solo retornamos `dateBirth`, `bloodType` y `address`
          return Student(
            dateBirth: jsonResponse['dateBirth'] ?? 'N/A',
            bloodType: jsonResponse['bloodType']?.trim() ?? 'N/A',
            address: jsonResponse['address'] ?? 'N/A',
          );
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

  Future<void> updateStudentData(Student student, int document) async {
    final url = Uri.parse(
        '$baseUrlPerson/updateCard/$document'); // Ruta para actualización parcial
    var token = await tokenStorage.getToken();

    // Creamos el payload directamente como un objeto JSON en lugar de una cadena JSON anidada
    final Map<String, dynamic> payload = {
      'data': {
        "date_birth":
            student.dateBirth, // Asegúrate de que esté en formato `YYYY-MM-DD`
        "blood_type": student.bloodType,
        "address": student.address,
      },
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body:
            jsonEncode(payload), // Convertimos el payload completo a JSON aquí
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar los datos: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al actualizar los datos');
    }
  }
}
