import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:lottery_ck/binding/initial.binding.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/route/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lottery_ck/utils.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  checkDeeplink();
  runApp(const MyApp());
}

Future checkDeeplink() async {
  StreamSubscription _sub;
  try {
    print("checkDeeplink");
    // await getInitialLink();
    final _appLinks = AppLinks();
    final link = await _appLinks.getInitialLinkString();
    logger.d("link: $link");
    _appLinks.uriLinkStream.listen(
      (event) {
        logger.d(event);
      },
    );
    // _appLinks.
    // _sub = uriLinkStream.listen((event) {
    //   // print('path: ${event?.path} , ${event?.pathSegments}');
    //   // print('event 42: ${event}');
    //   if (event != null) {
    //     // TODO: get.name to home page with some param
    //     // print('gogo');
    //     Get.toNamed(RouteName.callback, arguments: [event]);
    //     // print('gogo2');
    //   }
    // }, onError: (error) {
    //   print('error 44 $error');
    // });
    // _sub = linkStream.listen((event) {
    //   print('uri: $event');
    // }, onError: (err) {
    //   print('error 43 checkDeeplink: $err');
    // });
  } on PlatformException {
    logger.d("PlatformException");
  } catch (e) {
    logger.d("error checkDeeplink $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return GetMaterialApp.router(
    //   title: 'Lotto',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
    //     useMaterial3: true,
    //   ),
    //   // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    //   // home: LoginPage(),
    //   initialBinding: InitialBinding(),
    //   getPages: AppRoutes.appRoutes(),

    //   initialRoute: RouteName.layout,
    // );
    return GetMaterialApp(
      title: 'Lotto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home: LoginPage(),
      initialBinding: InitialBinding(),
      getPages: AppRoutes.appRoutes(),
      initialRoute: RouteName.splashScreen,
    );
  }
}
