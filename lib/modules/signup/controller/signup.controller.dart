import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/login/controller/login.controller.dart';
import 'package:lottery_ck/repository/user_repository/user.repository.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class SignupController extends GetxController {
  String firstName = '';
  String lastName = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final argument = Get.arguments;

  Future<void> register() async {
    logger.d("phoneNumber: ${argument["phoneNumber"]}");
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      createUserAppwrite();
      // Get.toNamed(RouteName.otp, arguments: {
      //   "whenSuccess": () {
      //     logger.d("otp success !");
      //     createUserAppwrite();
      //   },
      //   "phoneNumber": phone,
      // });
    }
  }

  Future<void> createUserAppwrite() async {
    // TODO: go to OTP when sucecess run function - sawanon:20240806
    final phoneNumber = argument["phoneNumber"] as String;
    final appwriteController = AppWriteController.to;
    final multiplier =
        (int.parse(phoneNumber.substring(phoneNumber.length - 1)) *
                int.parse(phoneNumber.substring(
                    phoneNumber.length - 3, phoneNumber.length - 2)))
            .toString();
    final lastPhone = multiplier.substring(multiplier.length - 1);
    final password =
        '${phoneNumber.substring(0, 4)}$lastPhone${phoneNumber.substring(4)}';
    final email = '$phoneNumber@ckmail.com';
    final user = await appwriteController.register(
      email,
      password,
      firstName,
      lastName,
      phoneNumber,
    );
    final isLoginSuccess = await appwriteController.login(email, password);
    bool isCreateUserdocumentSuccess = false;
    if (user != null) {
      isCreateUserdocumentSuccess = await appwriteController.createUserDocument(
        email,
        user.$id,
        firstName,
        lastName,
        phoneNumber,
      );
    }

    logger.d("user: ${user?.$id}");
    logger.d("isCreateUserdocumentSuccess: $isCreateUserdocumentSuccess");
    logger.d("isLoginSuccess: $isLoginSuccess");
    if (isCreateUserdocumentSuccess && isLoginSuccess) {
      Get.snackbar("Login success", 'good luck have fun');
      Get.delete<BuyLotteryController>();
      Get.delete<UserStore>();
    }
    // register || login || create user document failed - sawanon:20240807
    Get.snackbar('Something went wrong', 'plaese try again');
    // Get.offAllNamed(RouteName.layout);
    Get.toNamed(RouteName.pin);
  }

  @override
  void onInit() {
    logger.d(argument["phoneNumber"]);
    super.onInit();
  }
}
