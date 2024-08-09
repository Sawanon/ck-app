import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';

class PinController extends GetxController {
  static PinController get to => Get.find();

  void createPasscode(String passcode) async {
    final dio = Dio();
    final appwriteController = AppWriteController.to;
    final user = await appwriteController.account.get();
    logger.d(user.$id);
    final response = await dio.post(
      '${AppConst.cloudfareUrl}/createPasscode',
      data: {
        "passcode": passcode,
        "userId": user.$id,
      },
    );
    logger.d(response.data);
  }

  void test() async {
    final storage = StorageController.to;
    final sessionId = await storage.getSessionId();
    logger.d("sessionId: $sessionId");
  }

  @override
  void onInit() {
    test();
    super.onInit();
  }
}
