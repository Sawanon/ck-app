import 'package:get/get.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class EnableBiometricsController extends GetxController {
  final arguments = Get.arguments;
  void enableBiometrics() async {
    final enable = await CommonFn.enableBiometrics();
    logger.d("enable: $enable");
    whenSuccess();
  }

  void skipBiometrics() async {
    logger.d("skip biometrics");
    whenSuccess();
  }

  void whenSuccess() {
    if (arguments == null) return;
    if (arguments['whenSuccess'] is Function) {
      arguments['whenSuccess']();
    }
  }
}
