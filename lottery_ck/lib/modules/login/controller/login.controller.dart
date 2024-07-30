import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class LoginController extends GetxController {
  final test = 'ya';
  String username = '';
  String password = '';

  Future<void> login() async {
    logger.d(username);
    logger.d(password);
    final appwriteController = AppWriteController.to;
    await appwriteController.login(username, password);
  }

  Future<void> logout() async {
    logger.d("logout");
    final appwriteController = AppWriteController.to;
    await appwriteController.logout();
  }
}
