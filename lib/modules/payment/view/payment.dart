import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class PayMentPage extends StatelessWidget {
  const PayMentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  HeaderCK(
                    onTap: () {
                      navigator?.pop();
                    },
                  ),
                  Obx(() {
                    if (BuyLotteryController.to.invoiceRemainExpireStr.value ==
                        "") return const SizedBox();
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "ໃບເກັບເງິນນີ້ໝົດອາຍຸໃນ ${BuyLotteryController.to.invoiceRemainExpireStr.value}",
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }),
                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // Column(
                        //   // shrinkWrap: true,
                        //   // physics: const BouncingScrollPhysics(),
                        //   children: controller.lotteryList.map(
                        //     (data) {
                        //       return Text(data.lottery);
                        //     },
                        //   ).toList(),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Table(
                            // border: TableBorder.all(color: Colors.blue),
                            columnWidths: {
                              0: FlexColumnWidth(50),
                              1: FlexColumnWidth(25),
                              2: FlexColumnWidth(25),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        AppLocale.lotteryList
                                            .getString(context),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        AppLocale.amount.getString(context),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (BuyLotteryController
                                          .to.invoiceMeta.value.bonus !=
                                      null)
                                    TableCell(
                                      verticalAlignment:
                                          TableCellVerticalAlignment.middle,
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          AppLocale.bonus.getString(context),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              ...[
                                ...BuyLotteryController
                                    .to.invoiceMeta.value.transactions
                                    .map(
                                  (transaction) => TableRow(
                                    children: [
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            transaction.lottery,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            CommonFn.parseMoney(
                                                transaction.quota),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (transaction.bonus != null)
                                        TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              CommonFn.parseMoney(
                                                  transaction.totalAmount! -
                                                      transaction.quota),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                )
                              ],
                              TableRow(
                                children: [
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Discount",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        BuyLotteryController
                                            .to.invoiceMeta.value.discount
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.all(8.0),
                                      // child: Text(
                                      //   AppLocale.bonus.getString(context),
                                      //   style: const TextStyle(
                                      //     fontSize: 14,
                                      //     fontWeight: FontWeight.w700,
                                      //     color: Colors.green,
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16 + 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Bonus"),
                                  Text(BuyLotteryController
                                      .to.invoiceMeta.value.bonus
                                      .toString()),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.foregroundBorder,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocale.totalAmountForPay
                                          .getString(context),
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      CommonFn.parseMoney(BuyLotteryController
                                          .to.invoiceMeta.value.amount),
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            // shrinkWrap: true,
                            children: controller.bankList.map(
                              (bank) {
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
                                          color:
                                              AppColors.shadow.withOpacity(0.2),
                                          offset: Offset(4, 4),
                                          blurRadius: 30,
                                        ),
                                        if (controller.selectedBank?.$id ==
                                            bank.$id)
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
                                          errorBuilder:
                                              (context, error, stackTrace) {
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
                                        Text(bank.fullName),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() {
                      logger.d(
                          BuyLotteryController.to.invoiceRemainExpireStr.value);
                      return LongButton(
                        disabled: !controller.enablePay ||
                            BuyLotteryController
                                    .to.invoiceRemainExpireStr.value ==
                                "",
                        onPressed: () {
                          if (controller.selectedBank == null) {
                            return;
                          }
                          controller.payLottery(
                            controller.selectedBank!,
                            controller.totalAmount!,
                            context,
                          );
                        },
                        child: Text(
                          AppLocale.pay.getString(context),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }),
                    // child: ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     elevation: 0,
                    //     shadowColor: Colors.transparent,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     fixedSize: Size(MediaQuery.of(context).size.width, 48),
                    //     backgroundColor: controller.enablePay
                    //         ? AppColors.primary
                    //         : AppColors.disable,
                    //     overlayColor:
                    //         controller.enablePay ? null : Colors.transparent,
                    //     foregroundColor: controller.enablePay
                    //         ? Colors.white
                    //         : AppColors.disableText,
                    //   ),
                    //   onPressed: () {
                    //     if (controller.selectedBank == null) {
                    //       return;
                    //     }
                    //     controller.payLottery(
                    //       controller.selectedBank!,
                    //       controller.totalAmount!,
                    //       context,
                    //     );
                    //   },
                    //   child: Text(
                    //     AppLocale.pay.getString(context),
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //   ),
                    // ),
                  ),
                ],
              ),
              if (controller.isLoading)
                Dialog.fullscreen(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
