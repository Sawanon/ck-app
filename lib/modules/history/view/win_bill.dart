import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/bill/view/bill_component.dart';
import 'package:lottery_ck/modules/history/controller/win_bill.contoller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:google_fonts/google_fonts.dart';

class WinBillPage extends StatelessWidget {
  const WinBillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WinBillContoller>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              if (controller.invoice != null &&
                  controller.invoice?['is_win'] == true)
                Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppLocale.youAreTheLuckyOneAndHaveWonPrize
                            .getString(context),
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${CommonFn.parseMoney(controller.invoice!["totalWin"])} ${AppLocale.lak.getString(context)}",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (controller.bill?.isSpecialWin == true)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    border: Border.all(
                      width: 1,
                      color: AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppLocale.youAreTheLuckyOneAndHaveWonPrizeSpecial
                            .getString(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.amber.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${CommonFn.parseMoney(controller.invoice?["specialWin"] ?? 0)} ${AppLocale.lak.getString(context)}",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (controller.bill != null)
                Expanded(
                  child: BillComponent(bill: controller.bill!),
                ),
              if (controller.bill == null)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: LongButton(
                  onPressed: () {
                    navigator?.pop();
                  },
                  child: Text(
                    "ປິດ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
