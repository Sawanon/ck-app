import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/wheel/controller/wheel_controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';

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
    final items = <String>[
      '1K',
      '5K',
      '10K',
      '15K',
      '20K',
      '30K',
      '50K',
      '100K',
    ];
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
              "วงล้อเสี่ยงดวง",
              style: TextStyle(
                color: AppColors.wheelText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "รวมมูลค่ามากกว่า",
              style: TextStyle(
                color: AppColors.wheelText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "400,000,000 กีบ",
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
                          duration: const Duration(seconds: 10),
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
                                    "${value.amount ?? 0}",
                                    style: TextStyle(
                                      color: AppColors.wheelText,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 30,
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
                                color:
                                    AppColors.wheelBackground.withOpacity(0.8),
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
            GestureDetector(
              onTap: () async {
                selected.add(0);
                int count = 0;
                logger.w("start");
                final timer = Timer.periodic(
                  const Duration(seconds: 1),
                  (timer) {
                    final target = Random().nextInt(items.length);
                    logger.w("target: $target");
                    selected.add(target);
                    count++;
                    if (count > 10) {
                      logger.w("stop maximum count");
                      timer.cancel();
                    }
                  },
                );
                await Future.delayed(
                  const Duration(seconds: 10),
                  () {
                    logger.w("stop maximum time");
                    timer.cancel();
                  },
                );
              },
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
                child: const Text(
                  "SPIN",
                  style: TextStyle(
                    color: AppColors.wheelText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
