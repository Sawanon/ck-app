import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:google_fonts/google_fonts.dart';

class AskKycDialog extends StatelessWidget {
  const AskKycDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.primary,
                width: double.infinity,
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: SvgPicture.asset(
                    AppIcon.kycFace,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      AppLocale.pleaseCompleteYourIdentityVerification
                          .getString(context),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      AppLocale.toTakeFullAdvantageOfTheBenefits
                          .getString(context),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '"${AppLocale.pressToConfirmYourIdentity.getString(context)}"',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.disableText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: LongButton(
                        onPressed: () {
                          Get.back();
                          StorageController.to.setKYCLater();
                        },
                        backgroundColor: AppColors.backButtonHover,
                        borderRadius: BorderRadius.circular(6),
                        child: Text(
                          AppLocale.later.getString(context),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: LongButton(
                        onPressed: () async {
                          Get.back();
                          await Future.delayed(
                              const Duration(milliseconds: 250), () {
                            Get.toNamed(RouteName.kyc);
                          });
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Text(
                          AppLocale.verifyIdentity.getString(context),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
