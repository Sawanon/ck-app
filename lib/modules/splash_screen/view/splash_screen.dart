import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/splash_screen/controller/splash_screen.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/logo.dart';
import 'package:lottery_ck/utils.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
      initState: (state) {
        SplashScreenController.to.setupInteractedMessage(context);
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Logo.lotto),
                const SizedBox(height: 16),
                Image.asset(
                  Logo.ck,
                  height: 40,
                ),
                const SizedBox(height: 16),
                Text(
                  "v.1.2.0+33",
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
