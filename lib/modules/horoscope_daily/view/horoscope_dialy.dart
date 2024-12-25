import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils/theme.dart';

class HoroscopeDialyPage extends StatelessWidget {
  const HoroscopeDialyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: 'โชคลาภประจำวัน',
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Builder(
                    builder: (context) {
                      final backgroundTheme =
                          LayoutController.to.randomBackgroundThemeUrl();
                      if (backgroundTheme == null) {
                        return const SizedBox.shrink();
                      }
                      return Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(52),
                                topRight: Radius.circular(52),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: backgroundTheme,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      GestureDetector(
                        onTap: () {
                          HomeController.to.gotoHoroScope();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [AppTheme.softShadow],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 52,
                                height: 52,
                                child: Image.asset(
                                  AppIcon.todayHoroscope,
                                ),
                                // child: SvgPicture.asset(
                                //   AppIcon.horoscope,
                                //   colorFilter: const ColorFilter.mode(
                                //     AppColors.menuIcon,
                                //     BlendMode.srcIn,
                                //   ),
                                // ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "ดวงวันนี้",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: SvgPicture.asset(
                                  AppIcon.arrowRight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          HomeController.to.gotoRandomCard();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [AppTheme.softShadow],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 52,
                                height: 52,
                                child: Image.asset(
                                  AppIcon.todayCard,
                                ),
                                // child: SvgPicture.asset(
                                //   AppIcon.card,
                                //   colorFilter: const ColorFilter.mode(
                                //     AppColors.menuIcon,
                                //     BlendMode.srcIn,
                                //   ),
                                // ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "ไพ่นำโชค",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: SvgPicture.asset(
                                  AppIcon.arrowRight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteName.animal, arguments: [
                            (List<Map<String, dynamic>> lotteryMapList) async {
                              Get.back();
                              LayoutController.to.changeTab(TabApp.lottery);
                              BuyLotteryController.to
                                  .onClickAnimalBuy(lotteryMapList);
                            },
                            false,
                          ]
                              // arguments: [onClickAnimalBuy, disabledBuy.value],
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [AppTheme.softShadow],
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 52,
                                height: 52,
                                child: Image.asset(
                                  AppIcon.todayBook,
                                ),
                                // child: SvgPicture.asset(
                                //   AppIcon.animal,
                                //   colorFilter: const ColorFilter.mode(
                                //     AppColors.menuIcon,
                                //     BlendMode.srcIn,
                                //   ),
                                // ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  AppLocale.animal.getString(context),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: SvgPicture.asset(
                                  AppIcon.arrowRight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}