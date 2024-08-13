import 'package:get/get.dart';
import 'package:lottery_ck/middleware/turnstile.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery_page.dart';
import 'package:lottery_ck/modules/couldflare/controller/cloudflare.controller.dart';
import 'package:lottery_ck/modules/couldflare/view/cloudflare.dart';
import 'package:lottery_ck/modules/layout/view/layout.dart';
import 'package:lottery_ck/modules/login/view/login.dart';
import 'package:lottery_ck/modules/otp/view/otp.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/modules/payment/view/payment.dart';
import 'package:lottery_ck/modules/pin/controller/pin.controller.dart';
import 'package:lottery_ck/modules/pin/view/pin.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/modules/splash_screen/view/splash_screen.dart';
import 'package:lottery_ck/repository/user_repository/user.repository.dart';
import 'package:lottery_ck/route/route_name.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.layout,
          page: () => LayoutPage(),
          binding: BindingsBuilder(
            () {
              Get.put<BuyLotteryController>(BuyLotteryController());
              Get.put<UserStore>(UserStore());
            },
          ),
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
          name: RouteName.buyLottery,
          page: () => BuyLotteryPage(),
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
            )),
      ];
}
