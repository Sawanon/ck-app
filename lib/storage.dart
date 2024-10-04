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

  Future<void> clear() async {
    await storage?.delete(key: "sessionId");
    await storage?.delete(key: "enableBio");
    // await storage?.deleteAll();
  }

  Future<void> setEnableBio() async {
    await setValue("enableBio", "true");
  }

  Future<void> setDisableBio() async {
    await setValue("enableBio", "false");
  }

  Future<bool> getEnableBio() async {
    final value = await getValue("enableBio");
    return value == "true";
  }

  Future<void> setSecretKey(String secret) async {
    await setValue("secretKey", secret);
  }

  Future<String?> getSecretKey() async {
    return await getValue("secretKey");
  }

  Future<void> setAppToken(String token) async {
    await setValue("appToken", token);
  }

  Future<String?> getAppToken() async {
    return await getValue("appToken");
  }

  Future<void> setInvoiceMetaId(String invoiceMetaId) async {
    await setValue("invoiceMetaId", invoiceMetaId);
  }

  Future<String?> getInvoiceMetaId() async {
    return await getValue("invoiceMetaId");
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
