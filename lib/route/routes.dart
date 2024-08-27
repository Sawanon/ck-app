import 'package:get/get.dart';
import 'package:lottery_ck/binding/initial.binding.dart';
import 'package:lottery_ck/modules/bill/view/bill.dart';
import 'package:lottery_ck/modules/couldflare/view/cloudflare.dart';
import 'package:lottery_ck/modules/layout/view/layout.dart';
import 'package:lottery_ck/modules/login/view/login.dart';
import 'package:lottery_ck/modules/otp/view/otp.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/modules/payment/view/payment.dart';
import 'package:lottery_ck/modules/pin/view/pin.dart';
import 'package:lottery_ck/modules/point/view/point.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/modules/splash_screen/view/splash_screen.dart';
import 'package:lottery_ck/route/route_name.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.layout,
          page: () => LayoutPage(),
          binding: LoggedInBinding(),
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
      ];
}
