import 'package:get/get.dart';
import 'package:lottery_ck/utils.dart';

class OtpController extends GetxController {
  final argrument = Get.arguments;

  void showArgrument() {
    // TODO: when otp success run function in argrument - sawanon:20240730
    logger.d(argrument);
    argrument["whenSuccess"]();
  }
}
