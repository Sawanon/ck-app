import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/login/controller/login.controller.dart';
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
    Get.toNamed(RouteName.otp, arguments: {
      "whenSuccess": () async {
        final appwriteController = AppWriteController.to;
        final phoneNumber = argument["phoneNumber"] as String;
        final multiplier =
            (int.parse(phoneNumber.substring(phoneNumber.length - 1)) *
                    int.parse(phoneNumber.substring(
                        phoneNumber.length - 3, phoneNumber.length - 2)))
                .toString();
        final lastPhone = multiplier.substring(multiplier.length - 1);
        final password =
            '${phoneNumber.substring(0, 4)}$lastPhone${phoneNumber.substring(4)}';
        final email = '$phoneNumber@ckmail.com';
        final isSuccess = await appwriteController.register(
          email,
          password,
          firstName,
          lastName,
          phoneNumber,
        );

        // const isSuccess = true;
        logger.d(isSuccess);
        if (isSuccess) {
          logger.d("go to layout!");
          final loginController = LoginController.to;
          // await loginController.login();
          return await loginController.checkExistUser();
          // Get.offAllNamed(RouteName.layout);
        }
        Get.snackbar('Something went wrong', 'plaese try again');
      }
    });
  }

  @override
  void onInit() {
    logger.d(argument["phoneNumber"]);
    super.onInit();
  }
}
