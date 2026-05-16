import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavoritesStorage {
  FavoritesStorage._();

  static const _storage = FlutterSecureStorage();
  static const _key = 'favorite_service_ids';

  static Future<List<String>> getIds() async {
    final val = await _storage.read(key: _key);
    if (val == null || val.isEmpty) return [];
    return val.split(',');
  }

  static Future<bool> isFavorite(String id) async {
    final ids = await getIds();
    return ids.contains(id);
  }

  static Future<void> toggle(String id) async {
    final ids = await getIds();
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    await _storage.write(key: _key, value: ids.join(','));
  }
}
