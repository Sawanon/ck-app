import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/bill/controller/bill.controller.dart';
import 'package:lottery_ck/modules/biometrics/controller/enable_biometrics.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/couldflare/controller/cloudflare.controller.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_auth.controller.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/modules/history/controller/history.controller.dart';
import 'package:lottery_ck/modules/history/controller/history_buy.controller.dart';
import 'package:lottery_ck/modules/history/controller/history_win.controller.dart';
import 'package:lottery_ck/modules/history/controller/win_bill.contoller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/login/controller/login.controller.dart';
import 'package:lottery_ck/modules/lottery_history/controller/lottery_history.controller.dart';
import 'package:lottery_ck/modules/network/controller/network.controller.dart';
import 'package:lottery_ck/modules/notification/controller/news.controller.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/modules/notification/controller/promotion.controller.dart';
import 'package:lottery_ck/modules/otp/controller/otp.controller.dart';
import 'package:lottery_ck/modules/pin/controller/pin.controller.dart';
import 'package:lottery_ck/modules/pin/controller/pin_verify.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/signup/controller/signup.controller.dart';
import 'package:lottery_ck/modules/splash_screen/controller/splash_screen.controller.dart';
import 'package:lottery_ck/repository/user_repository/user.repository.dart';
import 'package:lottery_ck/storage.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<SplashScreenController>(() => SplashScreenController());
    Get.put<SplashScreenController>(SplashScreenController());
  }
}

class LayoutBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<StorageController>(StorageController());
    Get.put<FirebaseMessagingController>(FirebaseMessagingController());
    Get.put<FirebaseAuthController>(FirebaseAuthController());
    Get.put<AppWriteController>(AppWriteController());
    Get.put<UserStore>(UserStore());
    Get.put<LayoutController>(LayoutController());
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
    Get.lazyPut<OtpController>(() => OtpController(), fenix: true);
    Get.put<HomeController>(HomeController());
    Get.put<BuyLotteryController>(BuyLotteryController());
    // Get.lazyPut<SettingController>(() => SettingController(), fenix: true);
    Get.put<SettingController>(SettingController());
    Get.lazyPut<CloudFlareController>(() => CloudFlareController(),
        fenix: true);
    Get.lazyPut<PinController>(() => PinController(), fenix: true);
    Get.lazyPut<PinVerifyController>(() => PinVerifyController(), fenix: true);
    Get.lazyPut<BillController>(() => BillController(), fenix: true);
    Get.lazyPut<EnableBiometricsController>(() => EnableBiometricsController(),
        fenix: true);
    // Get.lazyPut<NotificationController>(() => NotificationController(),
    //     fenix: true);
    Get.put<NotificationController>(NotificationController());
    Get.lazyPut<NewsController>(() => NewsController(), fenix: true);
    Get.lazyPut<PromotionController>(() => PromotionController(), fenix: true);
    Get.lazyPut<WinBillContoller>(() => WinBillContoller(), fenix: true);
    Get.put<LotteryHistoryController>(LotteryHistoryController());
    Get.lazyPut<HistoryController>(() => HistoryController(), fenix: true);
    Get.put<HistoryWinController>(HistoryWinController());
    Get.put<NetworkController>(NetworkController());
  }
}
