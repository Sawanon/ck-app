import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/history/controller/history_win.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottery_ck/utils/notification_service.dart';

class FirebaseMessagingController extends GetxController {
  static FirebaseMessagingController get to => Get.find();
  StreamSubscription<RemoteMessage>? stream;
  Future<void> initialFirebase() async {
    try {
      // You may set the permission requests to "provisional" which allows the user to choose what type
      // of notifications they would like to receive once the user receives a notification.
      // logger.w("token firebase: $token");
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
      // logger.d("apnsToken: $apnsToken");
      if (apnsToken != null) {
        // APNS token is available, make FCM plugin API requests...
      }

      stream =
          FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        // logger.d("message: ${message.notification?.title}");
        // logger.d("message: ${message.notification?.body}");
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
        await NotificationService().showNotification(
          id: 1,
          title: message.notification?.title ?? "",
          body: message.notification?.body ?? "",
          payload: message.data,
        );
        // await FlutterLocalNotificationsPlugin().show(
        //   1,
        //   message.notification?.title ?? "",
        //   message.notification?.body ?? "",
        //   NotificationDetails(
        //     android: AndroidNotificationDetails(
        //       'download_channel',
        //       message.notification?.title ?? "",
        //       channelDescription: 'Notification',
        //       importance: Importance.max,
        //       priority: Priority.high,
        //     ),
        //   ),
        // );
        return;
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
            onTapNotification(message.data);
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
    } on FirebaseException catch (e) {
      logger.e(e.message);
      logger.e(e.code);
      logger.e(e.toString());
    } on Exception catch (e) {
      logger.e("$e");
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

  void onTapNotification(Map data) {
    if (data['link'] != null) {
      // logger.w("open with notification: $event");
      // logger.w("data: ${event.data}");
      String link = data['link'];
      logger.d("link: $link");
      if (link.contains("/news")) {
        logger.d("goto news page");
        LayoutController.to.changeTab(TabApp.settings);
        final newsId = link.split("/").last;
        logger.d(newsId);
        NotificationController.to.openNewsDetail(newsId);
      } else if (link.contains("/promotion")) {
        logger.d("goto news page");
        LayoutController.to.changeTab(TabApp.settings);
        final promotionId = link.split("/").last;
        logger.d(promotionId);
        NotificationController.to.openPromotionDetail(promotionId);
      } else if (link.contains("/win")) {
        logger.d("goto win page");
        final lotteryStr = data["lotteryDate"];
        LayoutController.to.changeTab(TabApp.history);
        final invoiceId = link.split("/").last;
        HistoryWinController.to.openWinDetail(invoiceId, lotteryStr);
      } else if (link.contains("/kyc")) {
        LayoutController.to.changeTab(TabApp.settings);
        SettingController.to.setup();
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
          } else if (link.contains("/kyc")) {
            LayoutController.to.changeTab(TabApp.settings);
            SettingController.to.setup();
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

  Future<void> subscribeToTopic(String topic) async {
    try {
      logger.w("start sub topic: $topic");
      FirebaseMessaging.instance.subscribeToTopic(topic);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> setup() async {
    await initialFirebase();
    await subscribeToTopic("unauth");
  }

  @override
  void onInit() {
    // initialFirebase();
    setup();
    // listenOpenNotifications();
    // listenBackgroundNotifications();
    super.onInit();
  }

  @override
  void onClose() {
    stream?.cancel();
    super.onClose();
  }
}
