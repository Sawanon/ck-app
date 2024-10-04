import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class ChangePasscodeController extends GetxController {
  static ChangePasscodeController get to => Get.find();
  final argument = Get.arguments;

  void changePasscode(String passcode) async {
    logger.w(argument);
    final userId = argument['userId'];
    logger.d("userId: $userId");
    logger.d("passcode: $passcode");
    final result = await AppWriteController.to.changePasscode(passcode, userId);
    if (result['status'] == true) {
      whenSuccess();
    }
  }

  void whenSuccess() {
    if (argument != null && argument["whenSuccess"] is Function) {
      argument['whenSuccess']();
    }
  }
}
