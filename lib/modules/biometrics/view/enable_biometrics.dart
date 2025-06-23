import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/biometrics/controller/enable_biometrics.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:google_fonts/google_fonts.dart';

class EnableBiometricsPage extends StatelessWidget {
  const EnableBiometricsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EnableBiometricsController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SvgPicture.asset(
                  AppIcon.ckLotto,
                  width: 200,
                  height: 40,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Text(
                        AppLocale.enbaleBioTitle1.getString(context),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocale.enbaleBioTitle2.getString(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 100),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: SvgPicture.asset(
                          AppIcon.fingerScan,
                          colorFilter: const ColorFilter.mode(
                            Color.fromRGBO(111, 111, 111, 1),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LongButton(
                      maximumSize: Size(100, 48),
                      backgroundColor: Colors.white,
                      borderSide: BorderSide(
                        width: 1,
                        color: AppColors.primary,
                      ),
                      onPressed: controller.skipBiometrics,
                      child: Text(
                        AppLocale.skip.getString(context),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          // fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    LongButton(
                      maximumSize: Size(100, 48),
                      onPressed: controller.enableBiometrics,
                      child: Text(
                        AppLocale.enable.getString(context),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
