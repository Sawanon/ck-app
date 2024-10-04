import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
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
        BuyLotteryController.to.listPromotions();
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
                        // if (controller.lotteryIsEmpty)
                        //   Expanded(
                        //       child: Container(
                        //     alignment: Alignment.center,
                        //     child: Text(
                        //       "กรุณาเพิ่มเลขที่ต้องการซื้อ",
                        //       style: TextStyle(
                        //         color: AppColors.disableText,
                        //       ),
                        //     ),
                        //   )),
                        // if (!controller.lotteryIsEmpty)
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
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ເລກທີ່ເລືອກ",
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "ຈໍານວນເງິນ",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
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
                                                                  .circular(10),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              'ທ່ານແນ່ໃຈບໍ່ວ່າຕ້ອງການລຶບລາຍການຫວຍທັງໝົດ?',
                                                              style: TextStyle(
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
                                                                          BorderRadius.circular(
                                                                              10),
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
                                                                        color: AppColors
                                                                            .errorBorder,
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
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
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  color: AppColors.errorBorder,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      children: controller.invoiceMeta.value
                                              .transactions.isEmpty
                                          ? [
                                              Container(
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
                                              )
                                            ]
                                          // : controller.lotteryList.map(
                                          : controller
                                              .invoiceMeta.value.transactions
                                              .map(
                                              (lotteryData) {
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 8),
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.foreground,
                                                    boxShadow: [
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
                                                                    .price),
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .textPrimary,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          if (lotteryData
                                                                      .bonus !=
                                                                  null &&
                                                              lotteryData
                                                                      .bonus !=
                                                                  0)
                                                            Text(
                                                              '+${CommonFn.parseMoney(controller.calfromPercent(lotteryData.bonus!, lotteryData.price))}',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
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
                              Expanded(child: Text("Total amount")),
                              Text(
                                // CommonFn.parseMoney(
                                //     controller.totalAmount.value),
                                CommonFn.parseMoney(
                                    controller.invoiceMeta.value.amount),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (controller.invoiceMeta.value.bonus != null &&
                                  controller.invoiceMeta.value.bonus != 0)
                                Text(
                                  "+${CommonFn.parseMoney(controller.invoiceMeta.value.bonus!)}%",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            logger.d("message");
                            controller.calPromotion();
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  color: Colors.white,
                                  child: ListView.separated(
                                      padding: const EdgeInsets.all(16),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            final condition = jsonDecode(
                                                controller.promotionList[index]
                                                    ['condition'][0]);
                                            logger.d(condition);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: AppColors.borderGray),
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                  child: SvgPicture.asset(
                                                      AppIcon.promotion),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${controller.promotionList[index]['name']}',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppColors
                                                              .textPrimary,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        '${controller.promotionList[index]['detail']}',
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .textPrimary,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
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
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 8),
                                      itemCount:
                                          controller.promotionList.length),
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
                            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                                  "Promotions",
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
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
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
                                          hintText: 'เลขที่ซื้อ',
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
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () => controller.gotoAnimalPage(),
                                      child: Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: SvgPicture.asset(
                                                  AppIcon.animal),
                                            ),
                                            Text(
                                              AppLocale.animal
                                                  .getString(context),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                                          hintText: 'ราคา',
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
                                    GestureDetector(
                                      onTap: () {
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
                                          color: AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: SvgPicture.asset(
                                          AppIcon.add,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                          width: 36,
                                          height: 36,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LongButton(
                                  onPressed: () {
                                    controller.confirmLottery(
                                        context); // lottery confirm
                                  },
                                  child: Text(
                                    "สั่งซื้อหวย",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   // color: Colors.blue,
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 16.0,
                        //     vertical: 8,
                        //   ),
                        //   height: 144,
                        //   child: Column(
                        //     mainAxisSize: MainAxisSize.min,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Container(
                        //         clipBehavior: Clip.hardEdge,
                        //         decoration: BoxDecoration(
                        //           color: Colors.white,
                        //           borderRadius: BorderRadius.circular(10),
                        //           border: Border.all(
                        //             color: AppColors.borderGray,
                        //             width: 1,
                        //           ),
                        //         ),
                        //         child: Form(
                        //           key: controller.formKey,
                        //           child: IntrinsicHeight(
                        //             child: Row(
                        //               crossAxisAlignment: CrossAxisAlignment.stretch,
                        //               children: [
                        //                 Container(
                        //                   padding: EdgeInsets.all(8),
                        //                   // color: Colors.blue.shade200,
                        //                   child: Row(
                        //                     children: [
                        //                       GestureDetector(
                        //                         onTap: () {
                        //                           controller.gotoAnimalPage();
                        //                         },
                        //                         child: Container(
                        //                           width: 52,
                        //                           height: 52,
                        //                           decoration: BoxDecoration(
                        //                             color: AppColors.primary,
                        //                             shape: BoxShape.circle,
                        //                           ),
                        //                           child: Column(
                        //                             mainAxisAlignment:
                        //                                 MainAxisAlignment.center,
                        //                             children: [
                        //                               SvgPicture.asset(
                        //                                 AppIcon.animal,
                        //                                 width: 24,
                        //                                 height: 24,
                        //                               ),
                        //                               Text(
                        //                                 "ตำรา",
                        //                                 style: TextStyle(
                        //                                   color: Colors.white,
                        //                                   fontWeight: FontWeight.w700,
                        //                                   height: 0.8,
                        //                                 ),
                        //                               ),
                        //                             ],
                        //                           ),
                        //                         ),
                        //                       ),
                        //                       const SizedBox(width: 6),
                        //                       Container(
                        //                         width: 52,
                        //                         height: 52,
                        //                         decoration: BoxDecoration(
                        //                           color: AppColors.primary,
                        //                           shape: BoxShape.circle,
                        //                         ),
                        //                         child: Column(
                        //                           mainAxisAlignment:
                        //                               MainAxisAlignment.center,
                        //                           children: [
                        //                             SvgPicture.asset(
                        //                               AppIcon.shuffle,
                        //                               colorFilter:
                        //                                   const ColorFilter.mode(
                        //                                 Colors.white,
                        //                                 BlendMode.srcIn,
                        //                               ),
                        //                               width: 24,
                        //                               height: 24,
                        //                             ),
                        //                             Text(
                        //                               "ສຸ່ມ",
                        //                               style: TextStyle(
                        //                                 color: Colors.white,
                        //                                 fontWeight: FontWeight.w700,
                        //                                 fontSize: 16,
                        //                                 height: 0.8,
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                       ),
                        //                       const SizedBox(width: 8),
                        //                       Container(
                        //                         width: 80,
                        //                         child: TextFormField(
                        //                           focusNode: controller.lotteryNode,
                        //                           controller: controller
                        //                               .lotteryTextController,
                        //                           keyboardType: TextInputType.number,
                        //                           inputFormatters: [
                        //                             FilteringTextInputFormatter
                        //                                 .digitsOnly
                        //                           ],
                        //                           decoration: InputDecoration(
                        //                             errorStyle: TextStyle(height: 0),
                        //                             enabledBorder: InputBorder.none,
                        //                             focusedBorder: InputBorder.none,
                        //                           ),
                        //                           validator: (value) {
                        //                             if (value == null ||
                        //                                 value == "") {
                        //                               controller.alertLotteryEmpty();
                        //                               return "";
                        //                             }
                        //                             return null;
                        //                           },
                        //                           onChanged: (value) {
                        //                             controller.lottery = value;
                        //                           },
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //                 Expanded(
                        //                   child: Container(
                        //                     padding: const EdgeInsets.all(8.0),
                        //                     decoration: BoxDecoration(
                        //                       border: Border(
                        //                         left: BorderSide(
                        //                           width: 1,
                        //                           color: AppColors.borderGray,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                     child: Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment.end,
                        //                       children: [
                        //                         Expanded(
                        //                           child: TextFormField(
                        //                             keyboardType:
                        //                                 TextInputType.number,
                        //                             inputFormatters: [
                        //                               FilteringTextInputFormatter
                        //                                   .digitsOnly,
                        //                             ],
                        //                             focusNode: controller.priceNode,
                        //                             controller: controller
                        //                                 .priceTextController,
                        //                             onChanged:
                        //                                 controller.onChangePrice,
                        //                             decoration: InputDecoration(
                        //                               errorStyle:
                        //                                   TextStyle(height: 0),
                        //                               enabledBorder: InputBorder.none,
                        //                               focusedBorder: InputBorder.none,
                        //                             ),
                        //                             validator: (value) {
                        //                               if (value == null ||
                        //                                   value == "") {
                        //                                 controller.alertPrice();
                        //                                 return "";
                        //                               }
                        //                               return null;
                        //                             },
                        //                           ),
                        //                         ),
                        //                         const SizedBox(width: 8),
                        //                         GestureDetector(
                        //                           onTap: () {
                        //                             controller.submitAddLottery(
                        //                               controller.lottery,
                        //                               controller.price,
                        //                             );
                        //                           },
                        //                           child: Container(
                        //                             height: 52,
                        //                             width: 52,
                        //                             alignment: Alignment.center,
                        //                             decoration: BoxDecoration(
                        //                               color: AppColors.primary,
                        //                               borderRadius:
                        //                                   BorderRadius.circular(5),
                        //                             ),
                        //                             child: SvgPicture.asset(
                        //                               AppIcon.add,
                        //                               colorFilter:
                        //                                   const ColorFilter.mode(
                        //                                 Colors.white,
                        //                                 BlendMode.srcIn,
                        //                               ),
                        //                               width: 36,
                        //                               height: 36,
                        //                             ),
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       const SizedBox(height: 8),
                        //       Container(
                        //         // color: Colors.amber,
                        //         child: IntrinsicHeight(
                        //           child: Row(
                        //             crossAxisAlignment: CrossAxisAlignment.stretch,
                        //             children: [
                        //               Expanded(
                        //                 child: Container(
                        //                   padding:
                        //                       EdgeInsets.symmetric(horizontal: 16),
                        //                   decoration: BoxDecoration(
                        //                     border: Border.all(
                        //                       width: 1,
                        //                       color: AppColors.borderGray,
                        //                     ),
                        //                     borderRadius: BorderRadius.circular(10),
                        //                     color: Colors.white,
                        //                   ),
                        //                   child: Row(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.spaceBetween,
                        //                     children: [
                        //                       Text(
                        //                         AppLocale.totalAmount
                        //                             .getString(context),
                        //                         style: TextStyle(
                        //                           fontSize: 16,
                        //                         ),
                        //                       ),
                        //                       Obx(() {
                        //                         return Text(
                        //                           CommonFn.parseMoney(
                        //                               controller.totalAmount.value),
                        //                           style: TextStyle(
                        //                             fontSize: 24,
                        //                           ),
                        //                         );
                        //                       }),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ),
                        //               const SizedBox(width: 4),
                        //               GestureDetector(
                        //                 onTap: () {
                        //                   controller.confirmLottery(
                        //                       context); // lottery confirm
                        //                 },
                        //                 child: Container(
                        //                   alignment: Alignment.center,
                        //                   padding: const EdgeInsets.symmetric(
                        //                       horizontal: 24),
                        //                   height: 50,
                        //                   decoration: BoxDecoration(
                        //                     color: AppColors.primary,
                        //                     borderRadius: BorderRadius.circular(10),
                        //                   ),
                        //                   child: Text(
                        //                     AppLocale.confirm.getString(context),
                        //                     style: TextStyle(
                        //                       fontSize: 16,
                        //                       fontWeight: FontWeight.w700,
                        //                       color: Colors.white,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )
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
