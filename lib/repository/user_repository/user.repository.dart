import 'package:appwrite/appwrite.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/repository/user_repository/model/user.dart';
import 'package:lottery_ck/utils.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();
  UserModel? user;

  Future<void> getUser() async {
    try {
      final appwriteController = AppWriteController.to;
      final database = appwriteController.databases;
      final account = appwriteController.account;
      final client = appwriteController.client;

      // account.client.
      // final users = await database.listDocuments(
      //   databaseId: "lottory",
      //   collectionId: "user",
      // );
      // logger.d(users);
      // for (var user in users.documents) {
      //   logger.d(user.data);
      // }
      // final user = await appwriteController.account.get();
      // logger.d(user.name);
    } catch (e) {
      logger.e("getUser failed: $e");
    }
  }

  @override
  void onInit() {
    // final userRepo = UserRepository();
    // final _user = await userRepo.user;
    // logger.d(_user);
    // user = _user;
    getUser();
    super.onInit();
  }
}
