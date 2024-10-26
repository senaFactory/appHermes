import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
}
