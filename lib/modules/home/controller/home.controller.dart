import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  Alignment lotteryAlinment = Alignment.bottomCenter;
  void lotteryFullScreen() {
    lotteryAlinment = Alignment.center;
    update();
  }

  void lotteryResetScreen() {
    lotteryAlinment = Alignment.bottomCenter;
    update();
  }
}
