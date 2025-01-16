import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/components/pay_by_point_component.dart';
import 'package:lottery_ck/components/point_icon.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:lottery_ck/utils/theme.dart';

class PayMentPage extends StatelessWidget {
  const PayMentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (controller) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  Header(
                    title: AppLocale.pay.getString(context),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  Obx(() {
                    final remain =
                        BuyLotteryController.to.invoiceRemainExpire.value;
                    Color backgroundColor = Colors.amber.shade100;
                    Color textColor = Colors.black;
                    if (remain.inSeconds < 60) {
                      if (remain.inSeconds % 2 == 0) {
                        backgroundColor = Colors.red;
                        textColor = Colors.white;
                      } else {
                        backgroundColor = Colors.red.shade100;
                        textColor = Colors.black;
                      }
                    } else if (remain.inSeconds < 120) {
                      if (remain.inSeconds % 2 == 0) {
                        backgroundColor = Colors.amber;
                        textColor = Colors.white;
                      } else {
                        backgroundColor = Colors.amber.shade100;
                        textColor = Colors.black;
                      }
                    }
                    if (BuyLotteryController.to.invoiceRemainExpireStr.value ==
                        "") return const SizedBox();
                    return Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                      ),
                      child: Text(
                        "ໃບເກັບເງິນນີ້ໝົດອາຍຸໃນ ${BuyLotteryController.to.invoiceRemainExpireStr.value}",
                        style: TextStyle(
                          color: textColor,
                        ),
                      ),
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Builder(builder: (context) {
                            final isHasBonus = BuyLotteryController
                                    .to.invoiceMeta.value.bonus !=
                                null;
                            return Table(
                              // border: TableBorder.all(color: Colors.blue),
                              columnWidths: {
                                0: FlexColumnWidth(50),
                                1: FlexColumnWidth(50),
                                // 2: FlexColumnWidth(25),
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
                                    // if (isHasBonus)
                                    //   TableCell(
                                    //     verticalAlignment:
                                    //         TableCellVerticalAlignment.middle,
                                    //     child: Container(
                                    //       alignment: Alignment.centerRight,
                                    //       padding: const EdgeInsets.all(8.0),
                                    //       child: Text(
                                    //         AppLocale.bonus.getString(context),
                                    //         style: const TextStyle(
                                    //           fontSize: 14,
                                    //           fontWeight: FontWeight.w700,
                                    //           color: Colors.green,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
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
                                              "${CommonFn.parseMoney(transaction.quota)} ${AppLocale.lak.getString(context)}",
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // if (transaction.bonus != null)
                                        //   TableCell(
                                        //     verticalAlignment:
                                        //         TableCellVerticalAlignment
                                        //             .middle,
                                        //     child: Container(
                                        //       alignment: Alignment.centerRight,
                                        //       padding:
                                        //           const EdgeInsets.all(8.0),
                                        //       child: Text(
                                        //         CommonFn.parseMoney(
                                        //             transaction.totalAmount! -
                                        //                 transaction.quota),
                                        //         style: const TextStyle(
                                        //           fontSize: 14,
                                        //           fontWeight: FontWeight.w700,
                                        //           color: Colors.green,
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                      ],
                                    ),
                                  )
                                ],
                                if (BuyLotteryController
                                            .to.invoiceMeta.value.discount !=
                                        null &&
                                    BuyLotteryController
                                            .to.invoiceMeta.value.discount !=
                                        0)
                                  TableRow(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          width: 1,
                                          color: AppColors.disableText,
                                        ),
                                      ),
                                    ),
                                    children: [
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            AppLocale.discount
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
                                            BuyLotteryController
                                                .to.invoiceMeta.value.discount
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // TableCell(
                                      //   verticalAlignment:
                                      //       TableCellVerticalAlignment.middle,
                                      //   child: Container(
                                      //     alignment: Alignment.centerRight,
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     // child: Text(
                                      //     //   AppLocale.bonus.getString(context),
                                      //     //   style: const TextStyle(
                                      //     //     fontSize: 14,
                                      //     //     fontWeight: FontWeight.w700,
                                      //     //     color: Colors.green,
                                      //     //   ),
                                      //     // ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                // if (controller.point != null)
                                //   TableRow(
                                //     decoration: BoxDecoration(
                                //       border: Border(
                                //         top: BorderSide(
                                //           width: 1,
                                //           color: AppColors.disableText,
                                //         ),
                                //       ),
                                //     ),
                                //     children: [
                                //       TableCell(
                                //         verticalAlignment:
                                //             TableCellVerticalAlignment.middle,
                                //         child: Padding(
                                //           padding: const EdgeInsets.all(8.0),
                                //           child: Text(
                                //             "Point discount",
                                //             style: const TextStyle(
                                //               fontSize: 14,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //       TableCell(
                                //         verticalAlignment:
                                //             TableCellVerticalAlignment.middle,
                                //         child: Container(
                                //           alignment: Alignment.centerRight,
                                //           padding: const EdgeInsets.all(8.0),
                                //           child: Text(
                                //             CommonFn.parseMoney(
                                //                 -controller.point!),
                                //             style: const TextStyle(
                                //               fontSize: 14,
                                //             ),
                                //           ),
                                //         ),
                                //       ),
                                //       // TableCell(
                                //       //   verticalAlignment:
                                //       //       TableCellVerticalAlignment.middle,
                                //       //   child: Container(
                                //       //     alignment: Alignment.centerRight,
                                //       //     padding: const EdgeInsets.all(8.0),
                                //       //     // child: Text(
                                //       //     //   AppLocale.bonus.getString(context),
                                //       //     //   style: const TextStyle(
                                //       //     //     fontSize: 14,
                                //       //     //     fontWeight: FontWeight.w700,
                                //       //     //     color: Colors.green,
                                //       //     //   ),
                                //       //     // ),
                                //       //   ),
                                //       // ),
                                //     ],
                                //   )
                              ],
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            controller.showBottomModalPoint(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            // margin:
                            //     const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const PointIcon(),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocale.point.getString(context),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      controller.point == null
                                          ? AppLocale.pleaseEnterPointsWantUse
                                              .getString(context)
                                          : "${controller.point} ${AppLocale.point.getString(context)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: controller.point == null
                                            ? AppColors.disableText
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: SvgPicture.asset(
                                    AppIcon.arrowRight,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            controller.gotoCouponPage();
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 16,
                              left: 16,
                              right: 16,
                              bottom: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppLocale.coupon.getString(context),
                                  ),
                                ),
                                Obx(() {
                                  final invoice =
                                      BuyLotteryController.to.invoiceMeta.value;
                                  final List<String> selectedCoupons = [];
                                  if (invoice.couponIds != null &&
                                      controller.couponsList.isNotEmpty) {
                                    for (var selectedCoupon
                                        in invoice.couponIds!) {
                                      final couponDetail = controller
                                          .couponsList
                                          .firstWhere((coupon) {
                                        return coupon.couponId ==
                                            selectedCoupon;
                                      });
                                      selectedCoupons
                                          .add(couponDetail.promotion!['name']);
                                    }
                                  }
                                  return Text(
                                    selectedCoupons.isEmpty
                                        ? AppLocale.useCoupon.getString(context)
                                        : selectedCoupons.join(","),
                                    style: TextStyle(
                                      color: selectedCoupons.isEmpty
                                          ? AppColors.disableText
                                          : AppColors.textPrimary,
                                    ),
                                  );
                                }),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: SvgPicture.asset(
                                    AppIcon.arrowRight,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            controller.gotoSelectPaymentMethod();
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 8,
                              bottom: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocale.paymentMethod.getString(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        final selectedBank =
                                            controller.selectedBank;
                                        if (selectedBank == null) {
                                          return Expanded(
                                            child: Text(
                                              AppLocale
                                                  .pleaseSelectPaymentMethod
                                                  .getString(context),
                                              style: TextStyle(
                                                color: AppColors.disableText,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Expanded(
                                            child: Row(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      selectedBank.logo ?? '',
                                                  width: 42,
                                                  height: 42,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  selectedBank.fullName,
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child:
                                          SvgPicture.asset(AppIcon.arrowRight),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 8,
                            left: 16,
                            right: 18,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Obx(() {
                            final invoice =
                                BuyLotteryController.to.invoiceMeta.value;
                            final amount =
                                invoice.amount - (controller.point ?? 0);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocale.paymentInformation
                                      .getString(context),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppLocale.totalPayment
                                            .getString(context),
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${CommonFn.parseMoney(BuyLotteryController.to.invoiceMeta.value.quota)} ${AppLocale.lak.getString(context)}",
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (controller.point != null) ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocale.pointDiscount
                                              .getString(context),
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "-${controller.point ?? "0"} ${AppLocale.lak.getString(context)}",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                if (invoice.discount != null &&
                                    invoice.discount != 0) ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          AppLocale.discount.getString(context),
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "-${invoice.discount} ${AppLocale.lak.getString(context)}",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                if (invoice.bonus != null &&
                                    invoice.bonus != 0) ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              AppLocale.bonus
                                                  .getString(context),
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                controller
                                                    .showBonusDetail(context);
                                              },
                                              child: Icon(
                                                Icons.info_outline_rounded,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "+${invoice.bonus} ${AppLocale.lak.getString(context)}",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                                Divider(
                                  color: AppColors.disable,
                                  thickness: 1,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        AppLocale.totalOrderAmount
                                            .getString(context),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "${CommonFn.parseMoney(amount)} ${AppLocale.lak.getString(context)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, -1),
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppLocale.totalOrderAmount.getString(context),
                              ),
                              const SizedBox(height: 8),
                              Builder(builder: (context) {
                                int amount = BuyLotteryController
                                    .to.invoiceMeta.value.amount;
                                if (controller.point != null) {
                                  amount = amount - controller.point!;
                                }
                                return Obx(() {
                                  final invoice =
                                      BuyLotteryController.to.invoiceMeta.value;
                                  final amount =
                                      invoice.amount - (controller.point ?? 0);
                                  return Text(
                                    "${CommonFn.parseMoney(amount)} ${AppLocale.lak.getString(context)}",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                });
                              }),
                            ],
                          ),
                        ),
                        Obx(() {
                          final invoiceRemainExpireStr = BuyLotteryController
                              .to.invoiceRemainExpireStr.value;
                          return LongButton(
                            minimumSize: Size(100, 48),
                            maximumSize: Size(110, 48),
                            disabled: !controller.enablePay ||
                                invoiceRemainExpireStr == "",
                            onPressed: () {
                              if (controller.selectedBank == null) {
                                return;
                              }
                              controller.payLottery(
                                controller.selectedBank!,
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
                      ],
                    ),
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
