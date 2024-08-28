import 'package:get/get.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class EnableBiometricsController extends GetxController {
  final arguments = Get.arguments;
  void enableBiometrics() async {
    await CommonFn.requestBiometrics();
    whenSuccess();
  }

  void skipBiometrics() async {
    whenSuccess();
  }

  void whenSuccess() {
    if (arguments == null) return;
    if (arguments['whenSuccess'] is Function) {
      arguments['whenSuccess']();
    }
  }
}
