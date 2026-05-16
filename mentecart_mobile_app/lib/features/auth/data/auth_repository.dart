import '../../../core/network/api_client.dart';
import '../../../core/services/auth_storage.dart';

class AuthRepository {
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await ApiClient.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    final token = res.data['data']['token'] as String;
    final user = res.data['data']['user'] as Map<String, dynamic>;
    await AuthStorage.saveToken(token);
    await AuthStorage.saveName(user['fullName'] as String? ?? '');
    return user;
  }

  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    final res = await ApiClient.dio.post('/auth/signup', data: {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
    });
    final token = res.data['data']['token'] as String;
    final user = res.data['data']['user'] as Map<String, dynamic>;
    await AuthStorage.saveToken(token);
    await AuthStorage.saveName(user['fullName'] as String? ?? '');
    return user;
  }

  static Future<void> logout() async {
    await AuthStorage.deleteToken();
    await AuthStorage.deleteName();
  }
}
