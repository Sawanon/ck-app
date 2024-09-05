import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:intl/intl.dart';
import 'package:lottery_ck/utils.dart';

class CommonFn {
  static String parseDMY(DateTime datetime) {
    return "${datetime.day.toString().padLeft(2, '0')}-${datetime.month.toString().padLeft(2, '0')}-${datetime.year}";
  }

  static String parseYMD(DateTime datetime) {
    return "${datetime.year}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}";
  }

  static String parseHMS(DateTime datetime) {
    return "${datetime.hour.toString().padLeft(2, "0")}:${datetime.minute.toString().padLeft(2, "0")}:${datetime.second.toString().padLeft(2, "0")}";
  }

  static int calculateTotalPrice(List<Lottery> lotteryList) {
    return lotteryList.fold(
        0, (previousValue, element) => previousValue + element.price);
  }

  static String parseMoney(int money) {
    try {
      final formatter = NumberFormat('#,###,000');
      return formatter.format(money);
    } catch (e) {
      return "invalid type (int)";
    }
  }

  static Future<bool> _canAuthenticate() async {
    final auth = LocalAuthentication();
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    logger.d("canAuthenticateWithBiometrics: $canAuthenticateWithBiometrics");
    final canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
  }

  static Future<bool> requestBiometrics() async {
    try {
      final canAuthenticate = await _canAuthenticate();
      if (canAuthenticate) {
        final authenticated = await LocalAuthentication().authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
            sensitiveTransaction: false,
          ),
        );
        return authenticated;
      }
      return false;
    } catch (e) {
      logger.e("$e");
      return false;
    }
  }

  static Future<bool> availableBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    logger.d(
        "availableBiometrics.contains(BiometricType.weak); ${availableBiometrics.contains(BiometricType.weak)}");
    logger.d(
        "availableBiometrics.contains(BiometricType.strong) ${availableBiometrics.contains(BiometricType.strong)}");
    if (availableBiometrics.contains(BiometricType.weak) ||
        availableBiometrics.contains(BiometricType.strong)) {
      return true;
    }
    if (availableBiometrics.contains(BiometricType.fingerprint) ||
        availableBiometrics.contains(BiometricType.face)) {
      return true;
    }
    return false;
  }

  static parseCollectionToDate(String ymd) {
    final dateStrYMD = ymd.split("_").first;
    final dateStr =
        "${dateStrYMD.substring(6, 8)}-${dateStrYMD.substring(4, 6)}-${dateStrYMD.substring(0, 4)}";
    return dateStr;
  }
}
