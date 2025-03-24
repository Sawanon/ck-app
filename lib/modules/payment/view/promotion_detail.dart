import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class PromotionDetail extends StatelessWidget {
  final Map promotion;
  const PromotionDetail({
    super.key,
    required this.promotion,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                promotion['name'] ?? "",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Builder(
                builder: (context) {
                  final invoice = BuyLotteryController.to.invoiceMeta.value;
                  if (invoice.couponResponse?.status == false) {
                    final reason =
                        invoice.couponResponse?.reason.toLowerCase() ==
                                "bank invalid"
                            ? AppLocale.invalidPaymentMethod.getString(context)
                            : invoice.couponResponse!.reason;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          reason,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              Text(
                promotion['detail'] ?? "",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 12),
              Builder(builder: (context) {
                String? expireDate;
                if (promotion['end_date'] == null) {
                  return const SizedBox.shrink();
                }
                expireDate =
                    "${CommonFn.parseDMY(DateTime.parse(promotion['end_date']))} ${CommonFn.parseHM(DateTime.parse(promotion['end_date']))}";
                return Text(
                  "${AppLocale.expiresOn.getString(context)} $expireDate",
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                  ),
                );
              }),
              // Text(jsonEncode(coupon.promotion)),
              const SizedBox(height: 12),
              LongButton(
                onPressed: () {
                  Get.back();
                },
                borderSide: const BorderSide(
                  width: 1,
                  color: AppColors.primary,
                ),
                backgroundColor: Colors.white,
                child: Text(
                  AppLocale.close.getString(context),
                  style: const TextStyle(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
