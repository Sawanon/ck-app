import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/couldflare/controller/cloudflare.controller.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_auth.controller.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/login/controller/login.controller.dart';
import 'package:lottery_ck/modules/otp/controller/otp.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/signup/controller/signup.controller.dart';
import 'package:lottery_ck/repository/user_repository/user.repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
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
    // Get.lazyPut<BuyLotteryController>(() => BuyLotteryController(),
    //     fenix: true);
    Get.lazyPut<SettingController>(() => SettingController(), fenix: true);
    Get.lazyPut<CloudFlareController>(() => CloudFlareController(),
        fenix: true);
  }
}
