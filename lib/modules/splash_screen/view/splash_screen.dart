import 'package:flutter/material.dart';
import 'package:lottery_ck/res/logo.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Logo.lotto),
          Logo.ck,
        ],
      ),
    );
  }
}
