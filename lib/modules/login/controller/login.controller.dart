import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/repository/user_repository/user.repository.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();
  String phoneNumber = '';
  GlobalKey<FormState> keyForm = GlobalKey();

  Future<void> login() async {
    // logger.d(phoneNumber);
    // logger.d(keyForm.currentState?.validate());
    final valid = keyForm.currentState?.validate();
    if (valid == null || valid == false) {
      return;
    }

    Get.toNamed(RouteName.cloudflare, arguments: {
      "whenSuccess": () {
        checkExistUser();
      },
      "onFailed": () {
        Get.snackbar("Verify faield", "please contact admin");
        navigator?.pop();
      },
      "onHttpError": () {
        Get.snackbar("Something went wrong",
            "try again later: error connection from server");
        navigator?.pop();
      },
      "onWebResourceError": () {
        Get.snackbar(
            "Something went wrong", "try again later: error connection page");
        navigator?.pop();
      }
    });
  }

  Future<void> checkExistUser() async {
    Map<String, dynamic>? token = await getToken();
    if (token == null) {
      Get.offNamed(RouteName.signup, arguments: {
        "phoneNumber": phoneNumber,
      });
      return;
    }
    Get.toNamed(
      RouteName.otp,
      arguments: {
        "whenSuccess": () async {
          Get.snackbar("OTP success !", "go to create session");
          await createSession(token);
        }
      },
    );
  }

  Future<Map<String, dynamic>?> getToken() async {
    final dio = Dio();
    final response = await dio.post("http://localhost:3000/sign-in", data: {
      "phoneNumber": phoneNumber,
    });
    final Map<String, dynamic>? token = response.data;
    return token;
  }

  Future<void> createSession(Map<String, dynamic> token) async {
    try {
      final appwriteController = AppWriteController.to;
      final session = await appwriteController.account
          .createSession(userId: token["userId"], secret: token["secret"]);
      logger.d(session.ip);
      logger.d(session.userId);
      final user = await appwriteController.account.get();
      logger.d(user.name);
      Get.delete<BuyLotteryController>();
      Get.delete<UserStore>();
      Get.offAllNamed(RouteName.layout);
    } on Exception catch (e) {
      logger.e(e);
      Get.snackbar("createSession failed", e.toString());
    }
  }

  Future<void> loginAppwrite() async {
    final appwriteController = AppWriteController.to;
    final email = '$phoneNumber@ckmail.com';
    await appwriteController.login(email, phoneNumber);
    // setup user await - sawanon:20240802
    Get.delete<BuyLotteryController>();
    Get.delete<UserStore>();
    // Get.put<BuyLotteryController>(BuyLotteryController());
    // final buylotteryController = BuyLotteryController.to;
    // buylotteryController.checkUser();
  }

  // Future<void> tryLogin() async {
  //   try {
  //     await loginAppwrite();
  //     Get.offAllNamed(RouteName.layout);
  //   } catch (e) {
  //     logger.e("login failed go to register page: $e");
  //     Get.offNamed(
  //       RouteName.signup,
  //       arguments: {
  //         "phoneNumber": phoneNumber,
  //       },
  //     );
  //   }
  // }

  Future<void> logout() async {
    logger.d("logout");
    final appwriteController = AppWriteController.to;
    await appwriteController.logout();
  }
}
