import 'dart:developer' as developer;
import 'package:maqueta/providers/token_storage.dart';
import 'package:maqueta/providers/url_storage.dart';
import '../services/network_service.dart';

class AuthService {
  final UrlStorage urlStorage = UrlStorage();
  final TokenStorage tokenStorage = TokenStorage();
  final NetworkService networkService = NetworkService();

  /// Iniciar sesión y retornar el rol del usuario
  Future<String> logIn(int document, String password) async {
    try {
      developer.log(
        '🔐 Iniciando proceso de login',
        name: 'AuthService',
      );
      developer.log(
        '👤 Documento: $document',
        name: 'AuthService',
      );

      final response = await networkService.makeRequest(
        urlStorage.urlLogin,
        method: 'POST',
        body: {
          'document': document,
          'documentType': 'CC', // Agregando tipo de documento
          'password': password
        },
      );

      developer.log(
        '✅ Respuesta de login recibida',
        name: 'AuthService',
      );

      if (response['status'] == true) {
        final token = response['jwt'];

        if (token != null) {
          developer.log(
            '🎟️ Token recibido, guardando...',
            name: 'AuthService',
          );

          // Almacenar el token
          await tokenStorage.saveToken(token);

          // Obtener el rol principal del token
          final String? role = await tokenStorage.getPrimaryRole();

          if (role != null) {
            developer.log(
              '👑 Rol obtenido: $role',
              name: 'AuthService',
            );
            return role;
          } else {
            throw Exception('No se pudo determinar el rol del usuario.');
          }
        } else {
          throw Exception('El servidor no devolvió un token válido.');
        }
      } else {
        throw Exception(
            'Inicio de sesión fallido: ${response['message']}');
      }
    } catch (e) {
      developer.log(
        '❌ Error en login: $e',
        name: 'AuthService',
        error: e,
      );
      throw Exception('Error al iniciar sesión. Intente nuevamente.');
    }
  }

  Future<void> recoveryPassword(int document) async {
    try {
      developer.log(
        '🔄 Iniciando recuperación de contraseña',
        name: 'AuthService',
      );
      developer.log(
        '📝 Documento: $document',
        name: 'AuthService',
      );

      final url = 'api/api/v1/hermesapp/user/recoverPassword/$document';
      final body = {
        "data": {
          "link": "www.hermes.sena.edu.co/recoverPassword?document=$document"
        }
      };

      await networkService.makeRequest(
        url,
        method: 'POST',
        body: body,
      );

      developer.log(
        '✅ Recuperación de contraseña iniciada exitosamente',
        name: 'AuthService',
      );
    } catch (e) {
      developer.log(
        '❌ Error en recuperación de contraseña: $e',
        name: 'AuthService',
        error: e,
      );
      throw Exception('Error durante la recuperación de contraseña: $e');
    }
  }
}
