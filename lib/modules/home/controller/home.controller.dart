import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery.page.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:video_player/video_player.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  Timer? _timer;
  DateTime? lotteryDate;

  String? lotteryDateStr;
  Rx<Duration> remainingDateTime = Duration.zero.obs;
  Alignment lotteryAlinment = Alignment.bottomCenter;
  RxList<Map> artworksList = <Map>[].obs;

  void lotteryFullScreen() {
    lotteryAlinment = Alignment.center;
    update();
  }

  void lotteryResetScreen() {
    lotteryAlinment = Alignment.bottomCenter;
    update();
  }

  void startCountdown(DateTime targetDateTime, DateTime currentDateTime) {
    remainingDateTime.value = targetDateTime.difference(currentDateTime);
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingDateTime.value.inSeconds > 0) {
          remainingDateTime.value -= const Duration(seconds: 1);
          // logger.d("run ! ${remainingDateTime.value.inSeconds}");
          return;
        }
        logger.e("stop !");
        timer.cancel();
      },
    );
  }

  Future<void> getLotteryDate() async {
    try {
      // logger.d(DateTime.now().timeZoneName);
      // logger.d(DateTime.now().timeZoneOffset.inHours);
      // return;
      final now = await getCurrentDatetime();
      final nowLocal = now!.toLocal();
      final todayMidnight =
          DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
      final appwriteController = AppWriteController.to;
      final lotteryDateDocument =
          await appwriteController.getLotteryDate(todayMidnight.toUtc());
      final lotteryEndTimeISO = lotteryDateDocument?.data['end_time'];
      final lotteryDateISO = lotteryDateDocument?.data['datetime'];

      final lotteryEndTime = DateTime.parse(lotteryEndTimeISO);
      final lotteryDate = DateTime.parse(lotteryDateISO);
      // await initializeDateFormatting('lo_LA');
      // final formatter = DateFormat('y-MM-dd', 'lo_LA');
      // final dateStr = formatter.format(lotteryDate);
      // logger.d(dateStr);
      // 'lo_LA'
      final lotteryEndTimeLocal = lotteryEndTime.toLocal();
      logger.d(lotteryEndTimeLocal);
      this.lotteryDate = lotteryDate.toLocal();
      logger.f("$lotteryDate");
      lotteryDateStr = CommonFn.parseDMY(lotteryDate.toLocal());
      // final nowLocal = now.toLocal();
      startCountdown(lotteryEndTime, now);
      update();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<DateTime?> getCurrentDatetime() async {
    try {
      final dio = Dio();
      const url = "${AppConst.cloudfareUrl}/currentTime";
      logger.d(url);
      final response = await dio.get(url);
      final dateServer = response.headers['dateISO'];
      if (dateServer?.isEmpty == true) {
        throw "date is not found";
      }
      final nowStr = dateServer![0];
      // TODO: fake date time for test - sawanon
      final now = DateTime.parse(nowStr);
      // final now = DateTime.now().add(const Duration(days: -7));
      return now;
    } catch (e) {
      logger.e(e.toString());
      Get.rawSnackbar(message: "⛔️ Can't get current time from server");
      return null;
    }
  }

  Future<void> listArtworks() async {
    final appwriteController = AppWriteController.to;
    final artworks = await appwriteController.listArtworks(6);
    logger.d(artworks);
    if (artworks == null) {
      return;
    }
    artworksList.value = artworks;
  }

  void setup() async {
    await getLotteryDate();
    await listArtworks();
  }

  void gotoAnimal() {
    LayoutController.to.changeTab(TabApp.lottery);
    BuyLotteryController.to.gotoAnimalPage();
  }

  void gotoLotteryResult() {
    LayoutController.to.changeTab(TabApp.lottery);
    BuyLotteryController.to.chnageParentTab(1);
    // logger.d(BuyLotteryPage.keys.currentState);
    // BuyLotteryPage.keys.currentState?.changeTab(1);
    // BuyLotteryPage.key.currentState?.changeTab(1)
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
