import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class HistoryController extends GetxController {
  bool isLogin = false;
  bool loading = true;
  // if (e is AppwriteException) {
  //       if (e.code == 401) {
  //         isLogin = false;
  //         update();
  //         return;
  //       }
  //     }
  void checkPermission() async {
    try {
      await AppWriteController.to.user;
      isLogin = true;
    } catch (e) {
      logger.e("$e");
    } finally {
      loading = false;
      update();
    }
  }

  @override
  void onInit() {
    checkPermission();
    super.onInit();
  }
}
