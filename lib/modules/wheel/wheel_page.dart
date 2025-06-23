import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/wheel/controller/wheel_controller.dart';
import 'package:lottery_ck/modules/wheel/view/dialog_win.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:google_fonts/google_fonts.dart';

class WheelPage extends StatefulWidget {
  const WheelPage({super.key});

  @override
  State<WheelPage> createState() => _WheelPageState();
}

class _WheelPageState extends State<WheelPage> {
  StreamController<int> selected = StreamController<int>();

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wheelController = Get.put(WheelController());

    return Scaffold(
      backgroundColor: AppColors.wheelBackground,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Header(
              title: AppLocale.wheelOfFortune.getString(context),
              backgroundColor: AppColors.wheelBackground,
              textColor: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocale.wheelOfFortune.getString(context),
              style: TextStyle(
                color: AppColors.wheelText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocale.wheelPageTitle1.getString(context),
              style: TextStyle(
                color: AppColors.wheelText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "400,000,000 ${AppLocale.lak.getString(context)}",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.wheelText,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  clipBehavior: Clip.none,
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // color: Colors.amber,
                    border: Border.all(
                      width: 2,
                      color: AppColors.wheelBorder,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.wheelBorderStart,
                        AppColors.wheelBorderEnd,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 2),
                        color: Colors.black,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Obx(() {
                        return FortuneWheel(
                          selected: selected.stream,
                          alignment: Alignment.centerRight,
                          animateFirst: false,
                          physics: NoPanPhysics(),
                          curve: Curves.easeInOutExpo,
                          duration: const Duration(seconds: 3),
                          indicators: [
                            FortuneIndicator(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.wheelBorder,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            FortuneIndicator(
                              child: Container(
                                alignment: Alignment.center,
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  // color: AppColors.wheelBackground,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.wheelBorderStart,
                                      AppColors.wheelBorderEnd,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    width: 1,
                                    color: AppColors.wheelBorder,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                padding: EdgeInsets.all(4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // color: AppColors.wheelBackground,
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.wheelInnerBackgroundStart,
                                        AppColors.wheelInnerBackgroundEnd,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1,
                                      color: AppColors.wheelBorder,
                                    ),
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        ImagePng.gift,
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          // rotationCount: 5,
                          // items: items.asMap().entries.map(
                          items:
                              wheelController.wheelRewards.asMap().entries.map(
                            (entry) {
                              final index = entry.key;
                              final value = entry.value;
                              return FortuneItem(
                                style: FortuneItemStyle(
                                  color: index % 2 == 0
                                      ? AppColors.wheelOdd
                                      : AppColors.wheelEven,
                                  borderColor: AppColors.wheelItemBorder,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 32),
                                  child: Text(
                                    "${value.amount == null ? 0 : CommonFn.parseMoney(value.amount!)}",
                                    style: TextStyle(
                                      color: AppColors.wheelText,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 22,
                                      shadows: [
                                        BoxShadow(
                                          offset: const Offset(0, 1),
                                          color: Colors.black.withOpacity(0.7),
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        );
                      }),
                      Obx(
                        () {
                          if (wheelController.isLoading.value) {
                            return Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.wheelBackground,
                                shape: BoxShape.circle,
                              ),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      Positioned(
                        right: -24,
                        child: Image.asset(
                          ImagePng.wheelArrow,
                          width: 60,
                          height: 60,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
            Obx(() {
              return GestureDetector(
                onTap: () async {
                  if (wheelController.disabledSpin.value) {
                    return;
                  }
                  selected.add(0);
                  int count = 0;
                  logger.w("start");
                  // int? rewardIndex;
                  final timer = Timer.periodic(
                    const Duration(seconds: 1),
                    (timer) {
                      final target =
                          Random().nextInt(wheelController.wheelRewards.length);
                      logger.w("target: $target");
                      selected.add(target);
                      // rewardIndex = target;
                      count++;
                      if (count > 10) {
                        logger.w("stop maximum count");
                        timer.cancel();
                      }
                    },
                  );
                  // await Future.delayed(
                  //   const Duration(seconds: 10),
                  //   () {
                  //     logger.w("stop maximum time");
                  //     timer.cancel();
                  //   },
                  // );
                  final response = await wheelController.requestReward(
                    wheelController.wheelId.value,
                  );
                  timer.cancel();
                  logger.w(response);
                  logger.w("timer cancel");
                  if (response != null) {
                    final rewardId = response['reward']['\$id'];
                    final rewardIndex = wheelController.wheelRewards
                        .indexWhere((reward) => reward.$id == rewardId);
                    if (rewardIndex == -1) {
                      logger.e("can't find reward");
                      return;
                    }
                    logger.w("select reward real");
                    selected.add(rewardIndex);
                    final reward = wheelController.wheelRewards[rewardIndex];
                    await Future.delayed(const Duration(seconds: 3), () {
                      Get.dialog(
                        DialogWin(
                          reward: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                CommonFn.parseMoney(reward.amount ?? 0),
                                style: const TextStyle(
                                  color: AppColors.wheelText,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                AppLocale.point.getString(Get.context!),
                                style: const TextStyle(
                                  color: AppColors.wheelText,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        barrierDismissible: false,
                      );
                    });
                  }
                },
                child: Opacity(
                  opacity: wheelController.disabledSpin.value ? 0.5 : 1,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 64,
                      left: 16,
                      right: 16,
                    ),
                    width: double.infinity,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.wheelEven,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        width: 4,
                        color: AppColors.wheelText,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: Text(
                      AppLocale.spin.getString(context),
                      style: TextStyle(
                        color: AppColors.wheelText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
