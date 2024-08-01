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
    final appwriteController = AppWriteController.to;
    final phoneNumber = argument["phoneNumber"];
    final password = '${argument["phoneNumber"]}';
    final email = '$phoneNumber@ckmail.com';
    final name = '$firstName $lastName';
    final isSuccess = await appwriteController.register(email, password, name);
    // const isSuccess = true;
    logger.d(isSuccess);
    if (isSuccess) {
      logger.d("go to layout!");
      final loginController = LoginController.to;
      // await loginController.login();
      await loginController.loginAppwrite();
      // Get.offAllNamed(RouteName.layout);
    }
  }

  @override
  void onInit() {
    logger.d(argument["phoneNumber"]);
    super.onInit();
  }
}
