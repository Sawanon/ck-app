import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/repository/user_repository/model/user.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();
  UserModel? user;

  Future<void> getUser() async {
    try {
      // final appwriteController = AppWriteController.to;
      // final storage = StorageController.to;
      // final user = await appwriteController.account.get();
      // logger.d("user.\$id: ${user.$id}");
    } catch (e) {
      logger.e("getUser failed: $e");
      Get.rawSnackbar(message: "$e");
    }
  }

  @override
  void onInit() {
    getUser();
    super.onInit();
  }
}
