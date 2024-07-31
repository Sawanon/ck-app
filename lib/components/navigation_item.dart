import 'package:flutter/material.dart';
import 'package:lottery_ck/res/color.dart';

class NavigationItem extends StatelessWidget {
  final void Function(int index) changeTab;
  final int index;
  final int currentIndex;
  final Widget icon;
  final Widget activeIcon;
  final String label;
  const NavigationItem({
    super.key,
    required this.changeTab,
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 62,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: currentIndex == index ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.2)),
          onTap: () {
            changeTab(index);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              renderIcon(
                  active: currentIndex == index,
                  icon: icon,
                  activeIcon: activeIcon),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  // fontWeight:
                  //     currentIndex == index ? FontWeight.w700 : FontWeight.w500,
                  color:
                      currentIndex == index ? AppColors.primary : Colors.white,
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
