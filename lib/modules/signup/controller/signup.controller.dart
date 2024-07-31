import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> testLogout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> register() async {
    await testLogout();
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      const isSuccess = true;
      if (isSuccess) {
        Get.toNamed(RouteName.otp, arguments: {
          "whenSuccess": () {
            logger.d("otp success !");
            createUserAppwrite();
          },
          "phoneNumber": phone,
        });
      }
    }
  }

  Future<void> createUserAppwrite() async {
    final appwriteController = AppWriteController.to;
    final email = '$phone@ckmail.com';
    final name = '$firstName $lastName';
    // final isSuccess = await appwriteController.register(email, password, name);
    const isSuccess = true;
    logger.d(isSuccess);
    if (isSuccess) {
      logger.d("go to layout!");
      Get.offAllNamed(RouteName.layout);
    }
  }
}
