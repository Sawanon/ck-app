import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';

class SuccessKycDialog extends StatelessWidget {
  const SuccessKycDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(16),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                color: AppColors.kycBanner,
                child: SizedBox(
                  height: 100,
                  child: Image.asset("assets/success_kyc.png"),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(24),
                child: Text(
                  "${AppLocale.titleKYCSuccess.getString(context)} !",
                  style: const TextStyle(
                    height: 1.3,
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LongButton(
                  backgroundColor: AppColors.kycBanner,
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "${AppLocale.acknowledge.getString(context)} !",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
