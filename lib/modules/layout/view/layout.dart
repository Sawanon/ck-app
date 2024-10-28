import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/blur_app.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/components/navigation_bar.dart';
import 'package:lottery_ck/components/no_network_dialog.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery.page.dart';
import 'package:lottery_ck/modules/history/view/history.dart';
import 'package:lottery_ck/modules/home/view/home.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/lottery_history/view/lottery_history.dart';
import 'package:lottery_ck/modules/notification/view/notification.dart';
import 'package:lottery_ck/modules/setting/view/setting.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class LayoutPage extends StatelessWidget {
  LayoutPage({super.key});
  // final pages = [
  //   HomePage(),
  //   HistoryPage(),
  //   LotteryHistoryPage(),
  //   // BuyLotteryPage(),
  //   NotificationPage(),
  //   SettingPage(),
  // ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LayoutController>(
      builder: (controller) {
        if (controller.noNetwork) {
          return NoNetworkDialog(identifier: 'identifier');
        }
        if (controller.isBlur) {
          return BlurApp(identifier: 'identifier');
        }
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            logger.w("didPop: $didPop");
            if (didPop) {}
            Get.dialog(
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "ທ່ານແນ່ໃຈບໍ່ວ່າຕ້ອງການອອກຈາກແອັບ?",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: LongButton(
                                // maximumSize: Size(width, height),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  "ຍົກເລີກ",
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LongButton(
                                backgroundColor: Colors.white,
                                borderSide: BorderSide(
                                  width: 1,
                                  color: AppColors.errorBorder,
                                ),
                                onPressed: () {
                                  Get.back();
                                  SystemNavigator.pop();
                                },
                                child: Text(
                                  "ອອກ",
                                  style: TextStyle(
                                    color: AppColors.errorBorder,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              useSafeArea: true,
            );
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              top: false,
              child: Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    padding: EdgeInsets.only(bottom: controller.bottomPadding),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: controller.currentPage(controller.currentTab),
                    // child: pages[controller.tabIndex],
                    // child: Text('${controller.tabIndex}'),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomNavigationBar(
                      currentTab: controller.currentTab,
                      onChangeTab: controller.changeTab,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
