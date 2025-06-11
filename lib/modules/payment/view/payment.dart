import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/components/point_icon.dart';
import 'package:lottery_ck/components/switch.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/modules/bill/view/bill.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/view/animal_lottery.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:google_fonts/google_fonts.dart';

class PayMentPage extends StatelessWidget {
  const PayMentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (controller) {
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          logger.w("didPop: $didPop");
          if (didPop) {
            controller.removeInvoiceWhenBack();
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    Header(
                      title: AppLocale.pay.getString(context),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
                      if (BuyLotteryController
                              .to.invoiceRemainExpireStr.value ==
                          "") return const SizedBox();
                      return Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                        ),
                        child: Text(
                          "${AppLocale.thisInvoiceExpiresOn.getString(context)} ${BuyLotteryController.to.invoiceRemainExpireStr.value}",
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Builder(builder: (context) {
                              return Table(
                                // border: TableBorder.all(color: Colors.blue),
                                columnWidths: const {
                                  0: FlexColumnWidth(30),
                                  1: FlexColumnWidth(40),
                                  2: FlexColumnWidth(30),
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
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: EdgeInsets.all(0),
                                          child: Text(
                                            "",
                                            style: TextStyle(
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
                                            style: TextStyle(
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
                                      //         style: TextStyle(
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
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                transaction.lottery,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: SizedBox(
                                              width: 24,
                                              child: AnimalLottery(
                                                lottery: transaction.lottery,
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            verticalAlignment:
                                                TableCellVerticalAlignment
                                                    .middle,
                                            child: Container(
                                              alignment: Alignment.centerRight,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "${CommonFn.parseMoney(transaction.quota)} ${AppLocale.lak.getString(context)}",
                                                style: TextStyle(
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
                                          //         style: TextStyle(
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
                                  // if (BuyLotteryController
                                  //             .to.invoiceMeta.value.discount !=
                                  //         null &&
                                  //     BuyLotteryController
                                  //             .to.invoiceMeta.value.discount !=
                                  //         0)
                                  //   TableRow(
                                  //     decoration: const BoxDecoration(
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
                                  //             AppLocale.discount
                                  //                 .getString(context),
                                  //             style: TextStyle(
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
                                  //             BuyLotteryController
                                  //                 .to.invoiceMeta.value.discount
                                  //                 .toString(),
                                  //             style: TextStyle(
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
                                  //       //     //   style: TextStyle(
                                  //       //     //     fontSize: 14,
                                  //       //     //     fontWeight: FontWeight.w700,
                                  //       //     //     color: Colors.green,
                                  //       //     //   ),
                                  //       //     // ),
                                  //       //   ),
                                  //       // ),
                                  //     ],
                                  //   ),
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
                                  //             style: TextStyle(
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
                                  //             style: TextStyle(
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
                                  //       //     //   style: TextStyle(
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
                              // controller.showBottomModalPoint(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              // margin:
                              //     const EdgeInsets.symmetric(horizontal: 16.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                // borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const PointIcon(),
                                  const SizedBox(width: 8),
                                  Obx(() {
                                    final invoice = BuyLotteryController
                                        .to.invoiceMeta.value;
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          controller.isCanUsePoint
                                              ? "${AppLocale.useAll.getString(context)} ${CommonFn.parseMoney(invoice.quota)} ${AppLocale.point.getString(context)}"
                                              : AppLocale.pointsCannotBeUsed
                                                  .getString(context),
                                          // AppLocale.point.getString(context),
                                          style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        if (controller.isCanUsePoint)
                                          Text(
                                            "${AppLocale.youHave.getString(context)} (${CommonFn.parseMoney(UserController.to.user.value?.point ?? 0)} ${AppLocale.point.getString(context)})",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.secodaryText,
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: controller.isCanUsePoint
                                          ? SwitchComponent(
                                              value: controller.point != null,
                                              onChange: controller
                                                  .onChangePointSwitch,
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                logger.d("message");
                                                controller
                                                    .showCannotBeUsedPoint(
                                                        context);
                                              },
                                              child: Icon(
                                                Icons.info_outline_rounded,
                                                size: 28,
                                                color: Colors.grey,
                                              ),
                                            ),
                                      // child: Text(
                                      //   controller.point == null
                                      //       ? AppLocale.pleaseEnterPointsWantUse
                                      //           .getString(context)
                                      //       : "${CommonFn.parseMoney(controller.point ?? 0)} ${AppLocale.point.getString(context)}",
                                      //   style: TextStyle(
                                      //     fontWeight: FontWeight.w500,
                                      //     fontSize: 14,
                                      //     color: controller.point == null
                                      //         ? AppColors.disableText
                                      //         : Colors.black,
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 24,
                                  //   height: 24,
                                  //   child: SvgPicture.asset(
                                  //     AppIcon.arrowRight,
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            final invoice =
                                BuyLotteryController.to.invoiceMeta.value;
                            final List<String> selectedPromotionList = [];
                            Map? promotion;
                            if (invoice.promotionIds?.isNotEmpty == true &&
                                controller.promotionList.isNotEmpty) {
                              for (var selectedPromotion
                                  in invoice.promotionIds!) {
                                // TODO: promotion is null
                                logger.d(controller.promotionList);
                                final promotionDetail = controller.promotionList
                                    .firstWhere((promotion) {
                                  return promotion['\$id'] == selectedPromotion;
                                });
                                promotion = promotionDetail;
                                selectedPromotionList
                                    .add(promotionDetail['name']);
                              }
                            }
                            bool isCanUse = false;
                            final promotionIds = invoice.promotionIds;
                            if (promotionIds != null &&
                                promotionIds.isNotEmpty) {
                              isCanUse =
                                  controller.isCanUse(promotionIds.first);
                            }
                            return GestureDetector(
                              onTap: () {
                                // final invoice =
                                //     BuyLotteryController.to.invoiceMeta.value;
                                // if (invoice.couponIds?.isNotEmpty == true) {
                                //   // controller.showCouponDetail(context);
                                //   // TODO: show promotion Detail
                                //   return;
                                // }
                                if (isCanUse == false && promotion != null) {
                                  controller.showPromotionDetail(
                                    context,
                                    promotion,
                                  );
                                  return;
                                }
                                if (controller.point != null) {
                                  return;
                                }
                                // controller.gotoCouponPage();
                                controller.gotoPromotionPage();
                              },
                              child: Opacity(
                                opacity: controller.point == null ? 1 : 0.5,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    left: 16,
                                    right: 16,
                                    bottom: 16,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        AppLocale.promotion.getString(context),
                                      ),
                                      const SizedBox(width: 12),
                                      if (invoice.promotionIds?.isNotEmpty ==
                                              true &&
                                          isCanUse == false) ...[
                                        const Icon(
                                          Icons.info,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          selectedPromotionList.isEmpty
                                              ? AppLocale.usePromotion
                                                  .getString(context)
                                              : selectedPromotionList.join(","),
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: selectedPromotionList.isEmpty
                                                ? AppColors.disableText
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Builder(builder: (context) {
                                        final invoice = BuyLotteryController
                                            .to.invoiceMeta.value;
                                        if (invoice.couponIds?.isNotEmpty ==
                                            true) {
                                          return GestureDetector(
                                            onTap: () {
                                              controller.showRemoveCouponModal(
                                                  context);
                                            },
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: SvgPicture.asset(
                                                AppIcon.x,
                                              ),
                                            ),
                                          );
                                        }
                                        return SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: SvgPicture.asset(
                                            AppIcon.arrowRight,
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
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
                              decoration: const BoxDecoration(
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
                                                  if (controller.disableBank(
                                                      selectedBank)) ...[
                                                    const SizedBox(width: 8),
                                                    const Icon(
                                                      Icons
                                                          .error_outline_rounded,
                                                      color: Colors.red,
                                                    ),
                                                  ]
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: SvgPicture.asset(
                                            AppIcon.arrowRight),
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
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Obx(() {
                              final invoice =
                                  BuyLotteryController.to.invoiceMeta.value;
                              final amount =
                                  invoice.amount - (controller.point ?? 0);
                              // logger.w(invoice
                              //     .toJson(SettingController.to.user!.userId));
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocale.paymentInformation
                                        .getString(context),
                                    style: TextStyle(
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
                                          "-${CommonFn.parseMoney(controller.point ?? 0)} ${AppLocale.lak.getString(context)}",
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
                                            AppLocale.discount
                                                .getString(context),
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "-${CommonFn.parseMoney(invoice.discount ?? 0)} ${AppLocale.lak.getString(context)}",
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
                                                child: const Icon(
                                                  Icons.info_outline_rounded,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "+${CommonFn.parseMoney(invoice.bonus ?? 0)} ${AppLocale.lak.getString(context)}",
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                  const Divider(
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
                          // Obx(() {
                          //   final invoice =
                          //       BuyLotteryController.to.invoiceMeta.value;
                          //   if (invoice.pointBank != null) {
                          //     return Container(
                          //       margin: const EdgeInsets.only(top: 8),
                          //       child: Row(
                          //         children: [
                          //           Text("")
                          //         ],
                          //       ),
                          //     );
                          //   }
                          //   return const SizedBox.shrink();
                          // }),
                          const SizedBox(height: 8),
                          Obx(
                            () {
                              final invoice =
                                  BuyLotteryController.to.invoiceMeta.value;
                              final isReceivePoint =
                                  invoice.receivePoint != null &&
                                      invoice.receivePoint != 0;
                              final isPointBank = invoice.pointBank != null &&
                                  invoice.pointBank != 0;
                              final isHaveReceivePoint =
                                  isReceivePoint || isPointBank;
                              if (isHaveReceivePoint) {
                                return Container(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 16,
                                    right: 18,
                                    bottom: 8,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        AppLocale.pointsToBeReceived
                                            .getString(context),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      if (isReceivePoint)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppLocale.couponApplied
                                                  .getString(context),
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            Text(
                                              "+${CommonFn.parseMoney(invoice.receivePoint ?? 0)} ${AppLocale.point.getString(context)}",
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (invoice.pointBank != null &&
                                          invoice.pointBank != 0)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppLocale.bankPointDetail
                                                  .getString(context),
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            Text(
                                              "+${CommonFn.parseMoney(invoice.pointBank ?? 0)} ${AppLocale.point.getString(context)}",
                                              style: TextStyle(
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
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
                                const SizedBox(height: 4),
                                Builder(builder: (context) {
                                  int amount = BuyLotteryController
                                      .to.invoiceMeta.value.amount;
                                  if (controller.point != null) {
                                    amount = amount - controller.point!;
                                  }
                                  return Obx(() {
                                    final invoice = BuyLotteryController
                                        .to.invoiceMeta.value;
                                    final amount = invoice.amount -
                                        (controller.point ?? 0);
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
                                Obx(
                                  () {
                                    final invoice = BuyLotteryController
                                        .to.invoiceMeta.value;
                                    final allReceivePoint =
                                        (invoice.receivePoint ?? 0) +
                                            (invoice.pointBank ?? 0);
                                    return Text(
                                      "+${CommonFn.parseMoney(allReceivePoint)} ${AppLocale.point.getString(context)}",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            final invoiceRemainExpireStr = BuyLotteryController
                                .to.invoiceRemainExpireStr.value;
                            bool disableBank = false;
                            if (controller.selectedBank != null) {
                              disableBank = controller
                                  .disableBank(controller.selectedBank!);
                            }
                            return Expanded(
                              child: LongButton(
                                // minimumSize: const Size(100, 48),
                                // maximumSize: const Size(150, 48),
                                isLoading: controller.isLoading.value,
                                disabled: !controller.enablePay ||
                                    invoiceRemainExpireStr == "" ||
                                    disableBank,
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
                                  AppLocale.confirmPayment.getString(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                Obx(
                  () {
                    if (controller.isLoading.value) {
                      return Dialog.fullscreen(
                        backgroundColor: Colors.white,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
