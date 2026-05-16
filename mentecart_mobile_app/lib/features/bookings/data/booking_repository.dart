import '../../../core/network/api_client.dart';

class BookingRepository {
  static Future<Map<String, dynamic>> checkout(String paymentMethod) async {
    final res = await ApiClient.dio.post('/bookings/checkout', data: {
      'paymentMethod': paymentMethod,
    });
    return res.data['data'] as Map<String, dynamic>;
  }

  static Future<List<dynamic>> getBookings() async {
    final res = await ApiClient.dio.get('/bookings');
    return res.data['data']['bookings'] as List<dynamic>;
  }

  static Future<Map<String, dynamic>> getBookingById(String id) async {
    final res = await ApiClient.dio.get('/bookings/$id');
    return res.data['data'] as Map<String, dynamic>;
  }

  static Future<void> cancelBooking(String id) async {
    await ApiClient.dio.post('/bookings/$id/cancel');
  }
}
