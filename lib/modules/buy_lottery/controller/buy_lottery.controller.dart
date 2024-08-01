import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class BuyLotteryController extends GetxController {
  bool isUserLoggedIn = false;

  Future<void> checkUser() async {
    final appwriteController = AppWriteController.to;
    final isUserLoggedIn = await appwriteController.isUserLoggedIn();
    logger.d(isUserLoggedIn);
    this.isUserLoggedIn = isUserLoggedIn;
  }

  @override
  void onInit() {
    checkUser();
    super.onInit();
  }
}
