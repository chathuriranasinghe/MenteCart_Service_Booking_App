import '../../../core/network/api_client.dart';

class ServiceRepository {
  static Future<Map<String, dynamic>> getServices({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
  }) async {
    final res = await ApiClient.dio.get('/services', queryParameters: {
      'page': page,
      'limit': limit,
      if (category != null) 'category': category,
      if (search != null) 'search': search,
    });
    return res.data['data'] as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getServiceById(String id) async {
    final res = await ApiClient.dio.get('/services/$id');
    return res.data['data'] as Map<String, dynamic>;
  }
}
