import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';

class PinController extends GetxController {
  static PinController get to => Get.find();
  final argument = Get.arguments;

  void createPasscode(String passcode) async {
    // TODO: move create pin function to backend - sawanon:20240828
    try {
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
      whenSuccess();
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
