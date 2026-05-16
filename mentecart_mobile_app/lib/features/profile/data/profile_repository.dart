import '../../../core/network/api_client.dart';

class ProfileRepository {
  static Future<Map<String, dynamic>> getProfile() async {
    final res = await ApiClient.dio.get('/profile');
    return res.data['data'] as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phoneNumber,
    Map<String, String>? address,
  }) async {
    final res = await ApiClient.dio.patch('/profile', data: {
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (address != null) 'address': address,
    });
    return res.data['data'] as Map<String, dynamic>;
  }
}
