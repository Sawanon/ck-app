import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/blur_app.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/components/no_network_dialog.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery.page.dart';
import 'package:lottery_ck/modules/history/controller/history.controller.dart';
import 'package:lottery_ck/modules/history/view/history.dart';
import 'package:lottery_ck/modules/home/view/home.dart';
import 'package:lottery_ck/modules/kyc/view/ask_kyc_dialog.dart';
import 'package:lottery_ck/modules/lottery_history/view/lottery_history.dart';
import 'package:lottery_ck/modules/notification/view/notification.dart';
import 'package:lottery_ck/modules/pin/view/pin_verify.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/setting/view/setting.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/logo.dart';
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
  StreamSubscription<List<ConnectivityResult>>? subscriptionNetwork;
  bool noNetwork = false;
  bool isBlur = false;
  StreamSubscription? useBiometricsTimeout;
  UserApp? userApp;

  void clearState() {
    isUsedBiometrics = false;
    isUserLogined = false;
  }

  void onChangeTabIndex(TabApp tab) {
    currentTab = tab;
    update();
  }

  Future<bool> requestBioMetrics() async {
    logger.d("request bio");
    logger.d("isUsedBiometrics :$isUsedBiometrics");
    if (isUsedBiometrics) {
      return true;
    }
    bool isEnable = await CommonFn.requestBiometrics();
    logger.d("isEnable: $isEnable");
    if (!isEnable) {
      await Get.dialog(
        PinVerifyPage(),
        arguments: {
          "userId": userApp?.userId,
          "whenSuccess": () {
            logger.d("success");
            Get.back();
            isEnable = true;
          },
          "enableBiometrics": true,
        },
        useSafeArea: false,
        // transitionDuration: Duration(milliseconds: 100),
      );
    }
    isUsedBiometrics = isEnable;
    logger.w("isUsedBiometrics: $isUsedBiometrics");
    return isEnable;
  }

  Widget currentPage(TabApp tab) {
    // logger.d("current tab change :$tab");
    switch (tab) {
      case TabApp.home:
        return const HomePage();
      case TabApp.history:
        return const HistoryPage();
      case TabApp.lottery:
        // return const LotteryHistoryPage();
        return const BuyLotteryPage();
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
                    "ເຂົ້າສູ່ລະບົບ",
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

  void showDialogKYC() {
    final user = SettingController.to.user;
    final kycData = SettingController.to.kycData;
    if (user == null) return;
    if (user.isKYC == null || user.isKYC == false) {
      if (kycData == null) {
        Get.dialog(
          const AskKycDialog(),
        );
      }
    }
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
        logger.w("isPass: $isPass");
        if (isPass) {
          onChangeTabIndex(tab);
          showDialogKYC();
        }
        break;
      case TabApp.lottery:
        BuyLotteryController.to.chnageParentTab(0);
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
          showDialogKYC();
        }
        break;
    }
  }

  void removePaddingBottom() {
    // logger.d("removePaddingBottom");
    bottomPadding = 0;
    update();
  }

  void resetPaddingBottom() {
    // logger.d("resetPaddingBottom");
    bottomPadding = 74;
    update();
  }

  void intialApp() async {
    try {
      await checkUser();
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  void listenNetworkEvents() {
    subscriptionNetwork = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        noNetwork = true;
        update();
      } else if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        noNetwork = false;
        update();
      }
    });
  }

  Future<void> checkUser() async {
    try {
      // logger.d("checkUser");
      userApp = await AppWriteController.to.getUserApp();
      if (userApp == null) {
        throw "userApp is null";
      }
      isUserLogined = true;
    } catch (e) {
      logger.e("log out auto");
      SettingController.to.logout();
    }
  }

  @override
  void onInit() {
    super.onInit();
    checkUser();
    listenNetworkEvents();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    subscriptionNetwork?.cancel();
    isUsedBiometrics = false;
    super.onClose();
  }

  // void openBlur() async {
  //   final id = await Get.dialog(
  //     BlurApp(identifier: 'blurapp'),
  //     useSafeArea: false,
  //     barrierDismissible: false,
  //   );
  //   logger.d("id: $id");
  //   blurId = id;
  // }

  // void closeBlur() {
  //   Get.close(1, blurId);
  // }

  void startCountdownBiometrics() {
    var future = Future.delayed(const Duration(seconds: 10));
    logger.d("useBiometricsTimeout: $useBiometricsTimeout");
    if (useBiometricsTimeout != null) return;
    logger.d("startCountdownBiometrics");
    useBiometricsTimeout = future.asStream().listen(
      (event) {
        logger.w("biometrics timeout");
        isUsedBiometrics = false;
        logger.d("isUsedBiometrics: $isUsedBiometrics");
        useBiometricsTimeout = null;
        changeTab(TabApp.home);
      },
    );
    update();
  }

  void cancelCountdownBiometrics() {
    useBiometricsTimeout?.cancel();
    useBiometricsTimeout = null;
  }

  void onResume() async {
    cancelCountdownBiometrics();
    isBlur = false;
    update();
    BuyLotteryController.to.getQuota();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.w(state);
    // TODO: priority high - sawanon:20240814
    switch (state) {
      case AppLifecycleState.inactive:
        // change background to other image
        startCountdownBiometrics();
        isBlur = true;
        update();
        break;
      case AppLifecycleState.paused:
        // stop something
        break;
      case AppLifecycleState.resumed:
        // do something when back to app
        onResume();
        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
