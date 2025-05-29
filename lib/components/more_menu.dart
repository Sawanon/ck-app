import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/menu.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/theme.dart';

class MoreMenu extends StatelessWidget {
  const MoreMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MenuModel> menuList = [
      MenuModel(
        ontab: () {},
        icon: SizedBox(
          height: 32,
          width: 32,
          child: SvgPicture.asset(
            AppIcon.calendarTickLinear,
            colorFilter: ColorFilter.mode(
              Colors.grey.shade700,
              BlendMode.srcIn,
            ),
          ),
        ),
        name: Align(
          alignment: Alignment.center,
          child: Text(
            "Check in",
            style: TextStyle(
              color: AppColors.menuTextDisabled,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      ),
      MenuModel(
        disabled: true,
        ontab: () {
          logger.d("comming soon");
          // Get.toNamed('/test');
        },
        icon: SizedBox(
          height: 32,
          width: 32,
          // child: Image.asset(
          //   AppIcon.news,
          // ),
          child: SvgPicture.asset(
            AppIcon.aiChatLinear,
            colorFilter: ColorFilter.mode(
              Colors.grey.shade700,
              BlendMode.srcIn,
            ),
          ),
        ),
        name: Align(
          alignment: Alignment.center,
          child: Text(
            'CK-AI Chat',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11,
              height: 1.2,
              color: AppColors.menuTextDisabled,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      ),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocale.more.getString(context),
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.close_rounded,
                  size: 30,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 3 / 4.9,
              crossAxisSpacing: 2,
              mainAxisSpacing: 0,
            ),
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              final menu = menuList[index];
              return Column(
                children: [
                  Container(
                    // alignment: Alignment.center,
                    padding: const EdgeInsets.all(0.0),
                    child: GestureDetector(
                      onTap: menu.ontab,
                      child: Container(
                        width: 52,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            AppTheme.softShadow,
                          ],
                        ),
                        child: Container(
                          // alignment: Alignment.center,
                          child: menu.icon,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    child: menu.name,
                  ),
                ],
              );
            },
            itemCount: menuList.length,
          ),
        ],
      ),
    );
  }
}
