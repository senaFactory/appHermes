import 'dart:convert';

import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';
import 'package:http/http.dart' as http;

class StudentService {
  final String virtualPort = UrlStorage().virtualPort;
  final String urlStudent = UrlStorage().urlStudent;
  final TokenStorage tokenStorage = TokenStorage();

  Future<void> sendImage(String base64Image) async {
    var token = await tokenStorage.getToken();
    var decodeToken = await tokenStorage.decodeJwtToken();
    final document = decodeToken['sub'];

    print(base64Image);

    final String baseUrl = '$virtualPort$urlStudent';
    final url = Uri.parse('$baseUrl/updatePhoto/$document');

    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'document': document,
        'photo': base64Image,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al enviar la imagen: ${response.statusCode}');
    }
  }
}
