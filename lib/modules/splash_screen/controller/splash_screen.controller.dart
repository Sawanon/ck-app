import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/binding/initial.binding.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/main.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/history/controller/history_win.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/modules/restart/view/restart.dart';
import 'package:lottery_ck/modules/splash_screen/view/splash_screen.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get to => Get.find();
  StreamSubscription<List<ConnectivityResult>>? subscription;

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

  void listenNetworkEvents() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      // Received changes in available connectivity types!
      logger.w(result);
    });
  }

  void checkNetWork() async {
    // listenNetworkEvents();
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

// This condition is for demo purposes only to explain every connection type.
// Use conditions which work for your requirements.
    logger.e(connectivityResult);
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      logger.w("mobile");
      setup();
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      logger.w("wifi");
      setup();
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available.
      logger.w("Ethernet");
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      // Vpn connection active.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
      logger.w("Bluetooth");
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // Connected to a network which is not in the above mentioned networks.
      logger.w("other");
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
      logger.w("No available network");
      Get.dialog(
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "ບໍ່ພົບການເຊື່ອມຕໍ່ອິນເຕີເນັດ",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "ກະລຸນາກວດສອບການເຊື່ອມຕໍ່ອິນເຕີເນັດ/Wifi ໃນອຸປະກອນມືຖືຂອງເຈົ້າ ແລະລອງເຂົ້າສູ່ລະບົບອີກຄັ້ງ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LongButton(
                    onPressed: () async {
                      // await Get.to(() => RestartPage());
                      // await Get.deleteAll(force: true);
                      // await Get.to(
                      //   SplashScreenPage(),
                      //   binding: InitialBinding(),
                      // );
                      SystemNavigator.pop();
                    },
                    child: Text("OK"),
                  )
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
        useSafeArea: true,
      );
    }
  }

  @override
  void onInit() {
    checkNetWork();
    super.onInit();
  }

  @override
  void onClose() {
    subscription!.cancel();
    super.onClose();
  }
}
