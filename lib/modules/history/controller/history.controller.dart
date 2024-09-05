import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/history/controller/history_buy.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class HistoryController extends GetxController {
  static HistoryController get to => Get.find();
  bool isLogin = false;
  bool loading = true;
  // if (e is AppwriteException) {
  //       if (e.code == 401) {
  //         isLogin = false;
  //         update();
  //         return;
  //       }
  //     }
  Future<bool> checkPermission() async {
    try {
      await AppWriteController.to.user;
      isLogin = true;
      return true;
    } catch (e) {
      logger.e("$e");
      return false;
    }
  }

  void setup() async {
    loading = true;
    update();
    final isLogin = await checkPermission();
    if (isLogin) {
      Get.put<HistoryBuyController>(HistoryBuyController());
    }
    loading = false;
    update();
  }

  @override
  void onInit() {
    // setup();
    super.onInit();
  }
}
