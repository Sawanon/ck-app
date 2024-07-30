import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class SignupController extends GetxController {
  String firstName = '';
  String lastName = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  Future<void> register() async {
    logger.d({
      firstName,
      lastName,
      phone,
      password,
      confirmPassword,
    });
    logger.d(keyForm.currentState?.validate());
    logger.d("run register");
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      final appwriteController = AppWriteController.to;
      final email = '$phone@ckmail.com';
      logger.d(GetUtils.isEmail(email));
      Get.toNamed(RouteName.otp, arguments: {
        "whenSuccess": () {
          logger.d("otp success !");
        }
      });
      // final name = '$firstName $lastName';
      // await appwriteController.register(email, password, name);
    }
  }
}
