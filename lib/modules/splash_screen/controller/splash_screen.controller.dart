import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/history/controller/history_win.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get to => Get.find();
  void gotoLayout() {
    // TODO: uncomment for production
    Get.offNamed(RouteName.layout);
  }

  void checkTimeZone() {
    final offset = DateTime.now().timeZoneOffset;
    if (offset.inHours != 7) {
      throw "Your timezone is not support";
    }
  }

  Future<void> checkUser() async {
    final isActive = await AppWriteController.to.isActiveUser();
    logger.d("isActive: $isActive");
    if (isActive == false) {
      AppWriteController.to.logout();
    }
  }

  void setup() async {
    try {
      await Future.delayed(
        const Duration(seconds: 1),
        () async {
          await checkUser();
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

  Future<void> setupInteractedMessage(BuildContext context) async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage event) async {
    await Future.delayed(
      const Duration(seconds: 1),
      () async {
        if (event.data['link'] != null) {
          logger.w("open with notification: $event");
          logger.w("data: ${event.data}");
          String link = event.data['link'];
          logger.d("link: $link");
          if (link.contains("/news")) {
            logger.d("goto news page");
            LayoutController.to.changeTab(TabApp.notifications);
            final newsId = link.split("/").last;
            logger.d(newsId);
            NotificationController.to.openNewsDetail(newsId);
          } else if (link.contains("/promotion")) {
            logger.d("goto news page");
            LayoutController.to.changeTab(TabApp.notifications);
            final promotionId = link.split("/").last;
            logger.d(promotionId);
            NotificationController.to.openPromotionDetail(promotionId);
          } else if (link.contains("/win")) {
            logger.d("goto win page");
            final lotteryStr = event.data["lotteryDate"];
            LayoutController.to.changeTab(TabApp.history);
            final invoiceId = link.split("/").last;
            HistoryWinController.to.openWinDetail(invoiceId, lotteryStr);
          }
        }
      },
    );
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
