import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:byteplus_vod/ve_vod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottery_ck/binding/initial.binding.dart';
import 'package:lottery_ck/modules/splash_screen/controller/splash_screen.controller.dart';
import 'package:lottery_ck/modules/splash_screen/view/splash_screen.dart';
import 'package:lottery_ck/modules/wheel/wheel_page.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottery_ck/utils.dart';
import 'package:upgrader/upgrader.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> initTTSDK() async {
  // Enable logging
  if (kDebugMode) {
    // FlutterTTSDKManager.openAllLog();
  }
  // Register plugin logs
  // TTFLogger.onLog = (logLevel, msg) {
  //   logger.d(msg);
  // };

  // Provide a valid license file path, such as 'assets/VEVod.lic'
  String licPath = 'assets/VEVod.lic';
  // For Android, provide a valid channel ID for statistics; for iOS, it is optional and defaults to App Store
  String channel = Platform.isAndroid ? 'Dev' : 'App Store';
  // Initialize VOD configuration
  TTSDKVodConfiguration vodConfig = TTSDKVodConfiguration();
  // Set the maximum cache size, default is 100M, adjust according to your own business scenario, cache eviction is performed based on LRU rules when the cache size exceeds the maximum size
  vodConfig.cacheMaxSize = 300 * 1024 * 1024;

  // Provide the AppID obtained from the BytePlus VOD console
  TTSDKConfiguration sdkConfig =
      TTSDKConfiguration.defaultConfigurationWithAppIDAndLicPath(
    appID: '678725',
    licenseFilePath: licPath,
    channel: channel,
  );
  sdkConfig.vodConfiguration = vodConfig;
  FlutterTTSDKManager.startWithConfiguration(sdkConfig);

  // If you need to support multiple regions, please submit a ticket to contact technical support
  FlutterTTSDKManager.setCurrentUserUniqueID('devdevice');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings(); // REMOVE this for release builds
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await checkDeeplink();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initTTSDK();
  setupLocalNotification();

  runApp(const MyApp());
}

Future<void> setupLocalNotification() async {
  // ตั้งค่า Notification สำหรับ Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
}

Future checkDeeplink() async {
  try {
    final _appLinks = AppLinks();
    _appLinks.uriLinkStream.listen(
      (uri) {
        Get.put(SplashScreenController());
        SplashScreenController.to.updateUrlPath(uri);
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

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(brightness: brightness);

    return baseTheme.copyWith(
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lotto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        textTheme: GoogleFonts.promptTextTheme(),
      ),
      initialBinding: InitialBinding(),
      getPages: AppRoutes.appRoutes(),
      // initialRoute: RouteName.splashScreen,
      // home: KYCPage(),
      home: UpgradeAlert(
        barrierDismissible: false,
        showReleaseNotes: true,
        upgrader: Upgrader(
          willDisplayUpgrade: (
              {required display, installedVersion, versionInfo}) {
            logger.d("display: $display");
            // SplashScreenController.to.setStop(display);
            // SplashScreenController.to.checkNetWork();
          },
          minAppVersion: '2.0.0',
          debugLogging: true,
          // debugDisplayAlways: true,
          languageCode: 'en',
        ),
        child: SplashScreenPage(),
        // child: WheelPage(),
      ),
      // child: VideoToomany(),

      // initialRoute: '/test',
      debugShowCheckedModeBanner: false,
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
    );
  }
}
