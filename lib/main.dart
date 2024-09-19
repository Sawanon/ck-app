import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/route_manager.dart';
import 'package:lottery_ck/binding/initial.binding.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/route/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottery_ck/utils.dart';
import 'firebase_options.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'firebase_options.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:upgrader/upgrader.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  checkDeeplink();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future checkDeeplink() async {
  // StreamSubscription _sub;
  try {
    logger.d("checkDeeplink");
    // await getInitialLink();
    final _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen(
      (uri) {
        if (uri.path == "/payment") {
          final invoiceId = uri.queryParameters['invoiceId'];
          PaymentController.to.showBill(invoiceId!);
        }
      },
    );
  } on PlatformException {
    logger.d("PlatformException");
  } catch (e) {
    logger.d("error checkDeeplink $e");
  }
}

mixin AppLocale {
  static const String home = 'ໜ້າຫຼັກ';
  static const String history = 'ປະຫວັດ';
  static const String buyLottery = 'ຊື້ຫວຍ';
  static const String notification = 'ແຈ້ງເຕືອນ';
  static const String setting = 'ຕັ້ງຄ່າ';
  static const String horoscope = 'ດູດວງ';
  static const String wallpaper = 'ຮູບວໍເປເປີ';
  static const String lotteryResult = 'ຜົນຫວຍ';
  static const String animal = 'ຕໍາຣາ';
  static const String lotteryDateAt = 'ງວດວັນທີ';

  static const Map<String, dynamic> LO = {
    home: 'ໜ້າຫຼັກ',
    history: 'ປະຫວັດ',
    buyLottery: 'ຊື້ຫວຍ',
    notification: 'ແຈ້ງເຕືອນ',
    setting: 'ຕັ້ງຄ່າ',
    horoscope: 'ດູດວງ',
    wallpaper: 'ຮູບວໍເປເປີ',
    lotteryResult: 'ຜົນຫວຍ',
    animal: 'ຕໍາຣາ',
    lotteryDateAt: 'ງວດວັນທີ',
  };
  static const Map<String, dynamic> TH = {
    home: 'หน้าแรก',
    history: 'ประวัติ',
    buyLottery: 'ซื้อหวย',
    notification: 'แจ้งเตือน',
    setting: 'ตั้งค่า',
    horoscope: 'ดูดวง',
    wallpaper: 'วอลเปเปอร์',
    lotteryResult: 'ผลหวย',
    animal: 'ตำรา',
    lotteryDateAt: 'งวดวันที่',
  };
  static const Map<String, dynamic> EN = {
    home: 'Home',
    history: 'History',
    buyLottery: 'Lottery',
    notification: 'Notification',
    setting: 'Setting',
    horoscope: 'Horoscope',
    wallpaper: 'Wallpaper',
    lotteryResult: 'Lottery result',
    animal: 'Animal',
    lotteryDateAt: 'lottery date',
  };
}

final FlutterLocalization localization = FlutterLocalization.instance;

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       onInit: () {
//         localization.init(
//           mapLocales: [
//             const MapLocale('en', AppLocale.EN),
//             const MapLocale('km', AppLocale.KM),
//             const MapLocale('ja', AppLocale.JA),
//           ],
//           initLanguageCode: 'en',
//         );
//         localization.onTranslatedLanguage = _onTranslatedLanguage;
//       },
//       title: 'Lotto',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
//         useMaterial3: true,
//       ),
//       initialBinding: InitialBinding(),
//       getPages: AppRoutes.appRoutes(),
//       initialRoute: RouteName.splashScreen,
//       localizationsDelegates: [
//         // AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale('lo', AppLocale.LO),
        const MapLocale('th', AppLocale.TH),
        const MapLocale('en', AppLocale.EN),
      ],
      initLanguageCode: 'lo',
    );
    localization.onTranslatedLanguage = _onTranslatedLanguage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lotto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      initialBinding: InitialBinding(),
      getPages: AppRoutes.appRoutes(),
      initialRoute: RouteName.splashScreen,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      // localizationsDelegates: [
      //   // AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      // ],
    );
  }
}
