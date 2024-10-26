import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/auth_login.dart';
import 'package:maqueta/providers/token_storage.dart'; // Asegúrate de que la ruta sea correcta

class AuthService with ChangeNotifier {
  final String baseUrl =
      'https://120fh0nk-8081.use2.devtunnels.ms/api/v1/hermesapp/auth/login';
  final TokenStorage tokenStorage = TokenStorage();

  Future<AuthLogin> logIn(int document, String password) async {
    //final url = Uri.parse(baseUrl);

    try {
      final response = await http.post(
        Uri.parse('https://hhj97mdq-8081.use2.devtunnels.ms/api/v1/hermesapp/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'document': document, 
          'password': password
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Response from backend: $jsonResponse');

        if (jsonResponse['status'] == true) {
          final token = jsonResponse['jwt'];
          await tokenStorage.saveToken(token);
          return AuthLogin(
              document: jsonResponse['document'],
              password: jsonResponse['jwt']);
        } else {
          throw Exception('Login failed: ${jsonResponse['message']}');
        }
      } else {
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('Error logging in: $e');
      throw Exception('Error al iniciar sesión');
    }
  }
}
