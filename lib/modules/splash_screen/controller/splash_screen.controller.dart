import 'dart:async';

import 'package:get/get.dart';
import 'package:lottery_ck/route/route_name.dart';

class SplashScreenController extends GetxController {
  void gotoLayout() {
    Timer(const Duration(seconds: 1), () {
      // SystemChrome.setEnabledSystemUIMode(
      //   SystemUiMode.manual,
      //   overlays: SystemUiOverlay.values,
      // );
      // logger.d("gogogo");
      Get.offNamed(RouteName.layout);
    });
  }

  @override
  void onInit() {
    gotoLayout();
    super.onInit();
  }
}
