import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageController extends GetxController {
  static StorageController get to => Get.find();
  FlutterSecureStorage? storage;

  void test() async {
    final options = IOSOptions(
      accessibility: KeychainAccessibility.passcode,
    );
    await storage?.write(key: 'key', value: 'value', iOptions: options);
  }

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

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  IOSOptions _getIOSOptions() => const IOSOptions(
        accessibility: KeychainAccessibility.passcode,
      );

  @override
  void onInit() {
    storage = FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    );
    super.onInit();
  }
}
