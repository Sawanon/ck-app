import 'package:get/get.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/couldflare/view/cloudflare.dart';
import 'package:lottery_ck/modules/layout/view/layout.dart';
import 'package:lottery_ck/modules/login/view/login.dart';
import 'package:lottery_ck/modules/otp/view/otp.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
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
      ];
}
