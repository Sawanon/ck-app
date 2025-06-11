import 'package:flutter/material.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:google_fonts/google_fonts.dart';

class NavigationItem extends StatelessWidget {
  final void Function(TabApp tab) changeTab;
  final int index;

  final Widget icon;
  final Widget activeIcon;
  final String label;
  final TabApp tab;
  final TabApp currentTab;
  const NavigationItem({
    super.key,
    required this.changeTab,
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.tab,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 62,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        // color: currentTab == tab ? Colors.white : Colors.transparent,
        color: Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.2)),
          onTap: () {
            changeTab(tab);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              renderIcon(
                  active: currentTab == tab,
                  icon: icon,
                  activeIcon: activeIcon),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  // fontWeight:
                  //     currentTab == tab ? FontWeight.w700 : FontWeight.w500,
                  color: currentTab == tab ? AppColors.primary : Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderIcon({
    required bool active,
    required Widget icon,
    required Widget activeIcon,
  }) {
    if (active) {
      return activeIcon;
    } else {
      return icon;
    }
  }
}
