import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:maqueta/models/auth_login.dart';
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';

class AuthService with ChangeNotifier {
  final String virtualPort = UrlStorage().virtualPort;
  final String urlLogin = UrlStorage().urlLogin;
  final TokenStorage tokenStorage = TokenStorage();

  Future<AuthLogin> logIn(int document, String password) async {
    final String baseUrl = '$virtualPort$urlLogin';
    print('Intentando iniciar sesión en: $baseUrl');
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'document': document, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

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
