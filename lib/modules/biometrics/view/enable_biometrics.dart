import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/biometrics/controller/enable_biometrics.controller.dart';
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
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(
                        width: 128,
                        height: 128,
                        child: SvgPicture.asset(
                          AppIcon.fingerScan,
                          colorFilter: ColorFilter.mode(
                            AppColors.secondary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "ເປີດໃຊ້ການສະແກນລາຍນິ້ວມື",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "ເປີດໃຊ້ການສະແກນລາຍນິ້ວມືເພື່ອຄວາມປອດໄພໃນການນຳໃຊ້ແອັບພລິເຄຊັນ",
                        style: TextStyle(
                          color: AppColors.textPrimary,
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
                        "ຂ້າມ",
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
                        "ເປີດໃຊ້",
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
