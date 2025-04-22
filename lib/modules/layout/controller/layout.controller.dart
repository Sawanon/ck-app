import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/cart.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/model/get_argument/otp.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery.page.dart';
import 'package:lottery_ck/modules/history/view/history.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/home/view/home.dart';
import 'package:lottery_ck/modules/home/view/home.v2.dart';
import 'package:lottery_ck/modules/kyc/view/ask_kyc_dialog.dart';
import 'package:lottery_ck/modules/notification/view/notification.dart';
import 'package:lottery_ck/modules/pin/controller/passcode_verify.controller.dart';
import 'package:lottery_ck/modules/pin/controller/pin_verify.controller.dart';
import 'package:lottery_ck/modules/pin/view/pin_verify.dart';
import 'package:lottery_ck/modules/point/view/bill_point.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/setting/view/setting.dart';
import 'package:lottery_ck/modules/splash_screen/controller/splash_screen.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

enum TabApp { home, history, lottery, notifications, settings }

class LayoutController extends GetxController with WidgetsBindingObserver {
// class LayoutController extends GetxController {
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
  List<String> backgroundThemeList = [];
  bool isSessionTimeout = false;

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

  Widget renderMyCart(TabApp tab) {
    if (tab == TabApp.home || tab == TabApp.lottery) {
      // if (tab == TabApp.home) {
      return const SizedBox.shrink();
    }
    return const CartComponent();
  }

  Widget currentPage(TabApp tab) {
    // logger.d("current tab change :$tab");
    switch (tab) {
      case TabApp.home:
        return const HomePageV2();
      // return const HomePage();
      case TabApp.history:
        return const HistoryPage();
      case TabApp.lottery:
        // return const LotteryHistoryPage();
        return const BuyLotteryPage();
      case TabApp.notifications:
        return const SettingPage();
      case TabApp.settings:
        return const NotificationPage();
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
                  onPressed: () async {
                    // navigator?.pop();
                    Get.back();
                    await Future.delayed(
                      const Duration(milliseconds: 250),
                      () {
                        Get.toNamed(RouteName.login);
                      },
                    );
                    // Get.toNamed(
                    //   RouteName.otp,
                    //   arguments: OTPArgument(
                    //     action: OTPAction.signIn,
                    //     phoneNumber: '',
                    //     onInit: () async {
                    //       logger.d("init");
                    //       return 'boom';
                    //     },
                    //     whenConfirmOTP: (otp) async {
                    //       logger.d("confirm");
                    //     },
                    //   ),
                    // );
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

  void showDialogKYC() async {
    final user = SettingController.to.user;
    final kycData = SettingController.to.kycData;
    final kycLater = await StorageController.to.getKYCLater();
    final kycLaterDate = kycLater != null ? DateTime.parse(kycLater) : null;
    final isShouldShow =
        kycLaterDate == null ? true : kycLaterDate.day != DateTime.now().day;
    if (user == null) return;
    if (user.isKYC == null || user.isKYC == false) {
      if (kycData == null) {
        if (isShouldShow) {
          Get.dialog(
            const AskKycDialog(),
          );
        }
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
        // onChangeTabIndex(tab);
        if (!isUserLogined) {
          showDialogLogin();
          return;
        }
        Get.toNamed(RouteName.scanQR);
        break;
      case TabApp.settings:
        onChangeTabIndex(tab);
        // if (!isUserLogined) {
        //   showDialogLogin();
        //   return;
        // }
        // final isPass = await requestBioMetrics();
        // if (isPass) {
        //   onChangeTabIndex(tab);
        //   showDialogKYC();
        // }
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
      isUsedBiometrics = true;
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

  void actionWithPath() async {
    final uri = SplashScreenController.to.openPath;
    logger.d("uri?.path: ${uri?.path}");
    if (uri == null) return;
    BuyLotteryController.to.setDisablePopup(true);
    if (uri.path.contains("/payment")) {
      final userApp = await AppWriteController.to.getUserApp();
      if (userApp == null) return;
      final invoiceId = uri.queryParameters['invoiceId'];
      logger.f("invoiceId: $invoiceId");
      final lotteryStr =
          uri.queryParameters['lotteryStr'] ?? HomeController.to.lotteryDateStr;
      logger.f(
          "uri.queryParameters['lotteryStr']: ${uri.queryParameters['lotteryStr']}");
      logger.f(
          "HomeController.to.lotteryDateStr: ${HomeController.to.lotteryDateStr}");
      if (invoiceId == null || lotteryStr == null) {
        Get.rawSnackbar(message: "lotteryStr is empty");
        return;
      }
      final invoiceDocument =
          await AppWriteController.to.getInvoice(invoiceId, lotteryStr);
      // Get.rawSnackbar(message: "invoiceDocument $invoiceDocument");
      logger.w(invoiceDocument?.data);
      if (invoiceDocument == null) {
        Get.rawSnackbar(message: "invoiceDocument is empty");
        return;
      }
      final lotteryList = await AppWriteController.to
          .listTransactionByInvoiceId(invoiceId, lotteryStr);
      final bank = await AppWriteController.to
          .getBankById(invoiceDocument.data['bankId']);
      if (lotteryList == null) {
        // Get.rawSnackbar(message: "lotteryList is empty");
        return;
      }
      final cloneUserApp = userApp;
      final bill = Bill(
        firstName: cloneUserApp.firstName,
        lastName: cloneUserApp.lastName,
        phoneNumber: cloneUserApp.phoneNumber,
        dateTime: DateTime.parse(invoiceDocument.data['\$createdAt']),
        lotteryDateStr: lotteryStr,
        lotteryList: lotteryList,
        totalAmount: invoiceDocument.data['totalAmount'].toString(),
        amount: invoiceDocument.data['amount'],
        billId: invoiceDocument.data['billNumber'] ?? "-",
        bankName: bank?.fullName ?? "-",
        customerId: cloneUserApp.customerId ?? "-",
        discount: invoiceDocument.data['discount'],
      );
      Get.toNamed(
        RouteName.bill,
        arguments: {
          "bill": bill,
          "onClose": () {
            Get.back();
          }
        },
      );
    } else if (uri.path.contains("/point/topup")) {
      final invoiceId = uri.queryParameters['invoiceId'];
      Get.dialog(
        BillPoint(onBackHome: () {
          Get.back();
          Get.back();
        }, onBuyAgain: () {
          Get.back();
        }),
      );
    }
  }

  Future<void> listBackgroundTheme() async {
    final backgroundThemeList =
        await AppWriteController.to.getBackgroundTheme();
    if (backgroundThemeList == null) return;
    this.backgroundThemeList = backgroundThemeList;
    update();
  }

  String? randomBackgroundThemeUrl() {
    final random = Random();
    if (backgroundThemeList.isEmpty) {
      return null;
    }
    final randomNumber = random.nextInt(backgroundThemeList.length);
    return backgroundThemeList[randomNumber];
  }

  Future<void> restartApp() async {
    Get.offAllNamed(RouteName.splashScreen);
    Future.delayed(const Duration(milliseconds: 350), () {
      Get.put<SplashScreenController>(SplashScreenController());
      SplashScreenController.to.onInit();
    });
  }

  @override
  void onReady() {
    super.onReady();
    actionWithPath();
  }

  @override
  void onInit() {
    super.onInit();
    checkUser();
    listenNetworkEvents();
    listBackgroundTheme();
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
    // get sesssion time out
    // var future = Future.delayed(const Duration(seconds: 5));
    var future = Future.delayed(const Duration(minutes: 5));
    logger.d("useBiometricsTimeout: $useBiometricsTimeout");
    if (useBiometricsTimeout != null) return;
    logger.d("startCountdownBiometrics");
    useBiometricsTimeout = future.asStream().listen(
      (event) {
        logger.w("biometrics timeout");
        isUsedBiometrics = false;
        isSessionTimeout = true;
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
    showDialogVerifyPasscode();
  }

  void showDialogVerifyPasscode() async {
    final user = SettingController.to.user;
    if (user == null) {
      return;
    }
    if (isSessionTimeout == true) {
      Get.lazyPut(() => PasscodeVerifyController(), fenix: true);
      final controller = PasscodeVerifyController.to;
      screenLock(
        context: Get.context!,
        correctString: 'aaaaaa',
        canCancel: false,
        footer: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: GestureDetector(
            onTap: () {
              logger.d("message received");
              controller.forgetPasscode(
                user.phoneNumber,
                user.userId,
                () {
                  restartApp();
                  isSessionTimeout = false;
                  isUsedBiometrics = true;
                },
              );
            },
            child: Text(
              "${AppLocale.forgetPasscode.getString(Get.context!)}?",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                decoration: TextDecoration.underline,
                decorationThickness: 2,
                decorationColor: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        maxRetries: controller.maxRetry,
        delayBuilder: (context, delay) {
          return Text(
            controller.delayMessage ?? "-",
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.errorBorder,
            ),
          );
        },
        onValidate: (passcode) async {
          return await controller.verifyPasscode(passcode, user.userId);
        },
        onUnlocked: () {
          Get.delete<PasscodeVerifyController>();
          restartApp();
          isSessionTimeout = false;
          isUsedBiometrics = true;
          // PasscodeVerifyController
        },
        useBlur: false,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocale.confirmYourPasscode.getString(Get.context!),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            if (controller.errorMessage != null) ...[
              Text(
                controller.errorMessage!,
                style: const TextStyle(
                  color: AppColors.errorBorder,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              height: 24,
              width: 24,
              child: Obx(() {
                if (controller.pendingVerify.value) {
                  return const CircularProgressIndicator(
                    color: AppColors.primary,
                  );
                }
                return const SizedBox.shrink();
              }),
            )
          ],
        ),
        secretsConfig: SecretsConfig(
          padding: const EdgeInsets.all(24),
          spacing: 16,
          secretConfig: SecretConfig(
            builder: (context, config, enabled) {
              return Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: enabled ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    width: 1,
                    color: enabled ? Colors.transparent : AppColors.disableText,
                  ),
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ),
        customizedButtonChild: SizedBox(
          width: 60,
          height: 60,
          child: SvgPicture.asset(
            AppIcon.fingerScan,
            fit: BoxFit.fitWidth,
          ),
        ),
        customizedButtonTap: () {
          controller.useBiometrics();
        },
        keyPadConfig: KeyPadConfig(
          actionButtonConfig: KeyPadButtonConfig(
              buttonStyle: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.white),
            foregroundColor: WidgetStateProperty.all(AppColors.textPrimary),
          )),
          buttonConfig: KeyPadButtonConfig(
            // backgroundColor: Colors.white,
            buttonStyle: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.white),
              foregroundColor: WidgetStateProperty.all(AppColors.textPrimary),
            ),
          ),
        ),
        config: ScreenLockConfig(
          backgroundColor: Colors.white,
          // titleTextStyle: TextStyle(
          //   fontSize: 32,
          //   fontWeight: FontWeight.w700,
          // ),
          // textStyle: TextStyle(
          //   color: Colors.red,
          // ),
          // buttonStyle: ButtonStyle(
          //   backgroundColor: WidgetStateProperty.all(
          //     Colors.amber,
          //   ),
          // ),
        ),
      );
      // Get.dialog(
      //   const PinVerifyPage(
      //     disabledBackButton: true,
      //   ),
      //   arguments: {
      //     "userId": user.userId,
      //     "whenSuccess": () {
      //       logger.d("whenSuccess");
      //       restartApp();
      //       isSessionTimeout = false;
      //       isUsedBiometrics = true;
      //     },
      //     "enableForgetPasscode": true,
      //     "whenForgetPasscode": () {
      //       logger.d("whenForgetPasscode");
      //     }
      //   },
      // );
    }
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
