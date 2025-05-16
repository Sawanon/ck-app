import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/modules/point/controller/point.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class PointPage extends StatelessWidget {
  const PointPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PointController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Header(
                title: AppLocale.point.getString(context),
              ),
              Container(
                // color: Colors.amber,
                padding: const EdgeInsets.only(top: 16),
                // margin: EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    // Point head
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: Container()),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          color: Colors.white,
                          child: ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (bounds) {
                              // Gradient gradient;
                              Gradient gradient = const LinearGradient(colors: [
                                AppColors.primary,
                                AppColors.secondaryColor,
                              ]);
                              return gradient.createShader(
                                Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height),
                              );
                              // return gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
                            },
                            child: Obx(() {
                              if (controller.isLoadingPoint.value) {
                                return const CircularProgressIndicator();
                              }
                              return Text(
                                CommonFn.parseMoney(
                                    controller.totalPoint.value),
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              );
                            }),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              AppLocale.point.getString(context),
                              style: TextStyle(
                                color: AppColors.secondary,
                                height: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // end Point head
                    const SizedBox(height: 12),
                    // start user info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.secondaryColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Builder(
                              builder: (context) {
                                // if (avatar == '') {
                                final profileImage =
                                    SettingController.to.profileByte.value;
                                if (profileImage != null) {
                                  return Image.memory(profileImage,
                                      fit: BoxFit.cover);
                                }
                                return Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: 48,
                                );
                                // } else {
                                //   return ClipRRect(
                                //     borderRadius: BorderRadius.circular(144),
                                //     child: CachedNetworkImage(
                                //       imageUrl: avatar,
                                //       progressIndicatorBuilder:
                                //           (context, url, progress) => Center(
                                //         child: CircularProgressIndicator(
                                //           value: progress.progress,
                                //         ),
                                //       ),
                                //       errorWidget: (context, url, error) =>
                                //           Icon(
                                //         Icons.error,
                                //         size: 80,
                                //       ),
                                //     ),
                                //   );
                                // }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.userApp?.firstName ?? '-',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              CommonFn.hidePhoneNumber(
                                  controller.userApp?.phoneNumber),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            // Text(
                            //   'email',
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.w600,
                            //     color: AppColors.textPrimary,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    // end user info
                    const SizedBox(height: 24),
                    // start header field
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocale.day.getString(context),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocale.pointRef.getString(context),
                          ),
                        ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.25,
                        //   alignment: Alignment.center,
                        //   child: Text(
                        //     AppLocale.quantity.getString(context),
                        //   ),
                        // ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          alignment: Alignment.center,
                          child: Text(
                            AppLocale.point.getString(context),
                          ),
                        ),
                      ],
                    )
                    // end header field
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                // color: Colors.amber,
                // height: MediaQuery.of(context).size.height * 0.8,
                child: Obx(
                  () {
                    if (controller.isLoadingPoint.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: controller.scrollController,
                      itemBuilder: (context, index) {
                        final pointTransaction =
                            controller.userPointList[index];
                        return Container(
                          color: AppColors.primary.withOpacity(0.2),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                width: MediaQuery.of(context).size.width * 0.2,
                                alignment: Alignment.center,
                                child: Text(
                                  pointTransaction.createdDateStr,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 16,
                                  bottom: 16,
                                ),
                                width: MediaQuery.of(context).size.width * 0.5,
                                alignment: Alignment.center,
                                child: Text(
                                  controller.renderType(
                                      pointTransaction.type, context),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  softWrap: false,
                                ),
                              ),
                              // Container(
                              //   padding: EdgeInsets.symmetric(vertical: 16),
                              //   width: MediaQuery.of(context).size.width * 0.25,
                              //   alignment: Alignment.center,
                              //   child: Text(pointTransaction.value ?? "-"),
                              // ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                width: MediaQuery.of(context).size.width * 0.3,
                                alignment: Alignment.center,
                                child: Text(
                                  CommonFn.parseMoney(pointTransaction.point),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 2),
                      itemCount: controller.userPointList.length,
                    );
                  },
                ),
              ),
              if (controller.loadingPoint) CircularProgressIndicator(),
            ],
          ),
        ),
      );
    });
  }
}
