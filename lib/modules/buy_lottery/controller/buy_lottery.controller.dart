import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class BuyLotteryController extends GetxController {
  static BuyLotteryController get to => Get.find();
  RxBool isUserLoggedIn = false.obs;

  Future<void> checkUser() async {
    final appwriteController = AppWriteController.to;
    final isUserLoggedIn = await appwriteController.isUserLoggedIn();
    logger.d(isUserLoggedIn);
    this.isUserLoggedIn.value = isUserLoggedIn;
  }

  void test() {
    logger.d("boom !");
  }

  @override
  void onInit() {
    logger.d("start BuyLotteryController !");
    checkUser();
    super.onInit();
  }
}
