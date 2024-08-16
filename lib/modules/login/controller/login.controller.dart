import 'dart:io';

import 'package:appwrite/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/couldflare/controller/cloudflare.controller.dart';
import 'package:lottery_ck/repository/user_repository/user.repository.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();
  String phoneNumber = '';
  GlobalKey<FormState> keyForm = GlobalKey();
  // RxBool disableLogin = true.obs;
  // TODO: for test only !! - sawanon:20240816
  RxBool disableLogin = false.obs;
  WebViewController? webviewController;

  Future<void> login() async {
    final valid = keyForm.currentState?.validate();
    if (valid == null || valid == false) {
      return;
    }

    Map<String, dynamic>? token = await getToken();
    Get.delete<CloudFlareController>();
    if (token == null) {
      // TODO: go to otp for verify then go to enter user info - sawanon:20240807
      Get.toNamed(
        RouteName.otp,
        arguments: {
          "phoneNumber": phoneNumber,
          "whenSuccess": () {
            Get.offNamed(RouteName.signup, arguments: {
              "phoneNumber": phoneNumber,
            });
          }
        },
      );
      return;
    }
    getOTPandCreatePin(token);
  }

  Future<void> getOTPandCreatePin(Map<String, dynamic> token) async {
    Get.toNamed(
      RouteName.otp,
      arguments: {
        "phoneNumber": phoneNumber,
        "whenSuccess": () async {
          Get.snackbar("OTP success !", "go to create session");
          final session = await createSession(token);
          if (session == null) {
            Get.snackbar(
              "Something went wrong",
              "Please try again later or plaese contact admin",
            );
            navigator?.pop();
            return;
          }
          Get.offNamed(
            RouteName.pin,
            arguments: {
              "whenSuccess": () {
                Get.delete<BuyLotteryController>();
                Get.delete<UserStore>();
                Get.offAllNamed(RouteName.layout);
              }
            },
          );
        }
      },
    );
  }

  Future<void> createPin() async {
    final dio = Dio();
    final appwriteController = AppWriteController.to;
    final account = appwriteController.account;

    // final reposne = dio.
  }

  Future<Map<String, dynamic>?> getToken() async {
    final dio = Dio();
    final response = await dio.post("${AppConst.cloudfareUrl}/sign-in", data: {
      "phoneNumber": phoneNumber,
    });
    final Map<String, dynamic>? token = response.data;
    return token;
  }

  Future<Session?> createSession(Map<String, dynamic> token) async {
    try {
      final appwriteController = AppWriteController.to;
      final session = await appwriteController.account.createSession(
        userId: token["userId"],
        secret: token["secret"],
      );
      await appwriteController.clearOtherSession(session.$id);
      final storageController = StorageController.to;
      storageController.setSessionId(session.$id);
      return session;
    } on Exception catch (e) {
      logger.e(e);
      Get.snackbar("createSession failed", e.toString());
      return null;
    }
  }

  // Future<void> loginAppwrite() async {
  //   final appwriteController = AppWriteController.to;
  //   final email = '$phoneNumber@ckmail.com';
  //   await appwriteController.login(email, phoneNumber);
  //   // setup user await - sawanon:20240802
  //   Get.delete<BuyLotteryController>();
  //   Get.delete<UserStore>();
  // }

  Future<void> logout() async {
    logger.d("logout");
    final appwriteController = AppWriteController.to;
    await appwriteController.logout();
  }

  void checkDevice() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        logger.f('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
        final allInfo = await deviceInfo.deviceInfo;
        logger.f("serialNumber: ${allInfo.data["serialNumber"]}");
        logger.f("isPhysicalDevice: ${allInfo.data["isPhysicalDevice"]}");
        logger.f(allInfo.data);
        final identifier = await UniqueIdentifier.serial;
        logger.f("identifier: $identifier");
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        logger.f('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
        final allInfo = await deviceInfo.deviceInfo;
        logger.f(allInfo.data);
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        "Not allow this platform",
        "please contact admin",
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
  }

  void setDisableButton() {
    logger.d("boom!");
    disableLogin.value = false;
  }

  @override
  void onInit() {
    final cloudflareController = CloudFlareController.to;
    cloudflareController.setCallback(setDisableButton);
    webviewController = cloudflareController.controllerWebview;
    checkDevice();
    super.onInit();
  }
}
