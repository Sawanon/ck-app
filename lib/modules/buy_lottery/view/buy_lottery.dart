import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';
import 'package:intl/intl.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class BuyLottery extends StatelessWidget {
  const BuyLottery({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyLotteryController>(
      initState: (state) {
        logger.w("initState: BuyLotteryController");
        BuyLotteryController.to.formKey = GlobalKey();
      },
      builder: (controller) {
        return Obx(
          () {
            return SafeArea(
              child: Column(
                mainAxisAlignment: controller.lotteryIsEmpty
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (!controller.lotteryIsEmpty)
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
                                padding: const EdgeInsets.all(16),
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
                                                        const EdgeInsets.all(
                                                            16),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
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
                                                              MainAxisSize.min,
                                                          children: [
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                elevation: 0,
                                                                backgroundColor:
                                                                    AppColors
                                                                        .primary,
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                navigator
                                                                    ?.pop();
                                                              },
                                                              child: Text(
                                                                  "Cancel"),
                                                            ),
                                                            const SizedBox(
                                                                width: 8),
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                elevation: 0,
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
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                              onPressed: () {
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
                                                color: AppColors.errorBorder,
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
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  children: controller.lotteryList.map(
                                    (data) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 8),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.foreground,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.foregroundBorder,
                                              offset: Offset(0, 0),
                                              spreadRadius: 1,
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data.lottery,
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  CommonFn.parseMoney(
                                                      data.amount),
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .removeLottery(data);
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color:
                                                          AppColors.errorBorder,
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
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
                  Container(
                    // color: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    height: 144,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.borderGray,
                              width: 1,
                            ),
                          ),
                          child: Form(
                            key: controller.formKey,
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    // color: Colors.blue.shade200,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            controller.gotoAnimalPage();
                                          },
                                          child: Container(
                                            width: 52,
                                            height: 52,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  AppIcon.animal,
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                Text(
                                                  "ตำรา",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    height: 0.8,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          width: 52,
                                          height: 52,
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                AppIcon.shuffle,
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.srcIn,
                                                ),
                                                width: 24,
                                                height: 24,
                                              ),
                                              Text(
                                                "ສຸ່ມ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                  height: 0.8,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 80,
                                          child: TextFormField(
                                            focusNode: controller.lotteryNode,
                                            controller: controller
                                                .lotteryTextController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(height: 0),
                                              enabledBorder: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value == "") {
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
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            width: 1,
                                            color: AppColors.borderGray,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              focusNode: controller.priceNode,
                                              controller: controller
                                                  .priceTextController,
                                              onChanged:
                                                  controller.onChangePrice,
                                              decoration: InputDecoration(
                                                errorStyle:
                                                    TextStyle(height: 0),
                                                enabledBorder: InputBorder.none,
                                                focusedBorder: InputBorder.none,
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value == "") {
                                                  controller.alertPrice();
                                                  return "";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              controller.submitAddLottery(
                                                controller.lottery,
                                                controller.price,
                                              );
                                            },
                                            child: Container(
                                              height: 52,
                                              width: 52,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: SvgPicture.asset(
                                                AppIcon.add,
                                                colorFilter:
                                                    const ColorFilter.mode(
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          // color: Colors.amber,
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: AppColors.borderGray,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocale.totalAmount
                                              .getString(context),
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        Obx(() {
                                          return Text(
                                            CommonFn.parseMoney(
                                                controller.totalAmount.value),
                                            style: TextStyle(
                                              fontSize: 24,
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    controller.confirmLottery(
                                        context); // lottery confirm
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      AppLocale.confirm.getString(context),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
