import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:lottery_ck/binding/initial.binding.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
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
