import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/components/rating.dart';
import 'package:lottery_ck/components/traslate.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/t_c/view/t_c.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      builder: (controller) {
        if (controller.loading) {
          return Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                // top: 16.0,
                left: 16,
                right: 16,
                bottom: 16 + 8,
              ),
              child: Column(
                children: [
                  Header(
                    title: AppLocale.setting.getString(context),
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.setup();
                      },
                      child: ListView(
                        // physics: const BouncingScrollPhysics(),
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (controller.user == null) {
                                LayoutController.to.showDialogLogin();
                                return;
                              }
                              Get.toNamed(RouteName.profile);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.secondaryColor,
                                    AppColors.primary,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Obx(() {
                                      return Container(
                                          height: 80,
                                          width: 80,
                                          padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                AppColors.secondaryColor,
                                                AppColors.primary,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                          ),
                                          child: Container(
                                            clipBehavior: Clip.hardEdge,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child:
                                                controller.profileByte.value !=
                                                        null
                                                    ? Image.memory(
                                                        controller
                                                            .profileByte.value!,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : const Icon(
                                                        Icons.person_2,
                                                        size: 40,
                                                      ),
                                          ));
                                    }),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child: Icon(
                                                  Icons.person_outline,
                                                  size: 18,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(controller.user?.fullName ??
                                                  "-"),
                                              if (controller.user?.isKYC ==
                                                  true) ...[
                                                const SizedBox(width: 4),
                                                const Icon(
                                                  Icons.verified,
                                                  color: Colors.green,
                                                ),
                                              ]
                                            ],
                                          ),
                                          const SizedBox(height: 4),
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
                                              Text(CommonFn.hidePhoneNumber(
                                                  controller
                                                      .user?.phoneNumber)),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 2,
                                                  horizontal: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      controller.user?.isKYC ==
                                                              true
                                                          ? Colors.green
                                                          : Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  controller.user?.isKYC == true
                                                      ? AppLocale.verified
                                                          .getString(context)
                                                      : AppLocale.notVerified
                                                          .getString(context),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Row(
                                          //   children: [
                                          //     SizedBox(
                                          //       width: 16,
                                          //       height: 16,
                                          //       child: SvgPicture.asset(
                                          //         AppIcon.location,
                                          //       ),
                                          //     ),
                                          //     const SizedBox(width: 8),
                                          //     Text(controller.user?.address ??
                                          //         "-"),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Builder(builder: (context) {
                            if (controller.kycData == null) {
                              return const SizedBox.shrink();
                            }
                            final String status = controller.kycData!['status'];
                            return GestureDetector(
                              onTap: () => controller.viewKYCDetail(),
                              child: Container(
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
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return TranslateComponent();
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.secondaryColor,
                                              AppColors.primary,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: SvgPicture.asset(
                                              AppIcon.translate,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                AppColors.primary,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        AppLocale.translate.getString(context),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: SvgPicture.asset(AppIcon.arrowRight),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              if (controller.user == null) {
                                LayoutController.to.showDialogLogin();
                                return;
                              }
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return RatingComponent(
                                    onSubmit: controller.submitRating,
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.secondaryColor,
                                              AppColors.primary,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: SvgPicture.asset(
                                              AppIcon.feedback,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                AppColors.primary,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        AppLocale.feedback.getString(context),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: SvgPicture.asset(AppIcon.arrowRight),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // GestureDetector(
                          //   onTap: () {
                          //     controller.onShare(context);
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.all(8),
                          //     decoration: BoxDecoration(
                          //       color: AppColors.primary.withOpacity(0.2),
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Row(
                          //           children: [
                          //             Container(
                          //               padding: EdgeInsets.all(2),
                          //               decoration: BoxDecoration(
                          //                 shape: BoxShape.circle,
                          //                 gradient: LinearGradient(
                          //                   colors: [
                          //                     AppColors.secondaryColor,
                          //                     AppColors.primary,
                          //                   ],
                          //                   begin: Alignment.topLeft,
                          //                   end: Alignment.bottomRight,
                          //                 ),
                          //               ),
                          //               child: Container(
                          //                 width: 48,
                          //                 height: 48,
                          //                 alignment: Alignment.center,
                          //                 decoration: BoxDecoration(
                          //                   shape: BoxShape.circle,
                          //                   color: Colors.white,
                          //                 ),
                          //                 child: SizedBox(
                          //                   width: 24,
                          //                   height: 24,
                          //                   child: SvgPicture.asset(
                          //                     AppIcon.shareFriend,
                          //                     colorFilter:
                          //                         const ColorFilter.mode(
                          //                       AppColors.primary,
                          //                       BlendMode.srcIn,
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //             const SizedBox(width: 16),
                          //             Text(
                          //               AppLocale.shareAppToYourFriend
                          //                   .getString(context),
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         SizedBox(
                          //           height: 24,
                          //           width: 24,
                          //           child: SvgPicture.asset(AppIcon.arrowRight),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 4),
                          // GestureDetector(
                          //   onTap: () {
                          //     Get.toNamed(RouteName.point);
                          //   },
                          //   child: Container(
                          //     padding: EdgeInsets.all(8),
                          //     decoration: BoxDecoration(
                          //       color: AppColors.primary.withOpacity(0.2),
                          //       borderRadius: BorderRadius.circular(8),
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         Row(
                          //           children: [
                          //             Container(
                          //               padding: EdgeInsets.all(2),
                          //               decoration: BoxDecoration(
                          //                 shape: BoxShape.circle,
                          //                 gradient: LinearGradient(
                          //                   colors: [
                          //                     AppColors.secondaryColor,
                          //                     AppColors.primary,
                          //                   ],
                          //                   begin: Alignment.topLeft,
                          //                   end: Alignment.bottomRight,
                          //                 ),
                          //               ),
                          //               child: Container(
                          //                 width: 48,
                          //                 height: 48,
                          //                 alignment: Alignment.center,
                          //                 decoration: BoxDecoration(
                          //                   shape: BoxShape.circle,
                          //                   color: Colors.white,
                          //                 ),
                          //                 child: SizedBox(
                          //                   width: 24,
                          //                   height: 24,
                          //                   child: SvgPicture.asset(
                          //                     AppIcon.point,
                          //                     colorFilter:
                          //                         const ColorFilter.mode(
                          //                       AppColors.primary,
                          //                       BlendMode.srcIn,
                          //                     ),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //             const SizedBox(width: 16),
                          //             Text(
                          //               AppLocale.myScore.getString(context),
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.w600,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         SizedBox(
                          //           width: 24,
                          //           height: 24,
                          //           child: SvgPicture.asset(AppIcon.arrowRight),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              if (controller.user == null) {
                                LayoutController.to.showDialogLogin();
                                return;
                              }
                              // request scan face
                              Get.toNamed(RouteName.security);
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.secondaryColor,
                                              AppColors.primary,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: SvgPicture.asset(
                                              AppIcon.lock,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                AppColors.primary,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        AppLocale.security.getString(context),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
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
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                () => TCPage(
                                  enabledAcceptBtn: false,
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.secondaryColor,
                                              AppColors.primary,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: SvgPicture.asset(
                                              AppIcon.achiveBook,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                AppColors.primary,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        AppLocale.servicePolicy
                                            .getString(context),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (controller.user == null)
                    LongButton(
                      onPressed: () {
                        Get.toNamed(RouteName.login);
                      },
                      child: Text(
                        AppLocale.login.getString(context),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  else
                    LongButton(
                      onPressed: () {
                        Get.dialog(
                          DialogApp(
                            title: Text(
                              AppLocale.areYouSureYouWantToLogout
                                  .getString(context),
                            ),
                            onConfirm: () async {
                              await controller.logout();
                              Get.back();
                              Get.back();
                            },
                            confirmText: Text(
                              AppLocale.logout.getString(Get.context!),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            // onCancel: () => Get.back(),
                            cancelText: Text(
                              AppLocale.cancel.getString(Get.context!),
                              style: const TextStyle(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        AppLocale.logout.getString(context),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
