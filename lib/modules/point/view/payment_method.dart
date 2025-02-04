import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/point/controller/buy_point.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyPointController>(builder: (controller) {
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
                  padding: const EdgeInsets.all(16),
                  children: controller.bankList.map((bank) {
                    return GestureDetector(
                      onTap: () {
                        controller.selectBank(bank);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                                  // if (minimumPrice != null)
                                  //   Builder(
                                  //     builder: (context) {
                                  //       final detail = AppLocale.minimumAmount
                                  //           .getString(context)
                                  //           .replaceAll(
                                  //               "{price}", "$minimumPrice");
                                  //       return Text(
                                  //         detail,
                                  //         style: const TextStyle(
                                  //           fontSize: 12,
                                  //           color: AppColors.disableText,
                                  //         ),
                                  //       );
                                  //     },
                                  //   ),
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
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
