import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:intl/intl.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';

class CommonFn {
  static String parseDMY(DateTime datetime) {
    final parseTimeZome = datetime.toLocal();
    return "${parseTimeZome.day.toString().padLeft(2, '0')}-${parseTimeZome.month.toString().padLeft(2, '0')}-${datetime.year}";
  }

  static String parseYMD(DateTime datetime) {
    return "${datetime.year}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}";
  }

  static String parseHMS(DateTime datetime) {
    return "${datetime.hour.toString().padLeft(2, "0")}:${datetime.minute.toString().padLeft(2, "0")}:${datetime.second.toString().padLeft(2, "0")}";
  }

  static String parseTimeOfDayToHMS(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  static int calculateTotalPrice(List<Lottery> lotteryList) {
    return lotteryList.fold(
        0, (previousValue, element) => previousValue + element.amount);
  }

  static String parseMoney(int money) {
    try {
      final formatter = NumberFormat('#,###,###');
      return formatter.format(money);
    } catch (e) {
      return "invalid type (int)";
    }
  }

  static Future<bool> canAuthenticate() async {
    final auth = LocalAuthentication();
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    logger.d("canAuthenticateWithBiometrics: $canAuthenticateWithBiometrics");

    final canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    return canAuthenticate;
  }

  static Future<bool> enableBiometrics() async {
    try {
      final isSupport = await canAuthenticate();
      if (isSupport) {
        final authenticated = await LocalAuthentication().authenticate(
          localizedReason:
              'Scan your fingerprint (or face or whatever) to authenticate',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
            sensitiveTransaction: false,
          ),
        );
        if (authenticated) {
          await StorageController.to.setEnableBio();
        }
        return authenticated;
      }
      return false;
    } catch (e) {
      logger.e("$e");
      return false;
    }
  }

  static Future<bool> requestBiometrics() async {
    try {
      final isSupport = await canAuthenticate();
      final enableBiometrics = await StorageController.to.getEnableBio();
      logger.d("enableBiometrics: $enableBiometrics");
      if (isSupport && enableBiometrics) {
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

  static String parseCollectionToDate(String ymd) {
    final dateStrYMD = ymd.split("_").first;
    final dateStr =
        "${dateStrYMD.substring(6, 8)}-${dateStrYMD.substring(4, 6)}-${dateStrYMD.substring(0, 4)}";
    return dateStr;
  }

  static String parseLotteryDateCollection(DateTime datetime) {
    return parseYMD(datetime).split("-").join("");
  }

  static String renderBillStatus(String billStatus, BuildContext context) {
    switch (billStatus.toLowerCase()) {
      case 'pending':
        return AppLocale.unpaid.getString(context);
      case 'paid':
        return AppLocale.paid.getString(context);
      default:
        return '';
    }
  }
}
