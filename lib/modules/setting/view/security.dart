import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = SettingController.to;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderCK(
              onTap: () => Get.back(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                children: [
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 48,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocale.enableBiometrics.getString(context),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocale.biometricsDetail.getString(context),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          return Switch(
                            value: controller.enabledBiometrics.value,
                            activeColor: Colors.white,
                            activeTrackColor: Colors.greenAccent.shade700,
                            inactiveThumbColor: Colors.grey.shade400,
                            inactiveTrackColor: Colors.grey.shade200,
                            onChanged: controller.enableBioMetrics,
                          );
                        })
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => controller.changePasscode(),
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 48,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocale.changePasscode.getString(context),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: SvgPicture.asset(AppIcon.arrowRight),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
