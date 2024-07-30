import 'package:get/get.dart';
import 'package:lottery_ck/modules/layout/view/layout.dart';
import 'package:lottery_ck/modules/login/view/login.dart';
import 'package:lottery_ck/modules/login/view/login_appwrite.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/route/route_name.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.layout,
          page: () => LayoutPage(),
        ),
        GetPage(
          name: RouteName.loginAppwrite,
          page: () => LoginAppwritePage(),
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
      ];
}
