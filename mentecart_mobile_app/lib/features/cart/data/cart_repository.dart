import '../../../core/network/api_client.dart';

class CartRepository {
  static Future<Map<String, dynamic>> getCart() async {
    final res = await ApiClient.dio.get('/cart');
    return res.data['data'] as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> addItem({
    required String serviceId,
    required String selectedDate,
    required String selectedTime,
    int quantity = 1,
  }) async {
    final res = await ApiClient.dio.post('/cart/items', data: {
      'serviceId': serviceId,
      'selectedDate': selectedDate,
      'selectedTime': selectedTime,
      'quantity': quantity,
    });
    return res.data['data'] as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> updateItem(
    String itemId, {
    String? selectedDate,
    String? selectedTime,
    int? quantity,
  }) async {
    final res = await ApiClient.dio.patch('/cart/items/$itemId', data: {
      if (selectedDate != null) 'selectedDate': selectedDate,
      if (selectedTime != null) 'selectedTime': selectedTime,
      if (quantity != null) 'quantity': quantity,
    });
    return res.data['data'] as Map<String, dynamic>;
  }

  static Future<void> removeItem(String itemId) async {
    await ApiClient.dio.delete('/cart/items/$itemId');
  }
}
