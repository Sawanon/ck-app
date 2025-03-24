import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class BankPage extends StatelessWidget {
  const BankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Header(
                title: AppLocale.paymentMethod.getString(context),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  children: controller.bankList.map(
                    (bank) {
                      bool isActive = bank.downtime != null
                          ? controller.checkActiveBank(bank.downtime!)
                          : true;
                      int? minimumPrice;
                      if (bank.name.toLowerCase() == "mmoney") {
                        final totalAmount =
                            BuyLotteryController.to.invoiceMeta.value.amount -
                                (controller.point ?? 0);
                        minimumPrice = 1000;
                        logger.d(totalAmount);
                        logger.d(minimumPrice);
                        logger.d(
                            "totalAmount < minimumPrice: ${totalAmount < minimumPrice}");
                        if (totalAmount < minimumPrice) {
                          isActive = false;
                        }
                      }
                      return GestureDetector(
                        onTap: () {
                          if (isActive) {
                            controller.selectBank(bank);
                            Get.back();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : AppColors.disable,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow.withOpacity(0.2),
                                offset: Offset(4, 4),
                                blurRadius: 30,
                              ),
                              if (controller.selectedBank?.$id == bank.$id)
                                const BoxShadow(
                                  color: AppColors.primary,
                                  // offset: Offset(4, 4),
                                  // blurRadius: 30,
                                  spreadRadius: 2,
                                ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Image.network(
                                bank.logo ?? '',
                                width: 42,
                                height: 42,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                    width: 42,
                                    height: 42,
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(bank.fullName),
                                    if (minimumPrice != null)
                                      Builder(
                                        builder: (context) {
                                          String detail = AppLocale
                                              .minimumAmount
                                              .getString(context)
                                              .replaceAll(
                                                  "{price}", "$minimumPrice");
                                          if (isActive == false) {
                                            detail = AppLocale.bankErrorMinimum
                                                .getString(context)
                                                .replaceAll(
                                                  "{price}",
                                                  "$minimumPrice",
                                                );
                                          }
                                          return Text(
                                            detail,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isActive
                                                  ? AppColors.disableText
                                                  : AppColors.errorBorder,
                                            ),
                                          );
                                        },
                                      ),
                                    if (bank.downtime != null) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        "${AppLocale.downtimeBank.getString(context)} ${bank.downtime!}",
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.disableText,
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
