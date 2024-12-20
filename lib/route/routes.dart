import 'package:get/get.dart';
import 'package:lottery_ck/binding/initial.binding.dart';
import 'package:lottery_ck/modules/address/view/change_address.dart';
import 'package:lottery_ck/modules/animal/view/animal.dart';
import 'package:lottery_ck/modules/bill/view/bill.dart';
import 'package:lottery_ck/modules/biometrics/view/enable_biometrics.dart';
import 'package:lottery_ck/modules/couldflare/view/cloudflare.dart';
import 'package:lottery_ck/modules/history/view/win_bill.dart';
import 'package:lottery_ck/modules/horoscope_daily/view/horoscope_dialy.dart';
import 'package:lottery_ck/modules/kyc/view/kyc.dart';
import 'package:lottery_ck/modules/layout/view/layout.dart';
import 'package:lottery_ck/modules/login/view/login.dart';
import 'package:lottery_ck/modules/mmoney/view/confirm_otp.dart';
import 'package:lottery_ck/modules/notification/view/news.dart';
import 'package:lottery_ck/modules/notification/view/promotion.dart';
import 'package:lottery_ck/modules/notification/view/promotion_point_detail.dart';
import 'package:lottery_ck/modules/otp/view/otp.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/modules/payment/view/payment.dart';
import 'package:lottery_ck/modules/phone/view/change_phone.dart';
import 'package:lottery_ck/modules/pin/view/change_pin.dart';
import 'package:lottery_ck/modules/pin/view/pin.dart';
import 'package:lottery_ck/modules/pin/view/pin_verify.dart';
import 'package:lottery_ck/modules/point/view/point.dart';
import 'package:lottery_ck/modules/random/view/random.dart';
import 'package:lottery_ck/modules/scan/view/scan.dart';
import 'package:lottery_ck/modules/setting/view/change_birth.dart';
import 'package:lottery_ck/modules/setting/view/change_name.dart';
import 'package:lottery_ck/modules/setting/view/profile.dart';
import 'package:lottery_ck/modules/setting/view/security.dart';
import 'package:lottery_ck/modules/setting/view/setting.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/modules/splash_screen/view/splash_screen.dart';
import 'package:lottery_ck/modules/t_c/view/t_c.dart';
import 'package:lottery_ck/modules/test/video_toomany.dart';
import 'package:lottery_ck/modules/wallpaper/view/wallpaper.dart';
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
          name: RouteName.promotionPoint,
          page: () => PromotionPointDetailPage(),
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
        GetPage(
          name: RouteName.changePhone,
          page: () => ChangePhonePage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.changeAddress,
          page: () => ChangeAddressPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.confirmPaymentOTP,
          page: () => MonneyConfirmOTP(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/test',
          page: () => VideoToomany(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.changePasscode,
          page: () => ChangePasscode(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.wallpaper,
          page: () => WallpaperPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.random,
          page: () => RandomPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.changeName,
          page: () => ChangeNamePage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.changeBirth,
          page: () => const ChangeBirthPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.kyc,
          page: () => const KYCPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.tc,
          page: () => const TCPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.scanQR,
          page: () => const ScanQR(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.horoscopeDaily,
          page: () => const HoroscopeDialyPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.setting,
          page: () => const SettingPage(),
          transition: Transition.rightToLeft,
        ),
      ];
}
