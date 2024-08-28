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
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/login/controller/login.controller.dart';
import 'package:lottery_ck/modules/otp/controller/otp.controller.dart';
import 'package:lottery_ck/modules/pin/controller/pin.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/signup/controller/signup.controller.dart';
import 'package:lottery_ck/modules/splash_screen/controller/splash_screen.controller.dart';
import 'package:lottery_ck/repository/user_repository/user.repository.dart';
import 'package:lottery_ck/storage.dart';

class InitialBinding extends Bindings {
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
    Get.lazyPut<SettingController>(() => SettingController(), fenix: true);
    Get.lazyPut<CloudFlareController>(() => CloudFlareController(),
        fenix: true);
    Get.lazyPut<PinController>(() => PinController(), fenix: true);
    // Get.lazyPut<SplashScreenController>(() => SplashScreenController());
    Get.put<SplashScreenController>(SplashScreenController());
    Get.lazyPut<BillController>(() => BillController(), fenix: true);
    Get.lazyPut<EnableBiometricsController>(() => EnableBiometricsController());
  }
}

class LoggedInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(() => HistoryController(), fenix: true);
    Get.put<UserStore>(UserStore());
    Get.put<HistoryBuyController>(HistoryBuyController());
  }
}
