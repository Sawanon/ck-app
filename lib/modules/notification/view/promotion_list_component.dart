import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class PromotionListComponent extends StatelessWidget {
  const PromotionListComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.listPromotions();
            },
            child: Obx(() {
              if (controller.promotionList.isEmpty) {
                return ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: SvgPicture.asset(
                              AppIcon.promotion,
                              colorFilter: const ColorFilter.mode(
                                AppColors.disableText,
                                BlendMode.srcIn,
                              ),
                            ),
                            // child: SvgPicture.asset(
                            //   AppIcon.promotion,
                            //   colorFilter: const ColorFilter.mode(
                            //     AppColors.disableText,
                            //     BlendMode.srcIn,
                            //   ),
                            // ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocale.noPromotion.getString(context),
                            style: const TextStyle(
                              color: AppColors.disableText,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemBuilder: (context, index) {
                  final promotions = controller.promotionList[index];
                  final isNeedKYC = promotions['is_need_kyc'];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          if (promotions['promotionType'] == "points") {
                            controller
                                .openPromotionPointsDetail(promotions['\$id']);
                          } else {
                            controller.openPromotionDetail(
                                controller.promotionList[index]["\$id"]);
                          }
                        },
                        child: Container(
                          // margin: EdgeInsets.all(8),
                          padding: EdgeInsets.only(
                            top: index == 0 ? 36 : 12,
                            bottom: 12,
                            left: 8,
                            right: 8,
                          ),
                          // width: MediaQuery.of(context).size.width * 0.2,
                          width: 120,
                          child: Row(
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.secondaryColor,
                                      AppColors.primary,
                                    ],
                                  ),
                                ),
                                child: SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: SvgPicture.asset(
                                    AppIcon.promotionBold,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        // '${notifications[index]['header']}',
                                        controller.promotionList[index]["name"],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        // '${notifications[index]['content']}',
                                        controller.promotionList[index]
                                                ["detail"] ??
                                            "-",
                                        maxLines: 2,
                                      ),
                                      if (isNeedKYC) ...[
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            border: Border.all(
                                              width: 1,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          child: Text(
                                            AppLocale
                                                .identityVerificationRequired
                                                .getString(context),
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      Builder(builder: (context) {
                                        final String? endDate =
                                            promotions['end_date'];
                                        if (endDate == null) {
                                          return const SizedBox.shrink();
                                        }
                                        final endDateTime =
                                            DateTime.parse(endDate);
                                        return Text(
                                          "${AppLocale.expiresOn.getString(context)} ${CommonFn.parseDMY(endDateTime)}",
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 12,
                                          ),
                                        );
                                      })
                                      // Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.end,
                                      //   children: [
                                      //     Text(
                                      //       promotions['start_date'] != null
                                      //           ? CommonFn.parseDMY(
                                      //               DateTime.parse(promotions[
                                      //                   'start_date']))
                                      //           : "-",
                                      //       style: TextStyle(
                                      //         fontWeight: FontWeight.bold,
                                      //         color: Color.fromRGBO(
                                      //             0, 117, 255, 1),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8);
                },
                itemCount: controller.promotionList.length,
              );
            }),
          ),
        );
      },
    );
  }
}
