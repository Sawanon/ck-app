import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_auth.controller.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/login/controller/login.controller.dart';
import 'package:lottery_ck/modules/otp/controller/otp.controller.dart';
import 'package:lottery_ck/modules/signup/controller/signup.controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<FirebaseMessagingController>(FirebaseMessagingController());
    Get.put<FirebaseAuthController>(FirebaseAuthController());
    Get.put<AppWriteController>(AppWriteController());
    Get.put<LayoutController>(LayoutController());
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SignupController>(() => SignupController(), fenix: true);
    Get.lazyPut<OtpController>(() => OtpController(), fenix: true);
  }
}
