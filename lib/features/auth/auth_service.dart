import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:maqueta/core/provider/token_storage.dart';
import 'package:maqueta/core/network/url_storage.dart';

class AuthService {
  final String virtualPort = UrlStorage().virtualPort;
  final String urlLogin = UrlStorage().urlLogin;
  final String urlUser = UrlStorage().urlUser;
  final TokenStorage tokenStorage = TokenStorage();

  /// Iniciar sesión y retornar el rol del usuario
  Future<String> logIn(int document, String password) async {
    final String baseUrl = '$virtualPort$urlLogin';

    try {
      // Realizar la solicitud HTTP POST
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'document': document, 'password': password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final token = jsonResponse['jwt'];

          if (token != null) {
            // Almacenar el token
            await tokenStorage.saveToken(token);
            // Obtener el rol principal del token
            final String? role = await tokenStorage.getPrimaryRole();
            if (role != null) {
              return role;
            } else {
              throw Exception('No se pudo determinar el rol del usuario.');
            }
          } else {
            throw Exception('El servidor no devolvió un token válido.');
          }
        } else {
          throw Exception(
              'Inicio de sesión fallido: ${jsonResponse['message']}');
        }
      } else {
        // Manejar errores del servidor

        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar excepciones
      throw Exception('Error al iniciar sesión. Intente nuevamente.');
    }
  }

  Future<void> recoveryPassword(int document) async {
    final String url = '$virtualPort$urlUser/recoverPassword/$document';

    // Cuerpo de la solicitud con el número de documento
    final body = jsonEncode({
      "data": {
        "link":
            "www.hermes.sena.edu.co/recoverPassword?document=$document" //Cambiar por la URL del front desplegado
      }
    });

    try {
      // Debug: Imprimir URL, encabezados y cuerpo de la petición
      debugPrint('Making POST request to URL: $url');
      debugPrint('Request Body: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode != 200) {
        // Acción en caso de no éxito
        throw Exception('Failed to recover password');
      }
    } catch (e) {
      // Relanzar el error
      throw Exception('Error during password recovery: $e');
    }
  }
}
