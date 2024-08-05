import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/route/route_name.dart';

class SettingController extends GetxController {
  Future<void> logout() async {
    final appwriteController = AppWriteController.to;
    await appwriteController.logout();
    Get.offAllNamed(RouteName.login);
  }
}
