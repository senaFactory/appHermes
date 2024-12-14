import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();
  static const String _authTokenKey = 'authToken';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _authTokenKey, value: token);
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: _authTokenKey);
    return token;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _authTokenKey);
  }

  Future<Map<String, dynamic>> decodeJwtToken() async {
    try {
      String? token = await getToken();
      if (token == null) {
        throw Exception('No token found in storage');
      }
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken;
    } catch (e) {
      return {};
    }
  }

  Future<String?> getPrimaryRole() async {
    List<String> roles = await getRolesFromToken();

    // Filtrar roles importantes según tu lógica
    if (roles.contains('ROLE_SUPER ADMIN')) {
      return 'SUPER ADMIN';
    } else if (roles.contains('ROLE_ADMIN')) {
      return 'ADMIN';
    } else if (roles.contains('ROLE_COORDINADOR')) {
      return 'COORDINADOR';
    } else if (roles.contains('ROLE_INSTRUCTOR')) {
      return 'INSTRUCTOR';
    } else if (roles.contains('ROLE_APRENDIZ')) {
      return 'APRENDIZ';
    } else if (roles.contains('ROLE_SEGURIDAD')) {
      return 'SEGURIDAD';
    } else if (roles.contains('ROLE_INVITADO')) {
      return 'INVITADO';
    }

    return null;
  }

  Future<List<String>> getRolesFromToken() async {
    Map<String, dynamic> decodedToken = await decodeJwtToken();
    if (decodedToken.isNotEmpty && decodedToken.containsKey('authorities')) {
      // Verifica si 'authorities' es un String y luego lo divides por coma
      var authorities = decodedToken['authorities'];
      if (authorities is String) {
        return authorities.split(',').map((e) => e.trim()).toList();
      } else if (authorities is List) {
        return authorities.map((e) => e.toString()).toList();
      }
    }
    return [];
  }
}
