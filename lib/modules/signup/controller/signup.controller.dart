import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/modules/login/controller/login.controller.dart';
import 'package:lottery_ck/repository/user_repository/user.repository.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class SignupController extends GetxController {
  String firstName = '';
  String lastName = '';
  String address = '';
  DateTime? birthDate;
  TimeOfDay? birthTime;
  bool unknowBirthTime = false;
  // TimeOfDay?
  // String phone = '';
  // String password = '';
  // String confirmPassword = '';
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final argument = Get.arguments;

  Future<void> register(BuildContext context) async {
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      if (!unknowBirthTime && birthTime == null) {
        Get.rawSnackbar(
          backgroundColor: Colors.amber.shade200,
          overlayColor: Colors.black.withOpacity(0.8),
          messageText: Text(
            AppLocale.pleaseEnterBirthTime.getString(context),
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        return;
      }
      createUserAppwrite();
    }
  }

  Future<void> createUserAppwrite() async {
    // TODO: go to OTP when sucecess run function - sawanon:20240806
    logger.d("birthDate: $birthDate");
    if (birthDate == null) {
      // Get.rawSnackbar(
      //   message: "Please select your birth date",
      // );
      return;
    }
    await StorageController.to.clear();
    final phoneNumber = argument["phoneNumber"] as String;
    final appwriteController = AppWriteController.to;
    final email = '$phoneNumber@ckmail.com';
    final user = await appwriteController.signUp(
      email,
      firstName,
      lastName,
      email,
      phoneNumber,
      address,
      birthDate!,
      birthTime,
    );
    if (user == null) {
      Get.rawSnackbar(message: "sign up failed");
      return;
    }
    final token = await appwriteController.getToken(phoneNumber);
    logger.d("token: $token");
    if (token == null) {
      Get.rawSnackbar(message: "get token failed");
      return;
    }
    final session = await appwriteController.createSession(token);
    if (session == null) {
      Get.rawSnackbar(message: "create session failed");
      return;
    }
    await FirebaseMessagingController.to.getToken();
    logger.d("user: ${user?.$id}");
    // if (user != null) {
    Get.delete<UserStore>();
    Get.toNamed(
      RouteName.pin,
      arguments: {
        'whenSuccess': () async {
          // await CommonFn.requestBiometrics();
          final availableBiometrics = await CommonFn.availableBiometrics();
          logger.d("availableBiometrics: $availableBiometrics");
          if (availableBiometrics) {
            Get.toNamed(RouteName.enableBiometrics, arguments: {
              "whenSuccess": () async {
                Get.delete<UserStore>();
                Get.offAllNamed(RouteName.layout);
              }
            });
            return;
          }
          // Get.delete<BuyLotteryController>();
          Get.delete<UserStore>();
          Get.offAllNamed(RouteName.layout);
        }
      },
    );
    return;
    // }
  }

  void changeBirthDate(DateTime? datetime) {
    if (datetime == null) return;
    birthDate = datetime;
    update();
  }

  void changeBirthTime(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return;
    birthTime = timeOfDay;
    update();
  }

  void changeUnknownBirthTime(bool unknown) {
    logger.d('unknown: $unknown');
    unknowBirthTime = unknown;
    update();
  }

  @override
  void onInit() {
    logger.d(argument["phoneNumber"]);
    super.onInit();
  }
}
