import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  // Getter to retrieve the token asynchronously
  Future<String?> get token async => await _secureStorage.read(key: _tokenKey);

  // Method to save the token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  // Method to remove the token
  Future<void> removeToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }
}
