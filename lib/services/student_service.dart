import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maqueta/providers/url_storage.dart';

class StudentService {
  final String baseUrl = UrlStorage().virtualPort + UrlStorage().urlStudent;

  Future<void> sendImagePath(String imagePath, int document) async {
    final url = Uri.parse('$baseUrl/updatePhoto/$document');

    print('Enviando imagen a: $url');
    print('Ruta de la imagen: $imagePath');
    print('Documento del usuario: $document');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'imagePath': imagePath}),
    );

    
    print('Respuesta del servidor: ${response.body}');
    print('Código de estado: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception('Error al enviar la imagen: ${response.statusCode}');
    }
  }
}
