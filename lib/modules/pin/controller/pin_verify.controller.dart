import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';

class PinVerifyController extends GetxController {
  String? passcode;
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

  @override
  void onInit() {
    getPasscode();
    super.onInit();
  }
}
