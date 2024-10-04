import 'dart:typed_data';

import 'package:argon2/argon2.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';

class PinVerifyController extends GetxController {
  // String? passcode;
  RxBool pendingVerify = false.obs;

  final arguments = Get.arguments;
  final enableForgetPasscode =
      Get.arguments['enableForgetPasscode'] == null ? false : true;

  // void getPasscode() async {
  //   final passcode = await AppWriteController.to.getPasscode();
  //   this.passcode = passcode;
  //   update();
  // }

  void whenSuccess() {
    if (arguments["whenSuccess"] is Function) {
      arguments["whenSuccess"]();
    }
  }

  Future<bool> verifyPasscode(String passcode) async {
    try {
      pendingVerify.value = true;
      final userId = arguments["userId"];
      final response =
          await AppWriteController.to.verifyPasscode(passcode, userId);
      logger.d("response?[pass] : $response");
      logger.d("response?[pass] : ${response?["pass"]}");
      if (response?["pass"] == true) {
        whenSuccess();
      }
      return response?["pass"] == true;
    } catch (e) {
      logger.d("$e");
      return false;
    } finally {
      pendingVerify.value = false;
    }
  }

  void forgetPasscode() async {
    final whenForgetPasscode = arguments['whenForgetPasscode'];
    if (whenForgetPasscode == null) return;
    logger.d("do something");
    if (whenForgetPasscode is Function) {
      whenForgetPasscode();
    }
  }

  @override
  void onInit() {
    // getPasscode();
    super.onInit();
  }
}
