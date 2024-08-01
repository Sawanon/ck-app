import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/repository/user_repository/model/user.dart';
import 'package:lottery_ck/utils.dart';

class UserStore extends GetxController {
  static UserStore get to => Get.find();
  UserModel? user;

  Future<void> getUser() async {
    // final appwriteController = AppWriteController.to;
    // final user = await appwriteController.account.get();
    // logger.d(user.name);
  }

  @override
  void onInit() {
    // final userRepo = UserRepository();
    // final _user = await userRepo.user;
    // logger.d(_user);
    // user = _user;
    // getUser();
    super.onInit();
  }
}
