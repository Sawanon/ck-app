import 'dart:typed_data';

import 'package:argon2/argon2.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';

class PinVerifyController extends GetxController {
  String? passcode;
  RxBool pendingVerify = false.obs;

  final arguments = Get.arguments;

  void getPasscode() async {
    final passcode = await AppWriteController.to.getPasscode();
    this.passcode = passcode;
    update();
  }

  void whenSuccess() {
    if (arguments["whenSuccess"] is Function) {
      arguments["whenSuccess"]();
    }
  }

  Future<bool> verifyPasscode(String passcode) async {
    try {
      pendingVerify.value = true;
      final response = await AppWriteController.to.verifyPasscode(passcode);
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

  @override
  void onInit() {
    getPasscode();
    super.onInit();
  }
}
