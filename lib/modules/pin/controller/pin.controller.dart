import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';

class PinController extends GetxController {
  static PinController get to => Get.find();
  final argument = Get.arguments;
  bool isHasPin = false;

  Future<void> checkHasPin() async {}

  void createPasscode(String passcode) async {
    // TODO: move create pin function to backend - sawanon:20240828
    try {
      final dio = Dio();
      // final appwriteController = AppWriteController.to;
      // final user = await appwriteController.user;
      // logger.d(user.$id);
      final String userId = Get.arguments['userId'];
      logger.w("userId: $userId");
      // final response = await dio.post(
      //   '${AppConst.cloudfareUrl}/createPasscode',
      //   data: {
      //     "passcode": passcode,
      //     "userId": user.$id,
      //   },
      // );
      final sessionId = await StorageController.to.getSessionId();
      final credential = "$sessionId:$userId";
      final bearer = base64Encode(utf8.encode(credential));
      final response = await dio.post(
        '${AppConst.apiUrl}/user/passcode',
        data: {
          "passcode": passcode,
          "userId": userId,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $bearer',
        }),
      );
      logger.d(response.data);
      whenSuccess();
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
      }
      return null;
    } on Exception catch (e) {
      logger.e(e.toString());
      Get.snackbar('Something went wrong pin:28', 'Plaese try again later');
    }
  }

  void whenSuccess() {
    if (argument != null && argument["whenSuccess"] is Function) {
      argument['whenSuccess']();
    }
  }
}
