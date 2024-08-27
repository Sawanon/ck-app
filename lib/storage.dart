import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageController extends GetxController {
  static StorageController get to => Get.find();
  FlutterSecureStorage? storage;

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  IOSOptions _getIOSOptions() => const IOSOptions(
        accessibility: KeychainAccessibility.passcode,
      );

  Future<void> setValue(String key, String value) async {
    await storage?.write(
      key: key,
      value: value,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<String?> getValue(String key) async {
    final value = await storage?.read(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
    return value;
  }

  Future<void> clearValue(String key) async {
    await storage?.delete(
      key: key,
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> removeAll() async {
    await storage?.deleteAll();
  }

  Future<void> setSessionId(String sessionId) async {
    await setValue("sessionId", sessionId);
  }

  Future<String?> getSessionId() async {
    final value = await getValue('sessionId');
    return value;
  }

  Future<void> clearSessionId() async {
    await clearValue("sessionId");
  }

  Future<void> setUserId(String userId) async {
    await setValue("userId", userId);
  }

  Future<String?> getUserId() async {
    return await getValue("userId");
  }

  @override
  void onInit() {
    storage = FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
    super.onInit();
  }
}
