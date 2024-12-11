import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';

class AuthService {
  final String virtualPort = UrlStorage().virtualPort;
  final String urlLogin = UrlStorage().urlLogin;
  final TokenStorage tokenStorage = TokenStorage();

  /// Iniciar sesión y retornar el rol del usuario
  Future<String> logIn(int document, String password) async {
    final String baseUrl = '$virtualPort$urlLogin';

    // Debug: Información sobre el intento de login
    debugPrint('Intentando iniciar sesión en: $baseUrl');
    debugPrint('Documento enviado: $document');
    debugPrint('Contraseña: ${'*' * password.length}'); // Oculta la contraseña

    try {
      // Realizar la solicitud HTTP POST
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      // Depuración de la respuesta
      debugPrint('Estado de la respuesta: ${response.statusCode}');
      debugPrint('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('[DEBUG] Respuesta decodificada: $jsonResponse');

        if (jsonResponse['status'] == true) {
          final token = jsonResponse['jwt'];

          if (token != null) {
            // Almacenar el token
            await tokenStorage.saveToken(token);
            debugPrint('Token JWT almacenado correctamente.');

            // Obtener el rol principal del token
            final String? role = await tokenStorage.getPrimaryRole();
            if (role != null) {
              debugPrint('Rol principal del usuario: $role');
              return role;
            } else {
              throw Exception('No se pudo determinar el rol del usuario.');
            }
          } else {
            throw Exception('El servidor no devolvió un token válido.');
          }
        } else {
          // Manejar error de autenticación
          debugPrint(
              'Error en el login: ${jsonResponse['message'] ?? 'Mensaje no disponible'}');
          throw Exception(
              'Inicio de sesión fallido: ${jsonResponse['message']}');
        }
      } else {
        // Manejar errores del servidor
        debugPrint(
            'Error del servidor. Código de estado: ${response.statusCode}');
        throw Exception('Error en el servidor: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar excepciones
      debugPrint('Excepción capturada al intentar iniciar sesión: $e');
      throw Exception('Error al iniciar sesión. Intente nuevamente.');
    }
  }
}
