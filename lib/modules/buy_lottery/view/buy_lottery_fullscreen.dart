import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class BuyLotteryFullscreenPage extends StatelessWidget {
  const BuyLotteryFullscreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyLotteryController>(
      initState: (state) {
        // BuyLotteryController.to.listPromotions();
        BuyLotteryController.to.getUseApp();
        BuyLotteryController.to.formKey = GlobalKey();
      },
      builder: (controller) {
        return Obx(() {
          return Stack(
            fit: StackFit.expand,
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.lotteryNode.unfocus();
                              controller.priceNode.unfocus();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: AppColors.shadow,
                                //     offset: Offset(4, 4),
                                //     blurRadius: 30,
                                //   )
                                // ],
                              ),
                              child: Column(
                                children: [
                                  Obx(() {
                                    if (controller
                                            .invoiceRemainExpireStr.value ==
                                        "") return const SizedBox();
                                    return Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.shade100,
                                      ),
                                      child: Text(
                                        "ໃບເກັບເງິນນີ້ໝົດອາຍຸໃນ ${controller.invoiceRemainExpireStr.value}",
                                      ),
                                    );
                                  }),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16 + 8, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocale.lotteryList
                                              .getString(context),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        Obx(() {
                                          return Row(
                                            children: [
                                              Text(
                                                AppLocale.amount
                                                    .getString(context),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              // TODO: this!
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              if (controller.invoiceMeta.value
                                                          .bonus !=
                                                      0 &&
                                                  controller.invoiceMeta.value
                                                          .bonus !=
                                                      null) ...[
                                                const SizedBox(
                                                  width: 16,
                                                ),
                                                Text(
                                                  AppLocale.bonus
                                                      .getString(context),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                              const SizedBox(width: 8),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Center(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                'ທ່ານແນ່ໃຈບໍ່ວ່າຕ້ອງການລຶບລາຍການຫວຍທັງໝົດ?',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      elevation:
                                                                          0,
                                                                      backgroundColor:
                                                                          AppColors
                                                                              .primary,
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      navigator
                                                                          ?.pop();
                                                                    },
                                                                    child: Text(
                                                                        "Cancel"),
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 8),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      elevation:
                                                                          0,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      foregroundColor:
                                                                          AppColors
                                                                              .errorBorder,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        side:
                                                                            BorderSide(
                                                                          color:
                                                                              AppColors.errorBorder,
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      controller
                                                                          .removeAllLottery();
                                                                      navigator
                                                                          ?.pop();
                                                                    },
                                                                    child: Text(
                                                                      "Delete all",
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color:
                                                          AppColors.errorBorder,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    color:
                                                        AppColors.errorBorder,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      children: controller.invoiceMeta.value
                                              .transactions.isEmpty
                                          ? [
                                              GestureDetector(
                                                onTap: () {
                                                  controller.getQuota();
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 24),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    AppLocale
                                                        .pleaseAddNumberWantToBuy
                                                        .getString(context),
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.disableText,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ]
                                          // : controller.lotteryList.map(
                                          : controller
                                              .invoiceMeta.value.transactions
                                              .map(
                                              (lotteryData) {
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      bottom: 8),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.foreground,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: AppColors
                                                            .foregroundBorder,
                                                        offset: Offset(0, 0),
                                                        spreadRadius: 1,
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        lotteryData.lottery,
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .textPrimary,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            CommonFn.parseMoney(
                                                                lotteryData
                                                                    .quota),
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .textPrimary,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          // TODO: this!
                                                          const SizedBox(
                                                            width: 12,
                                                          ),
                                                          if (lotteryData
                                                                      .bonus !=
                                                                  null &&
                                                              lotteryData
                                                                      .bonus !=
                                                                  0) ...[
                                                            const SizedBox(
                                                                width: 16),
                                                            Text(
                                                              '+${CommonFn.parseMoney(lotteryData.bonus!)}',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ],
                                                          const SizedBox(
                                                              width: 8),
                                                          GestureDetector(
                                                            onTap: () {
                                                              controller
                                                                  .removeLottery(
                                                                      lotteryData);
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                color: AppColors
                                                                    .errorBorder,
                                                              ),
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Text(AppLocale.totalAmount
                                      .getString(context))),
                              Text(
                                // CommonFn.parseMoney(
                                //     controller.totalAmount.value),
                                CommonFn.parseMoney(
                                    controller.invoiceMeta.value.quota),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (controller.invoiceMeta.value.bonus != null &&
                                  controller.invoiceMeta.value.bonus != 0)
                                Text(
                                  "+${CommonFn.parseMoney(controller.invoiceMeta.value.bonus!)}",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (controller.promotionList.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              logger.d("message");
                              // controller.calPromotion();
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    color: Colors.white,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                            top: 8,
                                            left: 16,
                                            right: 16,
                                          ),
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.listPromotions(true);
                                            },
                                            child: const Icon(
                                                Icons.refresh_rounded),
                                          ),
                                        ),
                                        Expanded(
                                          child: Obx(() {
                                            return ListView.separated(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      final condition =
                                                          jsonDecode(controller
                                                                      .promotionList[
                                                                  index]
                                                              ['condition'][0]);
                                                      logger.d(condition);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color: AppColors
                                                                .borderGray),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      // child: Text(
                                                      //   '${controller.promotionList[index]['detail']}',
                                                      //   // softWrap: false,
                                                      //   maxLines: 2,
                                                      //   overflow: TextOverflow.ellipsis,
                                                      // ),
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 24,
                                                            height: 24,
                                                            child: SvgPicture
                                                                .asset(AppIcon
                                                                    .promotion),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${controller.promotionList[index]['name']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: AppColors
                                                                        .textPrimary,
                                                                  ),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                const SizedBox(
                                                                    height: 4),
                                                                Text(
                                                                  '${controller.promotionList[index]['detail']}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: AppColors
                                                                        .textPrimary,
                                                                  ),
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                const SizedBox(
                                                                    height: 4),
                                                                Text(
                                                                    '${AppLocale.promotionExpire.getString(context)}: ${CommonFn.parseDMY(DateTime.parse(controller.promotionList[index]['end_date']))}'),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                separatorBuilder:
                                                    (context, index) =>
                                                        SizedBox(height: 8),
                                                itemCount: controller
                                                    .promotionList.length);
                                          }),
                                        ),
                                      ],
                                    ),
                                    // child: ListView(
                                    //   padding: const EdgeInsets.all(16),
                                    //   children: controller.promotionList.map(
                                    //     (promotion) {
                                    //       return Container(
                                    //         decoration: BoxDecoration(
                                    //           border: Border.all(
                                    //               width: 1,
                                    //               color: AppColors.borderGray),
                                    //           borderRadius:
                                    //               BorderRadius.circular(8),
                                    //         ),
                                    //         child: Text('${promotion['name']}'),
                                    //       );
                                    //     },
                                    //   ).toList(),
                                    // ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    width: 1, color: AppColors.borderGray),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: SvgPicture.asset(AppIcon.promotion),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    AppLocale.promotion.getString(context),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          controller.promotionList.length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 8,
                            bottom: 26,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: AppLocale.purchaseNumber
                                              .getString(context),
                                          errorStyle: TextStyle(height: 0),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: AppColors.borderGray,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: AppColors.borderGray,
                                              width: 1,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: AppColors.errorBorder,
                                              width: 2,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: AppColors.errorBorder,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        focusNode: controller.lotteryNode,
                                        controller:
                                            controller.lotteryTextController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (value) {
                                          logger.d("validator: $value");
                                          if (value == null || value == "") {
                                            controller.alertLotteryEmpty();
                                            return "";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          controller.lottery = value;
                                        },
                                      ),
                                    ),
                                    // const SizedBox(width: 4),
                                    // GestureDetector(
                                    //   onTap: () => controller.gotoAnimalPage(),
                                    //   child: Container(
                                    //     width: 48,
                                    //     height: 48,
                                    //     decoration: BoxDecoration(
                                    //       color: AppColors.primary,
                                    //       borderRadius:
                                    //           BorderRadius.circular(8),
                                    //     ),
                                    //     child: Column(
                                    //       mainAxisSize: MainAxisSize.min,
                                    //       mainAxisAlignment:
                                    //           MainAxisAlignment.center,
                                    //       children: [
                                    //         SizedBox(
                                    //           width: 24,
                                    //           height: 24,
                                    //           child: SvgPicture.asset(
                                    //             AppIcon.animal,
                                    //             colorFilter: ColorFilter.mode(
                                    //               Colors.white,
                                    //               BlendMode.srcIn,
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         Text(
                                    //           AppLocale.animal
                                    //               .getString(context),
                                    //           style: TextStyle(
                                    //             fontSize: 14,
                                    //             color: Colors.white,
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    // const SizedBox(width: 4),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: AppLocale.price
                                              .getString(context),
                                          errorStyle: TextStyle(height: 0),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: AppColors.borderGray,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: AppColors.borderGray,
                                              width: 1,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: AppColors.errorBorder,
                                              width: 2,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: AppColors.errorBorder,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        focusNode: controller.priceNode,
                                        controller:
                                            controller.priceTextController,
                                        validator: (value) {
                                          if (value == null || value == "") {
                                            controller.alertPrice();
                                            return "";
                                          }
                                          return null;
                                        },
                                        onChanged: controller.onChangePrice,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Obx(() {
                                      return GestureDetector(
                                        onTap: () {
                                          if (controller.disabledBuy.value) {
                                            return;
                                          }
                                          controller.submitAddLottery(
                                            controller.lottery,
                                            controller.price,
                                          );
                                        },
                                        child: Container(
                                          height: 48,
                                          width: 48,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: controller.disabledBuy.value
                                                ? AppColors.disable
                                                : AppColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: SvgPicture.asset(
                                            AppIcon.add,
                                            colorFilter: ColorFilter.mode(
                                              controller.disabledBuy.value
                                                  ? Colors.black
                                                      .withOpacity(0.6)
                                                  : Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                            width: 36,
                                            height: 36,
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LongButton(
                                  onPressed: () {
                                    controller.confirmLottery(
                                        context); // lottery confirm
                                  },
                                  disabled: controller.disabledBuy.value,
                                  child: Text(
                                    AppLocale.confirmBuyLottery
                                        .getString(context),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.isLoadingAddLottery.value)
                Container(
                  color: Colors.white.withOpacity(0.85),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        });
      },
    );
  }
}
