import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogWin extends StatelessWidget {
  final Widget reward;
  const DialogWin({
    super.key,
    required this.reward,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            boxShadow: const [AppTheme.softShadow],
            color: AppColors.wheelBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              width: 4,
              color: AppColors.wheelBorder,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${AppLocale.congrate.getString(context)} !!",
                style: TextStyle(
                  color: AppColors.wheelText,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppLocale.youGotPrize.getString(context),
                style: TextStyle(
                  color: AppColors.wheelText,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              reward,
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Get.back();
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 2,
                      color: AppColors.wheelBorder,
                    ),
                  ),
                  child: Text(
                    AppLocale.acknowledge.getString(context),
                    style: const TextStyle(
                      color: AppColors.wheelText,
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
