import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/history/controller/history.controller.dart';
import 'package:lottery_ck/modules/history/view/history.dart';
import 'package:lottery_ck/modules/home/view/home.dart';
import 'package:lottery_ck/modules/lottery_history/view/lottery_history.dart';
import 'package:lottery_ck/modules/notification/view/notification.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/setting/view/setting.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

enum TabApp { home, history, lottery, notifications, settings }

class LayoutController extends GetxController with WidgetsBindingObserver {
  bool isUsedBiometrics = false;
  static LayoutController get to => Get.find();
  var tabIndex = 0;
  TabApp currentTab = TabApp.home;
  double bottomPadding = 74;
  bool isUserLogined = false;

  void onChangeTabIndex(TabApp tab) {
    currentTab = tab;
    update();
  }

  Future<bool> requestBioMetrics() async {
    if (isUsedBiometrics) {
      return true;
    }
    final isEnable = await CommonFn.requestBiometrics();
    isUsedBiometrics = isEnable;
    logger.w("isUsedBiometrics: $isUsedBiometrics");
    return isEnable;
  }

  Widget currentPage(TabApp tab) {
    switch (tab) {
      case TabApp.home:
        return const HomePage();
      case TabApp.history:
        return const HistoryPage();
      case TabApp.lottery:
        return const LotteryHistoryPage();
      case TabApp.notifications:
        return const NotificationPage();
      case TabApp.settings:
        return const SettingPage();
    }
  }

  void showDialogLogin() {
    Get.dialog(
      Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "ກະລຸນາເຂົ້າສູ່ລະບົບ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "ກະລຸນາເຂົ້າສູ່ລະບົບກ່ອນທີ່ຈະຊື້ຫວຍ.",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                LongButton(
                  onPressed: () {
                    navigator?.pop();
                    Get.toNamed(RouteName.login);
                  },
                  child: Text(
                    "LOG IN",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      useSafeArea: true,
    );
  }

  void changeTab(TabApp tab) async {
    switch (tab) {
      case TabApp.home:
        onChangeTabIndex(tab);
        break;
      case TabApp.history:
        if (!isUserLogined) {
          showDialogLogin();
          return;
        }
        final isPass = await requestBioMetrics();
        if (isPass) {
          onChangeTabIndex(tab);
        }
        break;
      case TabApp.lottery:
        onChangeTabIndex(tab);
        break;
      case TabApp.notifications:
        onChangeTabIndex(tab);
        break;
      case TabApp.settings:
        if (!isUserLogined) {
          showDialogLogin();
          return;
        }
        final isPass = await requestBioMetrics();
        if (isPass) {
          onChangeTabIndex(tab);
        }
        break;
    }
  }

  void removePaddingBottom() {
    logger.d("removePaddingBottom");
    bottomPadding = 0;
    update();
  }

  void resetPaddingBottom() {
    logger.d("resetPaddingBottom");
    bottomPadding = 74;
    update();
  }

  void checkUserLogin() async {
    try {
      await AppWriteController.to.user;
      isUserLogined = true;
    } catch (e) {
      logger.e("$e");
    }
  }

  void intialApp() async {
    try {
      await AppWriteController.to.user;
      isUserLogined = true;
      // HistoryController.to.setup();
      // SettingController.to.beforeSetup();
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    checkUserLogin();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.d(state);
    // TODO: priority high - sawanon:20240814
    switch (state) {
      case AppLifecycleState.inactive:
        // change background to other image
        break;
      case AppLifecycleState.paused:
        // stop something
        break;
      case AppLifecycleState.resumed:
        // do something when back to app
        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
