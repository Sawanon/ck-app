import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:google_fonts/google_fonts.dart';

class CouponRemove extends StatelessWidget {
  final void Function() onConfirm;
  final void Function() onCancel;
  const CouponRemove({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocale.removeThisCoupon.getString(context),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocale.noProblemWeKeepThisCouponForYouLater.getString(context),
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          LongButton(
            onPressed: () {
              onConfirm();
            },
            child: Text(
              AppLocale.removeThisCoupon.getString(context),
            ),
          ),
          const SizedBox(height: 8),
          LongButton(
            onPressed: () {
              onCancel();
            },
            backgroundColor: Colors.white,
            borderSide: BorderSide(
              width: 1,
              color: AppColors.primary,
            ),
            child: Text(
              AppLocale.keepUsing.getString(context),
              style: TextStyle(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
