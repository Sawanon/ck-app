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
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      height: 74,
      decoration: BoxDecoration(
        // color: AppColors.primary,
        borderRadius: BorderRadius.circular(50),
        color: AppColors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavigationItem(
            changeTab: changeTab,
            index: 0,
            currentIndex: widget.menuIndex,
            icon: SvgPicture.asset(
              AppIcon.home,
              colorFilter: const ColorFilter.mode(
                // Colors.white.withOpacity(0.8),
                Colors.white,
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
            label: 'หน้าหลัก',
          ),
          NavigationItem(
            changeTab: changeTab,
            index: 1,
            currentIndex: widget.menuIndex,
            icon: SvgPicture.asset(
              AppIcon.history,
              colorFilter: ColorFilter.mode(
                Colors.white,
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
            label: 'ประวัติซื้อ',
          ),
          NavigationItem(
            changeTab: changeTab,
            index: 2,
            currentIndex: widget.menuIndex,
            icon: SvgPicture.asset(
              AppIcon.lottery,
              colorFilter: ColorFilter.mode(
                Colors.white,
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
            label: 'ผลหวย',
          ),
          NavigationItem(
            changeTab: changeTab,
            index: 3,
            currentIndex: widget.menuIndex,
            icon: SvgPicture.asset(
              AppIcon.notification,
              colorFilter: ColorFilter.mode(
                Colors.white,
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
            label: 'แจ้งเตือน',
          ),
          NavigationItem(
            changeTab: changeTab,
            index: 1,
            currentIndex: widget.menuIndex,
            icon: SvgPicture.asset(
              AppIcon.setting,
              colorFilter: ColorFilter.mode(
                Colors.white,
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
            label: 'ตั้งค่า',
          ),
        ],
      ),
    );
  }
}
