import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/gender_radio.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
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
  Gender? gender;
  bool unknowBirthTime = false;
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final argument = Get.arguments;
  RxBool isLoading = false.obs;

  Future<void> register(BuildContext context) async {
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      isLoading.value = true;
      await createUserAppwrite();
      isLoading.value = false;
    }
  }

  Future<void> createUserAppwrite() async {
    // TODO: go to OTP when sucecess run function - sawanon:20240806
    logger.d("birthDate: $birthDate");
    if (birthDate == null) {
      Get.rawSnackbar(
        message: AppLocale.pleaseEnterBirthDate.getString(Get.context!),
      );
      return;
    }
    if (gender == null) {
      Get.rawSnackbar(
          message: AppLocale.pleaseChooseGender.getString(Get.context!));
      return;
    }
    await StorageController.to.clear();
    final phoneNumber = argument["phoneNumber"] as String;
    final appwriteController = AppWriteController.to;
    final email = '$phoneNumber@ckmail.com';
    final response = await appwriteController.signUp(
      email,
      firstName,
      lastName,
      email,
      phoneNumber,
      address,
      birthDate!,
      birthTime,
      gender!,
    );
    logger.d("response: $response");
    if (response == null) {
      Get.rawSnackbar(message: "sign up failed");
      return;
    }
    final token = await appwriteController.getToken(phoneNumber);
    logger.d("token: $token");
    if (token == null) {
      Get.rawSnackbar(message: "get token failed");
      return;
    }
    final session = await appwriteController.createSession(
        response.user.$id, response.secret);
    if (session == null) {
      Get.rawSnackbar(message: "create session failed");
      return;
    }
    await FirebaseMessagingController.to.getToken();
    logger.d("user: ${response.user.$id}");
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

  void changeGender(Gender gender) {
    this.gender = gender;
  }

  @override
  void onInit() {
    logger.d(argument["phoneNumber"]);
    super.onInit();
  }
}
