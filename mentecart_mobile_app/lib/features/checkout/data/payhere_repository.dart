import '../../../core/network/api_client.dart';

class PayhereRepository {
  static Future<Map<String, dynamic>> getCheckoutParams(
    String bookingNumber,
  ) async {
    final res = await ApiClient.dio.get(
      '/payhere/hash',
      queryParameters: {'bookingNumber': bookingNumber},
    );
    return res.data['data'] as Map<String, dynamic>;
  }
}
