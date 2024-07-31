import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottery_ck/binding/initial.binding.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/route/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lotto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home: LoginPage(),
      initialBinding: InitialBinding(),
      getPages: AppRoutes.appRoutes(),
      initialRoute: RouteName.layout,
    );
  }
}
