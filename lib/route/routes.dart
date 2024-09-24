import 'package:get/get.dart';
import 'package:lottery_ck/binding/initial.binding.dart';
import 'package:lottery_ck/modules/animal/view/animal.dart';
import 'package:lottery_ck/modules/bill/view/bill.dart';
import 'package:lottery_ck/modules/biometrics/view/enable_biometrics.dart';
import 'package:lottery_ck/modules/couldflare/view/cloudflare.dart';
import 'package:lottery_ck/modules/history/view/win_bill.dart';
import 'package:lottery_ck/modules/layout/view/layout.dart';
import 'package:lottery_ck/modules/login/view/login.dart';
import 'package:lottery_ck/modules/notification/view/news.dart';
import 'package:lottery_ck/modules/notification/view/promotion.dart';
import 'package:lottery_ck/modules/otp/view/otp.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/modules/payment/view/payment.dart';
import 'package:lottery_ck/modules/pin/view/pin.dart';
import 'package:lottery_ck/modules/pin/view/pin_verify.dart';
import 'package:lottery_ck/modules/point/view/point.dart';
import 'package:lottery_ck/modules/setting/view/profile.dart';
import 'package:lottery_ck/modules/setting/view/security.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/modules/splash_screen/view/splash_screen.dart';
import 'package:lottery_ck/route/route_name.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.layout,
          page: () => LayoutPage(),
          binding: LayoutBindings(),
        ),
        GetPage(
          name: RouteName.login,
          page: () => LoginPage(),
        ),
        GetPage(
          name: RouteName.signup,
          page: () => SignupPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.otp,
          page: () => OtpPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.cloudflare,
          page: () => CloudFlarePage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.pin,
          page: () => PinPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.splashScreen,
          page: () => SplashScreenPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.payment,
          page: () => PayMentPage(),
          transition: Transition.rightToLeft,
          binding: BindingsBuilder(
            () {
              Get.lazyPut<PaymentController>(
                () => PaymentController(),
                fenix: true,
              );
            },
          ),
        ),
        GetPage(
          name: RouteName.bill,
          page: () => BillPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.point,
          page: () => PointPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.enableBiometrics,
          page: () => EnableBiometricsPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.news,
          page: () => NewsDetailPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.promotion,
          page: () => PromotionDetailPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.winbill,
          page: () => WinBillPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.pinVerify,
          page: () => PinVerifyPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.animal,
          page: () => AnimalPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.security,
          page: () => SecurityPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.profile,
          page: () => ProfilePage(),
          transition: Transition.rightToLeft,
        ),
      ];
}
