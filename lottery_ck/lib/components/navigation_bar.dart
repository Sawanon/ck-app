import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottery_ck/components/navigation_item.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';

class CustomNavigationBar extends StatefulWidget {
  void Function(int index)? onChangeTab;
  int menuIndex;
  CustomNavigationBar({
    super.key,
    this.onChangeTab,
    required this.menuIndex,
  });

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  void changeTab(int index) {
    if (widget.onChangeTab != null) {
      widget.onChangeTab!(index);
    }
    setState(() {
      widget.menuIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        // color: AppColors.primary,
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: NavigationItem(
              changeTab: changeTab,
              index: 0,
              currentIndex: widget.menuIndex,
              icon: SvgPicture.asset(
                AppIcon.home,
                colorFilter: const ColorFilter.mode(
                  // Colors.white.withOpacity(0.8),
                  Colors.grey,
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
              label: 'Home',
            ),
          ),
          Expanded(
            child: NavigationItem(
              changeTab: changeTab,
              index: 1,
              currentIndex: widget.menuIndex,
              icon: SvgPicture.asset(
                AppIcon.history,
                colorFilter: ColorFilter.mode(
                  Colors.grey,
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
              label: 'History',
            ),
          ),
          Expanded(
            child: NavigationItem(
              changeTab: changeTab,
              index: 2,
              currentIndex: widget.menuIndex,
              icon: SvgPicture.asset(
                AppIcon.lottery,
                colorFilter: ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              activeIcon: SvgPicture.asset(
                AppIcon.lotteryBold,
                colorFilter: ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              label: 'Lottery',
            ),
          ),
          Expanded(
            child: NavigationItem(
              changeTab: changeTab,
              index: 3,
              currentIndex: widget.menuIndex,
              icon: SvgPicture.asset(
                AppIcon.notification,
                colorFilter: ColorFilter.mode(
                  Colors.grey,
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
              label: 'Notification',
            ),
          ),
          Expanded(
            child: NavigationItem(
              changeTab: changeTab,
              index: 1,
              currentIndex: widget.menuIndex,
              icon: SvgPicture.asset(
                AppIcon.setting,
                colorFilter: ColorFilter.mode(
                  Colors.grey,
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
              label: 'Setting',
            ),
          ),
        ],
      ),
    );
  }
}
