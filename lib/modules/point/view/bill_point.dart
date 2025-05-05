import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/model/point_topup.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class BillPoint extends StatelessWidget {
  final void Function() onBackHome;
  final void Function() onBuyAgain;
  final PointTopup pointTop;
  const BillPoint({
    super.key,
    required this.onBackHome,
    required this.onBuyAgain,
    required this.pointTop,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 52,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocale.purchaseCompleted.getString(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocale.numberPointsReceived.getString(context)),
                        Text(
                          "+${CommonFn.parseMoney(pointTop.point?.toInt() ?? 0)}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocale.amountPaid.getString(context)),
                        Text(CommonFn.parseMoney(
                            pointTop.pointMoney?.toInt() ?? 0)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocale.dateTimePurchase.getString(context)),
                        // Text("21/04/2025 11:23"),
                        Builder(builder: (context) {
                          final date = pointTop.paidAt != null
                              ? CommonFn.parseDMY(pointTop.paidAt!)
                              : "-";
                          final time = pointTop.paidAt != null
                              ? CommonFn.parseHM(pointTop.paidAt!)
                              : "-";
                          return Text("$date $time");
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LongButton(
                  borderSide: BorderSide(
                    width: 1,
                    color: AppColors.primary,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: onBuyAgain,
                  child: Text(
                    AppLocale.buyMorePoints.getString(context),
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: LongButton(
                  onPressed: onBackHome,
                  child: Text(AppLocale.returnToTheHomepage.getString(context)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
