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

  /// Obtiene todos los roles desde el token
  Future<List<String>> getRolesFromToken() async {
    Map<String, dynamic> decodedToken = await decodeJwtToken();
    if (decodedToken.isNotEmpty && decodedToken.containsKey('authorities')) {
      var authorities = decodedToken['authorities'];
      if (authorities is String) {
        return authorities.split(',').map((e) => e.trim()).toList();
      } else if (authorities is List) {
        return authorities.map((e) => e.toString()).toList();
      }
    }
    return [];
  }

  /// Obtiene el rol principal de acuerdo con la jerarquía definida
  Future<String?> getPrimaryRole() async {
    List<String> roles = await getRolesFromToken();
    return _determineHighestPriorityRole(roles);
  }

  /// Determina el rol con mayor jerarquía en función de la lista de roles del usuario
  Future<String?> getHighestPriorityRole() async {
    List<String> roles = await getRolesFromToken();
    return _determineHighestPriorityRole(roles);
  }

  /// Determina la jerarquía de los roles según la importancia definida
  String? _determineHighestPriorityRole(List<String> roles) {
    // Lista de roles en orden de jerarquía (de mayor a menor)
    const List<String> roleHierarchy = [
      'ROLE_SUPER ADMIN',
      'ROLE_ADMIN',
      'ROLE_COORDINADOR',
      'ROLE_ADMINISTRATIVO',
      'ROLE_SEGURIDAD',
      'ROLE_INSTRUCTOR',
      'ROLE_APRENDIZ',
      'ROLE_INVITADO',
    ];

    for (String role in roleHierarchy) {
      if (roles.contains(role)) {
        return _formatRole(role);
      }
    }

    return null; // Si no encuentra ningún rol importante
  }

  /// Convierte la forma 'ROLE_SUPER ADMIN' a 'SUPER ADMIN'
  String _formatRole(String role) {
    return role.replaceAll('ROLE_', '').trim();
  }
}
