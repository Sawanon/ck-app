import 'package:get/get.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/route/route_name.dart';

class SettingController extends GetxController {
  UserApp? user;

  Future<void> logout() async {
    final appwriteController = AppWriteController.to;
    await appwriteController.logout();
    Get.offAllNamed(RouteName.login);
  }

  Future<void> getUser() async {
    final user = await AppWriteController.to.getUserApp();
    if (user == null) return;
    this.user = user;
    update();
  }

  void setup() async {
    await getUser();
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
