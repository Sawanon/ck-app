import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:lottery_ck/binding/initial.binding.dart';
import 'package:lottery_ck/modules/login/controller/login.controller.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/modules/splash_screen/controller/splash_screen.controller.dart';
import 'package:lottery_ck/modules/splash_screen/view/splash_screen.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottery_ck/utils.dart';
import 'package:upgrader/upgrader.dart';
import 'firebase_options.dart';

// import 'package:flutter_localizations/flutter_localizations.dart';
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
  // await Upgrader.clearSavedSettings(); // REMOVE this for release builds
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await checkDeeplink();
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
        } else if (uri.path == "/bypass/4258c57e54eaeaf3") {
          Get.put(SplashScreenController());
          SplashScreenController.to.bypass();
        }
      },
    );
  } on PlatformException {
    logger.d("PlatformException");
  } catch (e) {
    logger.d("error checkDeeplink $e");
  }
}

final FlutterLocalization localization = FlutterLocalization.instance;

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
      // initialRoute: RouteName.splashScreen,
      home: UpgradeAlert(
        child: SplashScreenPage(),
      ),
      // initialRoute: '/test',
      debugShowCheckedModeBanner: false,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
    );
  }
}
