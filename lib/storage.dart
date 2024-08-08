import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageController extends GetxController {
  FlutterSecureStorage? storage;

  void test() async {
    final options = IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    );
    await storage?.write(key: 'key', value: 'value', iOptions: options);
  }

  @override
  void onInit() {
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    super.onInit();
  }
}
