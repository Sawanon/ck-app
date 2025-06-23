import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/modules/history/controller/history_win.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // intialized
  Future<void> initNotification() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onTabNotification,
    );
  }

  // notification detail setup
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // show notification
  Future<void> showNotification({
    required int id,
    required String title,
    String? body,
    Map? payload,
  }) async {
    return notificationsPlugin.show(
      1,
      title,
      body,
      notificationDetails(),
      payload: jsonEncode(payload),
    );
  }

  // on noti tap
  void onTabNotification(NotificationResponse detail) {
    logger.w(detail.id);
    logger.w(detail.input);
    logger.w(detail.payload);
    final payload = detail.payload;
    if (payload != null) {
      final data = jsonDecode(payload);
      // FirebaseMessagingController.to.onTapNotification(jsonDecode(payload));
      if (data['link'] != null) {
        String link = data['link'];
        logger.d("link: $link");
        if (link.contains("/news")) {
          logger.d("goto news page");
          LayoutController.to.changeTab(TabApp.settings);
          NotificationController.to.onChangeTab(1);
          final newsId = link.split("/").last;
          logger.d(newsId);
          NotificationController.to.openNewsDetail(newsId);
        } else if (link.contains("/promotion")) {
          logger.d("goto news page");
          LayoutController.to.changeTab(TabApp.settings);
          NotificationController.to.onChangeTab(0);
          final promotionId = link.split("/").last;
          logger.d(promotionId);
          NotificationController.to.openPromotionDetail(promotionId);
        } else if (link.contains("/win")) {
          logger.d("goto win page");
          final lotteryStr = data["lotteryDate"];
          LayoutController.to.changeTab(TabApp.history);
          final invoiceId = link.split("/").last;
          HistoryWinController.to.openWinDetail(invoiceId, lotteryStr);
        } else if (link.contains("/point")) {
          logger.d("goto win page");
          LayoutController.to.changeTab(TabApp.notifications);
          final promotionPointId = link.split("/").last;
          NotificationController.to.openPromotionPointsDetail(promotionPointId);
        } else if (link.contains("/kyc")) {
          // LayoutController.to.changeTab(TabApp.settings);
          SettingController.to.setup();
          Get.toNamed(RouteName.setting);
          Get.toNamed(RouteName.profile);
        }
      }
    }
  }
}
