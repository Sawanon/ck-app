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
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
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
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Obx(() {
                                        return Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: controller.profileByte.value !=
                                                  null
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
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.edit,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                                  if (controller.user?.isKYC == true) ...[
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Icon(
                                      Icons.verified,
                                      color: Colors.green,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        Builder(builder: (context) {
                          if (controller.kycData == null) {
                            return Column(
                              children: [
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: () => controller.gotoKYC(),
                                  child: Container(
                                    height: 48,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.red.shade100,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red.shade900,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            AppLocale.notKYC.getString(context),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red.shade900,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Colors.red.shade900,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          final String status = controller.kycData!['status'];
                          return GestureDetector(
                            onTap: () => controller.viewKYCDetail(),
                            child: Container(
                              margin: const EdgeInsets.only(top: 16),
                              height: 48,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: status == "pending"
                                    ? Colors.amber.shade100
                                    : Colors.red.shade100,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    status == "pending"
                                        ? Icons.pending_actions_rounded
                                        : Icons.remove_circle_rounded,
                                    color: status == "pending"
                                        ? Colors.amber.shade900
                                        : Colors.red.shade900,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      status == "pending"
                                          ? AppLocale
                                              .identityVerificationIsUnderReview
                                              .getString(context)
                                          : AppLocale
                                              .yourIdentityVerificationHasBeenRejected
                                              .getString(context),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: status == "pending"
                                            ? Colors.amber.shade900
                                            : Colors.red.shade900,
                                      ),
                                    ),
                                  ),
                                  Builder(builder: (context) {
                                    if (status == "pending") {
                                      return const SizedBox.shrink();
                                    }
                                    return Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.red.shade900,
                                    );
                                  })
                                ],
                              ),
                            ),
                          );
                        }),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      child:
                                          SvgPicture.asset(AppIcon.arrowRight),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          CommonFn.hidePhoneNumber(
                                              controller.user?.phoneNumber),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            offset: const Offset(0, 1),
                                            blurRadius: 3,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        AppLocale.changePhoneNumber
                                            .getString(context),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 24,
                                    //   height: 24,
                                    //   child: SvgPicture.asset(AppIcon.arrowRight),
                                    // ),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 16),
                              // InkWell(
                              //   onTap: () {
                              //     Get.toNamed(RouteName.changeAddress);
                              //   },
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Expanded(
                              //         child: Row(
                              //           children: [
                              //             SizedBox(
                              //               width: 16,
                              //               height: 16,
                              //               child: SvgPicture.asset(
                              //                 AppIcon.location,
                              //               ),
                              //             ),
                              //             const SizedBox(width: 8),
                              //             Expanded(
                              //               child: Text(
                              //                 "${controller.user?.address}",
                              //                 maxLines: 1,
                              //                 overflow: TextOverflow.ellipsis,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       SizedBox(
                              //         width: 24,
                              //         height: 24,
                              //         child:
                              //             SvgPicture.asset(AppIcon.arrowRight),
                              //       ),
                              //     ],
                              //   ),
                              // ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          AppLocale.dateAndTimeOfBirth
                                              .getString(context),
                                          style: const TextStyle(
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
              Obx(
                () {
                  if (controller.isLoadingProfile.value) {
                    return Container(
                      color: Colors.black.withOpacity(0.85),
                      child: const Center(
                        child: SizedBox(
                          width: 52,
                          height: 52,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
