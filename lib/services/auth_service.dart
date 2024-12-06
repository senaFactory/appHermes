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
    print('[DEBUG] Intentando iniciar sesión en: $baseUrl');

    try {
      // Construir el cuerpo de la solicitud
      final Map<String, dynamic> requestBody = {
        'document': document,
        'password': password,
      };
      print('[DEBUG] Cuerpo de la solicitud: $requestBody');

      // Enviar la solicitud
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      // Imprimir código de estado y cuerpo de la respuesta
      print('[DEBUG] Código de estado: ${response.statusCode}');
      print('[DEBUG] Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('[DEBUG] Respuesta decodificada: $jsonResponse');

        if (jsonResponse['status'] == true) {
          final token = jsonResponse['jwt'];
          print('[DEBUG] Token recibido: $token');

          await tokenStorage.saveToken(token);

          return AuthLogin(
            role: jsonResponse['roles'] != null
                ? jsonResponse['roles'][0]
                : 'Desconocido',
            document: document,
            password: token,
          );
        } else {
          throw Exception('[DEBUG] Login fallido: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            '[DEBUG] Error en el servidor: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('[DEBUG] Error logging in: $e');
      throw Exception('[DEBUG] Error al iniciar sesión: $e');
    }
  }
}
