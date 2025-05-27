import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/navigation_item.dart';
import 'package:lottery_ck/main.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils/theme.dart';

class CustomNavigationBar extends StatefulWidget {
  void Function(TabApp tab)? onChangeTab;
  TabApp currentTab;
  CustomNavigationBar({
    super.key,
    this.onChangeTab,
    required this.currentTab,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  void onChangeTab(TabApp tab) {
    if (BuyLotteryController.to.currentTab.value != 0) {
      Get.dialog(
        DialogApp(
          title: Text(AppLocale.doYouWantToLeaveThisPage.getString(context)),
          onConfirm: () async {
            BuyLotteryController.to.changeTab(0);
            changeTab(tab);
            Get.back();
          },
        ),
      );
      return;
    }
    changeTab(tab);
  }

  void changeTab(TabApp tab) {
    if (widget.onChangeTab != null) {
      widget.onChangeTab!(tab);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          height: 74,
          // height: 92,
          decoration: BoxDecoration(
            // color: AppColors.primary,
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [AppTheme.softShadow],
            // boxShadow: [
            //   BoxShadow(
            //     offset: Offset(0, -2),
            //     blurRadius: 30,
            //     color: AppColors.shadow,
            //   )
            // ],
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(10),
            //   topRight: Radius.circular(10),
            // ),
            // color: AppColors.primary,
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavigationItem(
                tab: TabApp.home,
                currentTab: widget.currentTab,
                changeTab: onChangeTab,
                index: 0,
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    AppIcon.home,
                    colorFilter: const ColorFilter.mode(
                      // Colors.white.withOpacity(0.8),
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  AppIcon.homeBold,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: AppLocale.home.getString(context),
              ),
              NavigationItem(
                tab: TabApp.history,
                currentTab: widget.currentTab,
                changeTab: onChangeTab,
                index: 1,
                icon: SvgPicture.asset(
                  AppIcon.history,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  AppIcon.historyBold,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                // label: AppLocale.history.getString(context),
                label: AppLocale.history.getString(context),
              ),
              // NavigationItem(
              //   tab: TabApp.lottery,
              //   currentTab: widget.currentTab,
              //   changeTab: changeTab,
              //   index: 2,
              //   icon: SvgPicture.asset(
              //     AppIcon.lottery,
              //     colorFilter: ColorFilter.mode(
              //       AppColors.textPrimary,
              //       BlendMode.srcIn,
              //     ),
              //   ),
              //   activeIcon: SvgPicture.asset(
              //     AppIcon.lotteryBold,
              //     colorFilter: ColorFilter.mode(
              //       AppColors.primary,
              //       BlendMode.srcIn,
              //     ),
              //   ),
              //   // label: 'ຜົນຫວຍ',
              //   label: 'ຊື້ຫວຍ',
              // ),
              const SizedBox(
                height: 62,
                width: 52,
              ),
              NavigationItem(
                tab: TabApp.notifications,
                currentTab: widget.currentTab,
                changeTab: onChangeTab,
                index: 3,
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    AppIcon.scan,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                activeIcon: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset(
                    AppIcon.scanBold,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                // label: AppLocale.notification.getString(context),
                label: AppLocale.scan.getString(context),
              ),
              NavigationItem(
                tab: TabApp.settings,
                currentTab: widget.currentTab,
                changeTab: onChangeTab,
                index: 4,
                icon: SvgPicture.asset(
                  AppIcon.gift,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  AppIcon.giftBold,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                // label: AppLocale.setting.getString(context),
                label: AppLocale.promotion.getString(context),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 32),
          child: GestureDetector(
            onTap: () {
              onChangeTab(TabApp.lottery);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(4),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryEnd,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        "assets/png/logo.png",
                        width: 100,
                        height: 100,
                        scale: 4,
                        fit: BoxFit.none,
                      ),
                      // child: SvgPicture.asset(
                      //   AppIcon.lotteryBold,
                      //   colorFilter: ColorFilter.mode(
                      //     Colors.white,
                      //     BlendMode.srcIn,
                      //   ),
                      // ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  // "ຊື້ຫວຍ",
                  AppLocale.buyLottery.getString(context),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: widget.currentTab == TabApp.lottery
                        ? AppColors.primary
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
