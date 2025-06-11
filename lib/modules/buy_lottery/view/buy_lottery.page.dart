import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/animal/view/animal_component.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery_fullscreen.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/webview/view/webview_component.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class BuyLotteryPage extends StatefulWidget {
  const BuyLotteryPage({super.key});

  @override
  State<BuyLotteryPage> createState() => _BuyLotteryPageState();
}

class _BuyLotteryPageState extends State<BuyLotteryPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyLotteryController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.onChangeTab(1),
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: controller.currentTab.value == 1
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: Image.asset(AppIcon.todayHoroscope),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  AppLocale.horoscopeToday.getString(context),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: controller.currentTab.value == 1
                                        ? Colors.white
                                        : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.onChangeTab(2),
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: controller.currentTab.value == 2
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: Image.asset(AppIcon.todayCard),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  AppLocale.randomCard.getString(context),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: controller.currentTab.value == 2
                                        ? Colors.white
                                        : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.onChangeTab(3),
                          child: Container(
                            height: 42,
                            decoration: BoxDecoration(
                              color: controller.currentTab.value == 3
                                  ? AppColors.primary
                                  : AppColors.primary.withOpacity(0.1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 36,
                                  height: 36,
                                  child: Image.asset(AppIcon.todayBook),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  AppLocale.animal.getString(context),
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: controller.currentTab.value == 3
                                        ? Colors.white
                                        : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      BuyLotteryFullscreenPage(),
                      // Obx(
                      //   () {
                      // FIXME: remove all tab change to use Get.to(() => Page());
                      // if (controller.currentTab.value == 1 &&
                      //     controller.horoscopeUrl.value != "") {
                      //   return WebviewPageV2(
                      //     url: controller.horoscopeUrl.value,
                      //     padding: EdgeInsets.only(bottom: 102),
                      //     onBack: () {
                      //       controller.confirmOutTodayHoroscope(0);
                      //       // Get.dialog(
                      //       //   DialogApp(
                      //       //     title: Text("คุณต้องการออกจากดวงวันนี้?"),
                      //       //     onConfirm: () async {
                      //       //       controller.onChangeTab(0);
                      //       //       Get.back();
                      //       //     },
                      //       //   ),
                      //       // );
                      //     },
                      //     onMessageReceived: (data) {
                      //       logger.w(data);
                      //     },
                      //   );
                      // } else
                      // if (controller.currentTab.value == 2 &&
                      //     controller.luckyCardUrl.value != "") {
                      //   return WebviewPageV2(
                      //     url: controller.luckyCardUrl.value,
                      //     // url: "http://192.168.1.40:3000",
                      //     // url: "https://staging.randomcards.pages.dev",
                      //     padding: EdgeInsets.only(bottom: 102),
                      //     onBack: () {
                      //       controller.confirmOutTodayLuckyCard(0);
                      //       // Get.dialog(
                      //       //   DialogApp(
                      //       //     title: Text("คุณต้องการออกจากไพ่นำโชค?"),
                      //       //     onConfirm: () async {
                      //       //       controller.onChangeTab(0);
                      //       //       Get.back();
                      //       //     },
                      //       //   ),
                      //       // );
                      //     },
                      //     onMessageReceived: (data) {
                      //       try {
                      //         logger.w(data.message);
                      //         // {number: 123}
                      //         final dataMap = jsonDecode(data.message);
                      //         logger.w(dataMap);
                      //         final lottery = dataMap['number'];
                      //         controller.buyAndGotoLotteryPage(
                      //           lottery,
                      //           () async {
                      //             controller.changeTab(0);
                      //             SettingController.to.getPoint();
                      //             Get.back();
                      //           },
                      //         );
                      //         // controller.setLottery(dataMap['number']);
                      //         // final minPrice =
                      //         //     controller.getMinPrice(lottery);
                      //         // controller.addLottery(
                      //         //   minPrice,
                      //         //   lottery,
                      //         //   true,
                      //         // );
                      //       } catch (e) {
                      //         logger.e("$e");
                      //       }
                      //       // controller.submitAddLottery(lottery, price)
                      //     },
                      //   );
                      // } else if (controller.currentTab.value == 3) {
                      //   return AnimalComponent(
                      //     padding: const EdgeInsets.only(bottom: 122),
                      //     onClickBuy: (lotterise) async {
                      //       await controller.onClickAnimalBuy(lotterise);
                      //     },
                      //     onBack: () {
                      //       controller.confirmOutAnimalBook(0);
                      //     },
                      //   );
                      // }
                      //     return const SizedBox.shrink();
                      //   },
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
