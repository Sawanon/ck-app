import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/route/route_name.dart';
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

  void gotoLoginPage() {
    Get.toNamed(RouteName.login);
    // Get.toNamed(RouteName.cloudflare, arguments: {
    //   "whenSuccess": () {
    //   },
    //   "onFailed": () {
    //     Get.snackbar("Verify faield", "please contact admin");
    //     navigator?.pop();
    //   },
    //   "onHttpError": () {
    //     Get.snackbar("Something went wrong",
    //         "try again later: error connection from server");
    //     navigator?.pop();
    //   },
    //   "onWebResourceError": () {
    //     Get.snackbar(
    //         "Something went wrong", "try again later: error connection page");
    //     navigator?.pop();
    //   }
    // });
  }

  @override
  void onInit() {
    logger.d("start BuyLotteryController !");
    checkUser();
    super.onInit();
  }
}
