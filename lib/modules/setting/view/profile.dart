import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/components/upload_image.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:lottery_ck/utils/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            width: 48,
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.backButton,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: SvgPicture.asset(AppIcon.arrowLeft),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppLocale.profile.getString(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: SizedBox.shrink()),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          AppTheme.softShadow,
                        ],
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Get.dialog(
                              //   UploadImageComponent(),
                              // );
                              controller.pickImage();
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.redGradient,
                                    AppColors.yellowGradient,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Obx(() {
                                return Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: controller.profileByte.value != null
                                      ? Image.memory(
                                          controller.profileByte.value!,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.person_2,
                                          size: 40,
                                        ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "${controller.user?.fullName}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          AppTheme.softShadow,
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocale.information.getString(context),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              controller.gotoChangeName();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: Icon(
                                        Icons.person_outline,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${controller.user?.fullName}",
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: SvgPicture.asset(AppIcon.arrowRight),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              controller.changePhoneNumber();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: SvgPicture.asset(
                                        AppIcon.phone,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${controller.user?.phoneNumber}",
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: SvgPicture.asset(AppIcon.arrowRight),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              Get.toNamed(RouteName.changeAddress);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: SvgPicture.asset(
                                          AppIcon.location,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "${controller.user?.address}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: SvgPicture.asset(AppIcon.arrowRight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          AppTheme.softShadow,
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => controller.gotoChangeBirth(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: SvgPicture.asset(
                                        AppIcon.cake,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "ວັນທີແລະເວລາເກີດ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: SvgPicture.asset(AppIcon.edit),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: SvgPicture.asset(
                                  AppIcon.calendar,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                controller.user?.birthDate != null
                                    ? CommonFn.parseDMY(
                                        controller.user!.birthDate)
                                    : "-",
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: SvgPicture.asset(
                                  AppIcon.clock,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                (controller.user?.birthTime != null &&
                                        controller.user?.birthTime != "")
                                    ? controller.user!.birthTime!
                                    : "-",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 16),
                    // Container(
                    //   padding: EdgeInsets.all(16),
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(8),
                    //     boxShadow: [
                    //       AppTheme.softShadow,
                    //     ],
                    //   ),
                    //   child: Text("แจ้งลบบัญชี"),
                    // ),
                    // LongButton(
                    //   onPressed: () {},
                    //   borderSide: BorderSide(
                    //     width: 1,
                    //     color: AppColors.errorBorder,
                    //   ),
                    //   backgroundColor: Colors.white,
                    //   child: Text(
                    //     AppLocale.reportAccountDeletion.getString(context),
                    //     style: TextStyle(
                    //       color: AppColors.errorBorder,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
