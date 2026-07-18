import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<bool> checkAuth();
  Future<String> getToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const String _tokenKey = 'auth_token';
  static const String _emailKey = 'auth_email';
  static const String _testEmail = 'student@test.com';
  static const String _testPassword = '123456';
  static const String _fakeToken = 'fake_access_token_123456';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<UserModel> login(String email, String password) async {
    if (email != _testEmail || password != _testPassword) {
      throw Exception('Неверные учетные данные');
    }

    await secureStorage.write(key: _tokenKey, value: _fakeToken);
    await secureStorage.write(key: _emailKey, value: email);

    return UserModel(email: email, token: _fakeToken);
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: _tokenKey);
    await secureStorage.delete(key: _emailKey);
  }

  @override
  Future<bool> checkAuth() async {
    final token = await secureStorage.read(key: _tokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<String> getToken() async {
    final token = await secureStorage.read(key: _tokenKey);
    return token ?? '';
  }
}
