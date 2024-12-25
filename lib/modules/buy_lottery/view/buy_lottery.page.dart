import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/modules/animal/view/animal_component.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery_fullscreen.dart';
import 'package:lottery_ck/modules/lottery_history/view/lottery_history.dart';
import 'package:lottery_ck/modules/webview/view/webview_component.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';

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
                                    fontSize: 14,
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
                                    fontSize: 14,
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
                                    fontSize: 14,
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
                      Obx(
                        () {
                          if (controller.currentTab.value == 1 &&
                              controller.horoscopeUrl.value != "") {
                            return WebviewPageV2(
                              url: controller.horoscopeUrl.value,
                              padding: EdgeInsets.only(bottom: 102),
                              onBack: () {
                                controller.confirmOutTodayHoroscope(0);
                                // Get.dialog(
                                //   DialogApp(
                                //     title: Text("คุณต้องการออกจากดวงวันนี้?"),
                                //     onConfirm: () async {
                                //       controller.onChangeTab(0);
                                //       Get.back();
                                //     },
                                //   ),
                                // );
                              },
                            );
                          } else if (controller.currentTab.value == 2 &&
                              controller.luckyCardUrl.value != "") {
                            return WebviewPageV2(
                              url: controller.luckyCardUrl.value,
                              padding: EdgeInsets.only(bottom: 102),
                              onBack: () {
                                controller.confirmOutTodayLuckyCard(0);
                                // Get.dialog(
                                //   DialogApp(
                                //     title: Text("คุณต้องการออกจากไพ่นำโชค?"),
                                //     onConfirm: () async {
                                //       controller.onChangeTab(0);
                                //       Get.back();
                                //     },
                                //   ),
                                // );
                              },
                            );
                          } else if (controller.currentTab.value == 3) {
                            return AnimalComponent(
                              onClickBuy: (lotterise) async {
                                final isSuccess = await controller
                                    .onClickAnimalBuy(lotterise);
                                final onlyLotteryList = lotterise.map(
                                  (lottery) {
                                    return lottery['lottery'] as String;
                                  },
                                ).toList();
                                if (isSuccess) {
                                  Get.rawSnackbar(
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.green.shade200,
                                    overlayColor: Colors.green.shade800,
                                    margin: const EdgeInsets.all(16),
                                    borderRadius: 16,
                                    messageText: Text(
                                      "เพิ่มเลข ${onlyLotteryList.join(",")} เรียบร้อย",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade800,
                                      ),
                                    ),
                                  );
                                }
                              },
                              onBack: () {
                                controller.confirmOutAnimalBook(0);
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
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
