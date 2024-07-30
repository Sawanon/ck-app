import 'package:get/get.dart';
import 'package:lottery_ck/utils.dart';

class SignupController extends GetxController {
  String firstName = '';
  String lastName = '';
  String phone = '';
  String password = '';
  String confirmPassword = '';

  Future<void> register() async {
    logger.d({
      firstName,
      lastName,
      phone,
      password,
      confirmPassword,
    });
    logger.d("run register");
  }
}
