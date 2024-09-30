import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServiceSecureStorage {
  static FlutterSecureStorage? storage;

  static init() async {
    storage = const FlutterSecureStorage();
  }

  static Future<void> saveData({
    required String key,
    required String value,
  }) async {
    if (storage == null) return;

    await storage!.write(key: key, value: value);
  }

  static Future<String?> getData({required String key}) async {
    if (storage == null) return "";

    return await storage!.read(key: key);
  }

  static Future<Map<String, String>> readAll() async {
    if (storage == null) return {};

    return await storage!.readAll();
  }

  static Future<void> removeData({
    required String key,
  }) async {
    if (storage == null) return;

    await storage!.delete(key: key);
  }

  static Future<void> removeAllData() async {
    if (storage == null) return;

    await storage!.deleteAll();
  }
}
