import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';

class BonusDetailComponent extends StatelessWidget {
  const BonusDetailComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "🎯 ${AppLocale.bonusDesTitle.getString(context)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "1. ${AppLocale.bonusDes1.getString(context)}",
          ),
          const SizedBox(height: 16),
          Text(
            "2. ${AppLocale.bonusDes2.getString(context)}",
          ),
          const SizedBox(height: 16),
          Text(
            "3. ${AppLocale.bonusDes3.getString(context)}",
          ),
          const SizedBox(height: 8),
          Text(
            "- ${AppLocale.bonusDes3_1.getString(context)}",
          ),
          const SizedBox(height: 8),
          Text(
            "- ${AppLocale.bonusDes3_2.getString(context)}",
          ),
          const SizedBox(height: 16),
          Text(
            "✨${AppLocale.bonusDesSummary.getString(context)}",
          ),
          const SizedBox(height: 8),
          Text(
            "- ${AppLocale.bonusDesSummaryDetail_1.getString(context)}",
          ),
          const SizedBox(height: 8),
          Text(
            "- ${AppLocale.bonusDesSummaryDetail_2.getString(context)}",
          ),
          const SizedBox(height: 24),
          LongButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              AppLocale.close.getString(context),
            ),
          ),
        ],
      ),
    );
  }
}
