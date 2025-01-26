import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/model/news.dart';
import 'package:lottery_ck/model/notification.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  RxList<News> newsList = <News>[].obs;
  RxList<Map> promotionList = <Map>[].obs;
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  int currentTab = 0;

  Future<void> listNews() async {
    final newsList = await AppWriteController.to.listNews();
    if (newsList != null) {
      this.newsList.value = newsList;
    }
  }

  Future<void> listPromotions() async {
    final promotionListData = await AppWriteController.to.listPromotions();
    List<Map> allPromotionList = [];
    if (promotionListData != null) {
      allPromotionList = promotionListData
          .map((promotion) => {...promotion, "promotionType": "promotions"})
          .toList();
    }
    // if (promotionListData != null) {
    //   promotionList.value = promotionListData;
    // }
    final promotionsPointsList =
        await AppWriteController.to.listPromotionsPoints();
    if (promotionsPointsList != null) {
      for (var promotionsPoints in promotionsPointsList) {
        allPromotionList.add({...promotionsPoints, "promotionType": "points"});
      }
    }
    // logger.d(allPromotionList);
    allPromotionList.sort(
      (a, b) {
        return DateTime.parse(b['start_date'])
            .compareTo(DateTime.parse(a['start_date']));
      },
    );
    // logger.d(allPromotionList);
    promotionList.value = allPromotionList;
  }

  void openNewsDetail(String newsId) {
    Get.toNamed(
      RouteName.news,
      arguments: {
        "newsId": newsId,
      },
    );
  }

  void openPromotionDetail(String promotionId) {
    Get.toNamed(
      RouteName.promotion,
      arguments: {
        "promotionId": promotionId,
      },
    );
  }

  void openPromotionPointsDetail(String promotionPointsId) {
    Get.toNamed(
      RouteName.promotionPoint,
      arguments: {
        "promotionId": promotionPointsId,
      },
    );
  }

  void onChangeTab(int index) async {
    currentTab = index;
    update();
    if (index != 0) {
      await Future.delayed(const Duration(milliseconds: 250), () {
        currentTab = 0;
        update();
      });
    }
  }

  Future<void> listNotification() async {
    final user = await AppWriteController.to.getUserApp();
    if (user == null) {
      return;
    }

    final response = await AppWriteController.to.listNotification(user.userId);
    // logger.d(response.data);
    if (response.isSuccess == false || response.data == null) {
      Get.dialog(
        DialogApp(
          title: Text(
            AppLocale.somethingWentWrong.getString(Get.context!),
          ),
          details: Text(
            response.message,
          ),
          disableConfirm: true,
        ),
      );
      return;
    }
    notificationList.value = response.data!;
    // response.data?.forEach((notification) {
    //   logger.w("$notification");
    // });
  }

  void onClickNotification(NotificationModel notification) async {
    final link = notification.link;
    logger.d(link);
    final user = SettingController.to.user;
    if (link != null) {
      if (link.contains("/news")) {
        final newsId = link.split("/").last;
        openNewsDetail(newsId);
      } else if (link.contains("/promotion")) {
        final promotionId = link.split("/").last;
        openPromotionDetail(promotionId);
      } else if (link.contains("/kyc")) {
        // LayoutController.to.changeTab(TabApp.settings);
        Get.toNamed(RouteName.setting);
        Get.toNamed(RouteName.profile);
        LayoutController.to.changeTab(TabApp.home);
        SettingController.to.setup();
      }
    }
    if (user == null) {
      return;
    }
    final response = await AppWriteController.to
        .readNotification([notification.id], user.userId);
    logger.d(response.message);
    if (response.isSuccess) {
      listNotification();
    }
  }

  void intitialNotification() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  @override
  void onInit() {
    listNews();
    listPromotions();
    listNotification();
    super.onInit();
  }
}
