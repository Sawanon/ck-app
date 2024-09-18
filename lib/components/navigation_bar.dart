import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottery_ck/components/navigation_item.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';

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
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
          height: 74,
          // height: 89,
          decoration: BoxDecoration(
            // color: AppColors.primary,
            // borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -2),
                blurRadius: 30,
                color: AppColors.shadow,
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            // color: AppColors.primary,
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavigationItem(
                tab: TabApp.home,
                currentTab: widget.currentTab,
                changeTab: changeTab,
                index: 0,
                icon: SvgPicture.asset(
                  AppIcon.home,
                  colorFilter: const ColorFilter.mode(
                    // Colors.white.withOpacity(0.8),
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  AppIcon.homeBold,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'ໜ້າຫຼັກ',
              ),
              NavigationItem(
                tab: TabApp.history,
                currentTab: widget.currentTab,
                changeTab: changeTab,
                index: 1,
                icon: SvgPicture.asset(
                  AppIcon.history,
                  colorFilter: ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  AppIcon.historyBold,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'ປະຫວັດ',
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
                width: 62,
              ),
              NavigationItem(
                tab: TabApp.notifications,
                currentTab: widget.currentTab,
                changeTab: changeTab,
                index: 3,
                icon: SvgPicture.asset(
                  AppIcon.notification,
                  colorFilter: ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  AppIcon.notificationBold,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'ແຈ້ງເຕືອນ',
              ),
              NavigationItem(
                tab: TabApp.settings,
                currentTab: widget.currentTab,
                changeTab: changeTab,
                index: 4,
                icon: SvgPicture.asset(
                  AppIcon.setting,
                  colorFilter: ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                activeIcon: SvgPicture.asset(
                  AppIcon.settingBold,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'ຕັ້ງຄ່າ',
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: GestureDetector(
            onTap: () {
              changeTab(TabApp.lottery);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
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
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(
                      AppIcon.lotteryBold,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Text(
                  "ຊື້ຫວຍ",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: widget.currentTab == TabApp.lottery
                        ? AppColors.primary
                        : AppColors.textPrimary,
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
