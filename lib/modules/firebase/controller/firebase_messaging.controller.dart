import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/history/controller/history_win.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class FirebaseMessagingController extends GetxController {
  static FirebaseMessagingController get to => Get.find();
  late String? token;
  void initialFirebase() async {
    try {
      // You may set the permission requests to "provisional" which allows the user to choose what type
      // of notifications they would like to receive once the user receives a notification.
      token = await FirebaseMessaging.instance.getToken();
      logger.w("token firebase: $token");
      final notificationSettings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
      );
      // logger.d(notificationSettings);

      // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      logger.d("apnsToken: $apnsToken");
      if (apnsToken != null) {
        // APNS token is available, make FCM plugin API requests...
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // logger.d("message: ${message.notification?.title}");
        // logger.d("message: ${message.notification?.body}");
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        Get.snackbar(
          message.notification?.title ?? "",
          message.notification?.body ?? "",
          borderColor: AppColors.primary,
          borderWidth: 2,
          titleText: Text(
            message.notification?.title ?? "",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          messageText: Text(
            message.notification?.body ?? "",
          ),
          backgroundColor: Colors.white,
          onTap: (snack) {
            onTapNotification(message);
          },
          duration: const Duration(seconds: 6),
        );
        logger.d("title: ${message.notification?.title}");
        logger.d("body: ${message.notification?.body}");
        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      });
    } on Exception catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        "initialFirebase",
        e.toString(),
        duration: Duration(seconds: 5),
      );
    }
  }

  Future<String?> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    logger.w("new token: $token");
    return token;
  }

  void onTapNotification(RemoteMessage event) {
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
  }

  void listenOpenNotifications() {
    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
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

  @pragma('vm:entry-point')
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    // await Firebase.initializeApp();

    logger.w("Handling a background message: ${message.messageId}");
  }

  void listenBackgroundNotifications() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  void onInit() {
    initialFirebase();
    // listenOpenNotifications();
    // listenBackgroundNotifications();
    super.onInit();
  }
}
