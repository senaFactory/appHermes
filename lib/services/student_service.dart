import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/student.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';

class StudentService {
  final String baseUrl = UrlStorage().virtualPort + UrlStorage().urlStudent;
  final TokenStorage tokenStorage = TokenStorage();

  Future<void> sendImageBase64(String base64Image, int document) async {
    final url = Uri.parse('$baseUrl/updatePhoto/$document');
    var token = await tokenStorage.getToken();

    final body = jsonEncode({
      "data": {
        "photo": base64Image,
      }
    });

    print('Enviando imagen en formato Base64 al backend...');
    print('URL: $url');
    print('Authorization Token: Bearer $token');
    print('Cuerpo de la petición: $body');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print('Código de estado de la respuesta: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        print('Imagen subida correctamente.');
      } else {
        print(
            'Error al enviar la imagen. Código de estado: ${response.statusCode}');
        print('Mensaje de error del servidor: ${response.body}');
        throw Exception('Error al enviar la imagen: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al enviar la imagen: $e');
      throw Exception('Error al enviar la imagen: $e');
    }
  }
  
  Future<void> updateStudentData(Student student, int document) async {
    final url = Uri.parse('$baseUrl/updateMovil/$document'); // Ruta para actualización parcial
    var token = await tokenStorage.getToken();

    final body = jsonEncode({
      "date_birth": student.dateBirth, // Asegúrate de que esté en formato `YYYY-MM-DD`
      "blood_type": student.bloodType,
      "address": student.address,
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

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar los datos: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al actualizar los datos: $e');
    }
  }
}




