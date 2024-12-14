import 'dart:convert';
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
}
