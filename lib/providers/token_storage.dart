import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenStorage {
  // Create storage
  final _storage = const FlutterSecureStorage();

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }

  // Retrieve token
  Future<String?> getToken() async {    
    return await _storage.read(key: 'authToken');
  }

  // Delete token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'authToken');
  }

  // Decodificar token JWT como Future
  Future<Map<String, dynamic>> decodeJwtToken() async {
    try {
      // Recuperar token del almacenamiento seguro
      String? token = await getToken();

      if (token == null) {
        throw Exception('No se encontró ningún token.');
      }

      // Decodificar el token
      
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken;

    } catch (e) {
      print('Error al decodificar el token: $e');
      return {}; // Retorna un Map vacío si hay error
    }
  }
}

