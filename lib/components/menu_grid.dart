import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottery_ck/components/dialog_kyc_pending.dart';
import 'package:lottery_ck/components/more_menu.dart';
import 'package:lottery_ck/components/user_qr.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/model/menu.dart';
import 'package:lottery_ck/modules/guess/view/guess_page.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/wheel/wheel_page.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/theme.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        final List<MenuModel> menuList = [
          // 1
          MenuModel(
            ontab: () {
              if (UserController.to.user.value == null) {
                LayoutController.to.showDialogLogin();
                return;
              }
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return const UserQR();
                },
              );
            },
            icon: SizedBox(
              height: 42,
              width: 42,
              child: SvgPicture.asset(
                MenuIcon.inviteFriend3,
                // colorFilter: const ColorFilter.mode(
                //   AppColors.secondaryColor,
                //   BlendMode.srcIn,
                // ),
              ),
            ),
            name: Align(
              alignment: Alignment.center,
              child: Text(
                AppLocale.shareAppToYourFriend.getString(context),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  height: 1,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
          // 2
          MenuModel(
            ontab: () {
              // Get.toNamed(RouteName.scanQR);
              Get.toNamed(RouteName.horoscopeDaily);
            },
            icon: SizedBox(
              height: 42,
              width: 42,
              child: SvgPicture.asset(
                MenuIcon.dialyHoroscope2,
                // colorFilter: const ColorFilter.mode(
                //   AppColors.secondaryColor,
                //   BlendMode.srcIn,
                // ),
              ),
            ),
            name: Align(
              alignment: Alignment.center,
              child: Text(
                AppLocale.dailyFortune.getString(context),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  height: 1,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
          // 3
          MenuModel(
            disabled: true,
            ontab: () {
              if (UserController.to.user.value == null) {
                LayoutController.to.showDialogLogin();
                return;
              }
              Get.to(() => const WheelPage());
            },
            icon: SizedBox(
              height: 38,
              width: 38,
              child: SvgPicture.asset(
                MenuIcon.wheelFortune,
                // colorFilter: ColorFilter.mode(
                //   Colors.blue,
                //   BlendMode.srcOut,
                // ),
              ),
              // child: Image.asset("assets/png/menu-icon-wheel.png"),
            ),
            name: Container(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  AppLocale.wheelOfFortune.getString(context),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    height: 1,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            ),
          ),
          // 4
          // 5
          MenuModel(
            disabled: true,
            ontab: () {
              // LayoutController.to.changeTab(TabApp.settings);
              // NotificationController.to.onChangeTab(0);
              // Get.to(() => const GuessPage());
            },
            icon: Container(
              // color: Colors.blue,
              height: 42,
              width: 42,
              // child: Icon(
              //   Icons.image_aspect_ratio_rounded,
              //   color: AppColors.secondaryColor,
              // ),
              child: SvgPicture.asset(
                MenuIcon.lottery,
                colorFilter: ColorFilter.mode(
                  AppColors.menuIconDisabled,
                  BlendMode.srcIn,
                ),
                // colorFilter: const ColorFilter.mode(
                //   AppColors.redGradient,
                //   BlendMode.srcIn,
                // ),
              ),
            ),
            name: Align(
              alignment: Alignment.center,
              child: Text(
                "ທາຍຫວຍ",
                style: TextStyle(
                  color: AppColors.menuTextDisabled,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  height: 1,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
          // 6
          MenuModel(
            disabled: true,
            ontab: () async {
              LayoutController.to.changeTab(TabApp.settings);
              NotificationController.to.onChangeTab(1);
            },
            icon: SizedBox(
              height: 40,
              width: 40,
              child: SvgPicture.asset(
                MenuIcon.news2,
                // colorFilter: const ColorFilter.mode(
                //   AppColors.secondaryColor,
                //   BlendMode.srcIn,
                // ),
              ),
              // child: SvgPicture.asset(
              //   AppIcon.news,
              //   colorFilter: const ColorFilter.mode(
              //     AppColors.primary,
              //     BlendMode.srcIn,
              //   ),
              // ),
            ),
            name: Align(
              alignment: Alignment.center,
              child: Text(
                AppLocale.news.getString(context),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
          // 7
          // MenuModel(
          //   disabled: true,
          //   ontab: () {
          //     LayoutController.to.changeTab(TabApp.settings);
          //     NotificationController.to.onChangeTab(0);
          //   },
          //   icon: SizedBox(
          //     height: 40,
          //     width: 40,
          //     child: SvgPicture.asset(
          //       MenuIcon.promotion2,
          //       // colorFilter: const ColorFilter.mode(
          //       //   AppColors.secondaryColor,
          //       //   BlendMode.srcIn,
          //       // ),
          //     ),
          //     // child: SvgPicture.asset(
          //     //   AppIcon.promotion,
          //     //   colorFilter: const ColorFilter.mode(
          //     //     AppColors.redGradient,
          //     //     BlendMode.srcIn,
          //     //   ),
          //     // ),
          //   ),
          //   name: Align(
          //     alignment: Alignment.center,
          //     child: Text(
          //       AppLocale.promotion.getString(context),
          //       style: TextStyle(
          //         color: AppColors.textPrimary,
          //         fontWeight: FontWeight.w600,
          //         fontSize: 11,
          //         height: 1.2,
          //       ),
          //       textAlign: TextAlign.center,
          //       softWrap: true,
          //     ),
          //   ),
          // ),
          // 8
          MenuModel(
            ontab: () {
              controller.gotoTopupPoint();
            },
            icon: SizedBox(
              height: 38,
              width: 38,
              child: SvgPicture.asset(
                MenuIcon.topup2,
                // AppIcon.buyPoint,
                // colorFilter: const ColorFilter.mode(
                //   AppColors.secondaryColor,
                //   BlendMode.srcIn,
                // ),
              ),
            ),
            name: Align(
              alignment: Alignment.center,
              child: Text(
                AppLocale.topupPoints.getString(context),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
          // 9
          MenuModel(
            disabled: true,
            ontab: () {
              final user = UserController.to.user.value;
              if (user == null) {
                LayoutController.to.showDialogLogin();
                return;
              }
              if (SettingController.to.kycData != null) {
                Get.dialog(
                  DialogKycPending(),
                );
                return;
              }
              Get.toNamed(RouteName.kyc);
            },
            icon: SizedBox(
              height: 37,
              width: 37,
              child: SvgPicture.asset(
                MenuIcon.kyc2,
                // colorFilter: const ColorFilter.mode(
                //   AppColors.secondaryColor,
                //   BlendMode.srcIn,
                // ),
              ),
              // child: SvgPicture.asset(
              //   AppIcon.registerAndVerify,
              //   colorFilter: const ColorFilter.mode(
              //     AppColors.redGradient,
              //     BlendMode.srcIn,
              //   ),
              // ),
            ),
            name: Align(
              alignment: Alignment.center,
              child: Text(
                AppLocale.verifyIdentity.getString(context),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
          // MenuModel(
          //   disabled: true,
          //   ontab: () {
          //     logger.d("comming soon");
          //     // Get.toNamed('/test');
          //   },
          //   icon: SizedBox(
          //     height: 32,
          //     width: 32,
          //     // child: Image.asset(
          //     //   AppIcon.news,
          //     // ),
          //     child: SvgPicture.asset(
          //       AppIcon.aiChat,
          //       colorFilter: ColorFilter.mode(
          //         Colors.grey.shade700,
          //         BlendMode.srcIn,
          //       ),
          //     ),
          //   ),
          //   name: Align(
          //     alignment: Alignment.center,
          //     child: Text(
          //       'CK-AI Chat',
          //       style: TextStyle(
          //         fontWeight: FontWeight.w600,
          //         fontSize: 11,
          //         height: 1.2,
          //         color: AppColors.menuTextDisabled,
          //       ),
          //       textAlign: TextAlign.center,
          //       softWrap: true,
          //     ),
          //   ),
          // ),
          // 10
          MenuModel(
            // disabled: true,
            ontab: () {
              logger.d("comming soon");
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return const MoreMenu();
                },
              );
            },
            icon: SizedBox(
              height: 40,
              width: 40,
              child: SvgPicture.asset(
                MenuIcon.more3,
                // colorFilter: const ColorFilter.mode(
                //   AppColors.secondaryColor,
                //   BlendMode.srcIn,
                // ),
              ),
            ),
            name: Align(
              alignment: Alignment.center,
              child: Text(
                AppLocale.more.getString(context),
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
        ];
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 3 / 3,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          padding: const EdgeInsets.all(0),
          itemBuilder: (context, index) {
            final menu = menuList[index];
            return Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  // alignment: Alignment.center,
                  padding: const EdgeInsets.all(0.0),
                  child: GestureDetector(
                    onTap: menu.ontab,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        width: 100,
                        // height: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            AppTheme.softShadow,
                          ],
                        ),
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // alignment: Alignment.center,
                              child: menu.icon,
                            ),
                            const SizedBox(height: 4),
                            Align(
                              child: menu.name,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 4),
                // Align(
                //   child: menu.name,
                // ),
              ],
            );
          },
          itemCount: menuList.length,
        );
      },
    );
  }
}
