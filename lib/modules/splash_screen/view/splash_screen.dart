import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottery_ck/modules/splash_screen/controller/splash_screen.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/res/logo.dart';
import 'package:lottery_ck/utils.dart';
import 'package:google_fonts/google_fonts.dart';

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
          // backgroundColor: Colors.white,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  AppColors.ckOrange,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  ImagePng.logoBackDrop,
                  width: double.infinity,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 280,
                      height: 140,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            child: Image.asset(Logo.lotto),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 120,
                            height: 120,
                            // margin: EdgeInsets.only(top: 8),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: SvgPicture.asset(
                              NavbarIcon.buyLottory,
                              width: 150,
                              height: 150,
                            ),
                            // child: Image.asset(
                            //   // Logo.app,
                            //   "assets/png/logo-t-bl.png",
                            //   fit: BoxFit.none,
                            //   width: 150,
                            //   height: 150,
                            //   scale: 1.4,
                            // ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "CK LOTTO",
                          style: TextStyle(
                            color: AppColors.ckRed,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "BY CK GROUP",
                          style: TextStyle(
                            color: AppColors.ckRed,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "2.4.1+45",
                      style: TextStyle(
                        color: AppColors.ckRed,
                        fontSize: 14,
                      ),
                    ),
                    // const SizedBox(height: 48),
                    // Image.asset(
                    //   Logo.ck,
                    //   height: 40,
                    // ),
                    // const SizedBox(height: 24),
                    // Text(
                    //   "v.2.4.1+40",
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: AppColors.textPrimary,
                    //   ),
                    // ),
                    // Container(
                    //   width: 150,
                    //   height: 150,
                    //   // color: Colors.red,
                    //   // child: Image.asset(Logo.lotto),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
