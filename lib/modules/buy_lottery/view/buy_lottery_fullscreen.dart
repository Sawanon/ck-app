import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/view/animal_lottery.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/random/view/random_page.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/res/logo.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:lottery_ck/utils/theme.dart';

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
                                    final remain =
                                        controller.invoiceRemainExpire.value;
                                    Color backgroundColor =
                                        Colors.amber.shade100;
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
                                    return Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                      ),
                                      child: Text(
                                        "${AppLocale.thisInvoiceExpiresOn.getString(context)} ${controller.invoiceRemainExpireStr.value}",
                                        style: TextStyle(
                                          color: textColor,
                                        ),
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
                                        Row(
                                          children: [
                                            Text(
                                              AppLocale.amount
                                                  .getString(context),
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 16,
                                            ),
                                            // if (controller.invoiceMeta.value
                                            //             .bonus !=
                                            //         0 &&
                                            //     controller.invoiceMeta.value
                                            //             .bonus !=
                                            //         null) ...[
                                            //   const SizedBox(
                                            //     width: 16,
                                            //   ),
                                            //   Text(
                                            //     AppLocale.bonus
                                            //         .getString(context),
                                            //     style: const TextStyle(
                                            //       fontSize: 14,
                                            //     ),
                                            //   ),
                                            // ],
                                            // const SizedBox(width: 8),
                                            Builder(builder: (context) {
                                              final lotteryEmpty = controller
                                                  .invoiceMeta
                                                  .value
                                                  .transactions
                                                  .isEmpty;
                                              return GestureDetector(
                                                onTap: () {
                                                  if (lotteryEmpty) {
                                                    return;
                                                  }
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
                                                                AppLocale
                                                                    .areYouSureYouWantToDeleteAllLottery
                                                                    .getString(
                                                                        context),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 12),
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
                                                                      AppLocale
                                                                          .cancel
                                                                          .getString(
                                                                              context),
                                                                    ),
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
                                                                          .removeAllLotteryV2();
                                                                      navigator
                                                                          ?.pop();
                                                                    },
                                                                    child: Text(
                                                                      AppLocale
                                                                          .deleteAll
                                                                          .getString(
                                                                              context),
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
                                                      color: lotteryEmpty
                                                          ? AppColors
                                                              .disableText
                                                          : AppColors
                                                              .errorBorder,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: lotteryEmpty
                                                        ? AppColors.disableText
                                                        : AppColors.errorBorder,
                                                  ),
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Obx(() {
                                      final invoice =
                                          controller.invoiceMeta.value;
                                      return ListView(
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        children: invoice.transactions.isEmpty
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
                                                ),
                                                const SizedBox(height: 16),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      Logo.lottoMini,
                                                      width: 100,
                                                      height: 100,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Image.asset(
                                                      "assets/png/logo.png",
                                                      width: 100,
                                                      height: 100,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "${AppLocale.lotteryDateAt.getString(context)}: ${HomeController.to.lotteryDateStr}",
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  "${AppLocale.closeSaleIn.getString(context)}: ${HomeController.to.remainingDateTime.value.inDays} ${AppLocale.day} : ${HomeController.to.remainingDateTime.value.inHours.remainder(24).toString().padLeft(2, "0")} : ${HomeController.to.remainingDateTime.value.inMinutes.remainder(60).toString().padLeft(2, "0")} : ${HomeController.to.remainingDateTime.value.inSeconds.remainder(60).toString().padLeft(2, "0")}",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ]
                                            // : controller.lotteryList.map(
                                            : invoice.transactions.reversed
                                                .toList()
                                                .map(
                                                (lotteryData) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      controller.editLotteryV2(
                                                        lotteryData.lottery,
                                                        lotteryData.quota,
                                                      );
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .foreground,
                                                        boxShadow: const [
                                                          BoxShadow(
                                                            color: AppColors
                                                                .foregroundBorder,
                                                            offset:
                                                                Offset(0, 0),
                                                            spreadRadius: 1,
                                                          )
                                                        ],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 110,
                                                            child: Text(
                                                              lotteryData
                                                                  .lottery,
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .textPrimary,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child:
                                                                  AnimalLottery(
                                                                lottery:
                                                                    lotteryData
                                                                        .lottery,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                CommonFn.parseMoney(
                                                                    lotteryData
                                                                        .quota),
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColors
                                                                      .textPrimary,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 16,
                                                              ),
                                                              // if (lotteryData
                                                              //             .bonus !=
                                                              //         null &&
                                                              //     lotteryData
                                                              //             .bonus !=
                                                              //         0) ...[
                                                              //   const SizedBox(
                                                              //       width: 16),
                                                              //   Text(
                                                              //     '+${CommonFn.parseMoney(lotteryData.bonus!)}',
                                                              //     style:
                                                              //         TextStyle(
                                                              //       fontSize: 16,
                                                              //       fontWeight:
                                                              //           FontWeight
                                                              //               .w500,
                                                              //       color: Colors
                                                              //           .green,
                                                              //     ),
                                                              //   ),
                                                              // ],
                                                              // const SizedBox(
                                                              //     width: 8),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  controller
                                                                      .removeLotteryV2(
                                                                          lotteryData);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          2),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(4),
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
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // borderRadius: BorderRadius.circular(24),
                            boxShadow: const [AppTheme.softShadow],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocale.numberOfLottery
                                        .getString(context)),
                                    Text(
                                      "${controller.invoiceMeta.value.transactions.length}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(AppLocale.totalAmount
                                            .getString(context))),
                                    Text(
                                      // CommonFn.parseMoney(
                                      //     controller.totalAmount.value),
                                      "${CommonFn.parseMoney(controller.invoiceMeta.value.quota)} ${AppLocale.lak.getString(context)}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
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
                                      // Row(
                                      //   children: [
                                      //     Expanded(
                                      //       child: TextFormField(
                                      //         maxLength: 6,
                                      //         textAlign: TextAlign.center,
                                      //         decoration: InputDecoration(
                                      //           counterText: "",
                                      //           hintText: AppLocale
                                      //               .hihtLotteryInput
                                      //               .getString(context),
                                      //           errorStyle:
                                      //               TextStyle(height: 0),
                                      //           contentPadding:
                                      //               const EdgeInsets.symmetric(
                                      //                   horizontal: 8),
                                      //           enabledBorder:
                                      //               OutlineInputBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(8),
                                      //             borderSide: const BorderSide(
                                      //               color: AppColors.borderGray,
                                      //             ),
                                      //           ),
                                      //           focusedBorder:
                                      //               OutlineInputBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(8),
                                      //             borderSide: const BorderSide(
                                      //               color: AppColors.borderGray,
                                      //               width: 1,
                                      //             ),
                                      //           ),
                                      //           errorBorder: OutlineInputBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(8),
                                      //             borderSide: const BorderSide(
                                      //               color:
                                      //                   AppColors.errorBorder,
                                      //               width: 2,
                                      //             ),
                                      //           ),
                                      //           focusedErrorBorder:
                                      //               OutlineInputBorder(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(8),
                                      //             borderSide: const BorderSide(
                                      //               color:
                                      //                   AppColors.errorBorder,
                                      //               width: 2,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //         focusNode: controller.lotteryNode,
                                      //         controller: controller
                                      //             .lotteryTextController,
                                      //         keyboardType:
                                      //             TextInputType.number,
                                      //         inputFormatters: [
                                      //           FilteringTextInputFormatter
                                      //               .digitsOnly
                                      //         ],
                                      //         validator: (value) {
                                      //           logger.d("validator: $value");
                                      //           if (value == null ||
                                      //               value == "") {
                                      //             controller
                                      //                 .alertLotteryEmpty();
                                      //             return "";
                                      //           }
                                      //           return null;
                                      //         },
                                      //         onChanged: (value) {
                                      //           controller.lottery = value;
                                      //         },
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      // const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                () => RandomPage(),
                                              );
                                            },
                                            child: Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child: SvgPicture.asset(
                                                      AppIcon.random,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                        Colors.white,
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    AppLocale.random
                                                        .getString(context),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: TextFormField(
                                              maxLength: 6,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                counterText: "",
                                                hintText: AppLocale
                                                    .hihtLotteryInput
                                                    .getString(context),
                                                errorStyle:
                                                    TextStyle(height: 0),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: AppColors.borderGray,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                                    color:
                                                        AppColors.errorBorder,
                                                    width: 2,
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color:
                                                        AppColors.errorBorder,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              focusNode: controller.lotteryNode,
                                              controller: controller
                                                  .lotteryTextController,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              validator: (value) {
                                                logger.d("validator: $value");
                                                if (value == null ||
                                                    value == "") {
                                                  controller
                                                      .alertLotteryEmpty();
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
                                          Expanded(
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText: AppLocale
                                                    .hihtPriceInput
                                                    .getString(context),
                                                errorStyle:
                                                    const TextStyle(height: 0),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: AppColors.borderGray,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                                    color:
                                                        AppColors.errorBorder,
                                                    width: 2,
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color:
                                                        AppColors.errorBorder,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              focusNode: controller.priceNode,
                                              controller: controller
                                                  .priceTextController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value == "") {
                                                  controller.alertPrice();
                                                  return "";
                                                }
                                                return null;
                                              },
                                              onChanged:
                                                  controller.onChangePrice,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Obx(() {
                                            return GestureDetector(
                                              onTap: () {
                                                if (controller
                                                    .disabledBuy.value) {
                                                  return;
                                                }
                                                controller
                                                    .submitFormAddLotteryV2(
                                                  controller.lottery,
                                                  controller.price,
                                                  true,
                                                );
                                              },
                                              child: Container(
                                                height: 48,
                                                width: 48,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  color: controller
                                                          .disabledBuy.value
                                                      ? AppColors.disable
                                                      : AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SvgPicture.asset(
                                                      AppIcon.add,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        controller.disabledBuy
                                                                .value
                                                            ? Colors.black
                                                                .withOpacity(
                                                                    0.6)
                                                            : Colors.white,
                                                        BlendMode.srcIn,
                                                      ),
                                                      width: 24,
                                                      height: 24,
                                                    ),
                                                    Text(
                                                      AppLocale.add,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Obx(() {
                                        final invoice =
                                            controller.invoiceMeta.value;
                                        final disabled =
                                            controller.disabledBuy.value ||
                                                invoice.transactions.isEmpty;
                                        return LongButton(
                                          onPressed: () {
                                            // controller.confirmLottery(
                                            //     context); // lottery confirm
                                            controller.confirmLotteryV2();
                                          },
                                          disabled: disabled,
                                          child: Text(
                                            AppLocale.confirmPay
                                                .getString(context),
                                            // AppLocale.confirmBuyLottery
                                            //     .getString(context),
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
