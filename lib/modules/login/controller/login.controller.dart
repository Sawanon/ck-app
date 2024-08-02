import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/repository/user_repository/user.repository.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();
  final test = 'ya';
  String username = '';
  String password = '';

  Future<void> login() async {
    logger.d(username);
    logger.d(password);
    // final appwriteController = AppWriteController.to;
    // await appwriteController.login(username, password);
    // await appwriteController.loginWithPhoneNumber(username);

    Get.toNamed(RouteName.otp, arguments: {
      "whenSuccess": () {
        logger.d("otp success !");
        tryLogin();
      },
      "phoneNumber": username,
    });
  }

  Future<void> loginAppwrite() async {
    final appwriteController = AppWriteController.to;
    final email = '$username@ckmail.com';
    await appwriteController.login(email, username);
    // setup user await - sawanon:20240802
    Get.delete<BuyLotteryController>();
    Get.delete<UserStore>();
    // Get.put<BuyLotteryController>(BuyLotteryController());
    // final buylotteryController = BuyLotteryController.to;
    // buylotteryController.checkUser();
  }

  Future<void> tryLogin() async {
    try {
      await loginAppwrite();
      Get.offAllNamed(RouteName.layout);
    } catch (e) {
      logger.e("login failed go to register page: $e");
      Get.offNamed(
        RouteName.signup,
        arguments: {
          "phoneNumber": username,
        },
      );
    }
  }

  Future<void> logout() async {
    logger.d("logout");
    final appwriteController = AppWriteController.to;
    await appwriteController.logout();
  }
}
