import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/jwt.dart';
import 'package:lottery_ck/utils.dart';

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

  Future<void> setAppToken(Map jwtData) async {
    await setValue("appToken", jsonEncode(jwtData));
  }

  Future<AppJWT?> getAppToken() async {
    final jwtData = await getValue("appToken");
    if (jwtData == null) return null;
    return AppJWT.fromJSON(jsonDecode(jwtData));
  }

  Future<void> setInvoiceMetaId(String invoiceMetaId) async {
    await setValue("invoiceMetaId", invoiceMetaId);
  }

  Future<String?> getInvoiceMetaId() async {
    return await getValue("invoiceMetaId");
  }

  Future<void> setLuckyNumber(String luckyNumber, DateTime randomDate) async {
    await setValue(
        "luckyNumber",
        jsonEncode({
          "luckyNumber": luckyNumber,
          "randomDate": randomDate.toIso8601String(),
        }));
  }

  Future<void> removeLuckyNumber() async {
    await clearValue("luckyNumber");
  }

  Future<Map?> getRandomLottery() async {
    try {
      final luckyNumber = await getValue("luckyNumber");
      if (luckyNumber == null) {
        throw "luckyNumber is empty";
      }
      return jsonDecode(luckyNumber);
    } catch (e) {
      logger.e("$e");
      return null;
    }
  }

  Future<void> setUnknowBirthTime(bool isUnknowBirthTime) async {
    await setValue("unknowBirthTime", isUnknowBirthTime.toString());
  }

  Future<String?> getUnknowBirthTime() async {
    return await getValue("unknowBirthTime");
  }

  Future<void> setPasscodeDelay(Map delayData) async {
    await setValue("passcodeDelay", jsonEncode(delayData));
  }

  Future<void> removePassCodeDelay() async {
    await clearValue("passcodeDelay");
  }

  Future<Map?> getPasscodeDelay() async {
    final passcodeDelay = await getValue("passcodeDelay");
    if (passcodeDelay == null) return null;
    return jsonDecode(passcodeDelay);
  }

  Future<void> setKYCLater() async {
    await setValue("kycLater", DateTime.now().toIso8601String());
  }

  Future<String?> getKYCLater() async {
    return await getValue("kycLater");
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
