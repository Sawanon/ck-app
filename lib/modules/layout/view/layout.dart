import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/blur_app.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/components/navigation_bar.dart';
import 'package:lottery_ck/components/no_network_dialog.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/theme.dart';

class LayoutPage extends StatelessWidget {
  const LayoutPage({super.key});
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
          return NoNetworkDialog(
            identifier: 'identifier',
            onConfirm: () {
              // logger.d("refresh network");
              controller.restartApp();
            },
          );
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
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${AppLocale.areYouSureYouWantExitApp.getString(context)}?",
                          style: const TextStyle(
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
                                  AppLocale.cancel.getString(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LongButton(
                                backgroundColor: Colors.white,
                                borderSide: const BorderSide(
                                  width: 1,
                                  color: AppColors.errorBorder,
                                ),
                                onPressed: () {
                                  Get.back();
                                  SystemNavigator.pop();
                                },
                                child: Text(
                                  AppLocale.leave.getString(context),
                                  style: const TextStyle(
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
          child: Builder(builder: (context) {
            if (controller.isBlur) {
              return const BlurApp(identifier: 'identifier');
            }
            return Visibility(
              maintainState: true,
              maintainSize: true,
              maintainAnimation: true,
              visible: !controller.isBlur,
              child: Scaffold(
                // backgroundColor: Colors.white,
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  top: false,
                  child: Stack(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        padding:
                            EdgeInsets.only(bottom: controller.bottomPadding),
                        decoration: const BoxDecoration(
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
                      Obx(() {
                        return Positioned(
                          bottom: controller.snackbarPosition.value ==
                                  SnackPositions.bottom
                              ? 0
                              : null,
                          top: controller.snackbarPosition.value ==
                                  SnackPositions.top
                              ? 0
                              : null,
                          left: 0,
                          right: 0,
                          child: Builder(builder: (context) {
                            if (controller.isOpenSnackBar.value) {
                              return Container(
                                margin: const EdgeInsets.only(
                                  left: 24,
                                  right: 24,
                                  bottom: 140,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(48),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 1),
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 2,
                                    )
                                  ],
                                ),
                                child: Text(
                                  controller.snackMessage.value,
                                  textAlign: TextAlign.center,
                                ),
                              )
                                  .animate(
                                    target: controller.isOpenSnackBarFade.value
                                        ? 1
                                        : 0,
                                  )
                                  .fade();
                            }
                            return const SizedBox.shrink();
                          }),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
