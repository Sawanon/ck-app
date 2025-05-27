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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 170,
                      height: 170,
                      child: Image.asset(Logo.lotto),
                    ),
                    Container(
                      width: 150,
                      height: 150,
                      margin: EdgeInsets.only(top: 8),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        // Logo.app,
                        "assets/png/logo.png",
                        fit: BoxFit.none,
                        width: 150,
                        height: 150,
                        scale: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                Image.asset(
                  Logo.ck,
                  height: 40,
                ),
                const SizedBox(height: 24),
                Text(
                  "v.2.0.0",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  width: 150,
                  height: 150,
                  // color: Colors.red,
                  // child: Image.asset(Logo.lotto),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
