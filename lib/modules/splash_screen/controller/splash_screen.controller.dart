import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class SplashScreenController extends GetxController {
  void gotoLayout() {
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: SystemUiOverlay.values,
    // );
    // logger.d("gogogo");
    Get.offNamed(RouteName.layout);
  }

  void checkTimeZone() {
    final offset = DateTime.now().timeZoneOffset;
    if (offset.inHours != 7) {
      throw "Your timezone is not support";
    }
  }

  void setup() async {
    try {
      await Future.delayed(
        const Duration(seconds: 1),
        () {
          checkTimeZone();
          gotoLayout();
        },
      );
    } catch (e) {
      logger.e("catch: $e");
      Get.defaultDialog(
        title: "Warning",
        middleText: '$e',
        barrierDismissible: false,
        confirm: GestureDetector(
          onTap: () {
            SystemNavigator.pop();
          },
          child: Container(
            height: 48,
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.primary,
            ),
            child: const Text(
              "Close",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
