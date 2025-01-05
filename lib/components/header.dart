import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';

class Header extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final Color textColor;
  final void Function()? onBack;
  final EdgeInsets? padding;
  const Header({
    super.key,
    required this.title,
    this.backgroundColor = Colors.white,
    this.textColor = AppColors.textPrimary,
    this.onBack,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: AppColors.shadow.withOpacity(0.2),
          ),
        ),
      ),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Get.back();
                if (onBack != null) {
                  onBack!();
                }
              },
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.backButton,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(AppIcon.arrowLeft),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
