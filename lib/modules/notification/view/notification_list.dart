import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    controller.listNotification();
                  },
                  child: Obx(() {
                    if (controller.notificationList.value == null ||
                        controller.notificationList.value?.data.isEmpty ==
                            true) {
                      return ListView(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 1.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                // color: Colors.red,
                                ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: SvgPicture.asset(
                                    AppIcon.notification,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.disableText,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  AppLocale.noNotification.getString(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: controller.notificationScrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      itemBuilder: (context, index) {
                        final notification =
                            controller.notificationList.value!.data[index];
                        return GestureDetector(
                          onTap: () {
                            // link
                            if (notification.link == null) {
                              return;
                            }
                            controller.onClickNotification(notification);
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 36 : 12,
                              bottom: 12,
                              left: 8,
                              right: 8,
                            ),
                            decoration: BoxDecoration(
                              color: notification.isRead
                                  ? Colors.white
                                  : AppColors.primary20,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
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
                                    child: Builder(builder: (context) {
                                      String icon = AppIcon.notification;
                                      if (notification.link
                                              ?.contains("/news") ==
                                          true) {
                                        icon = AppIcon.newsBold;
                                      } else if (notification.link
                                              ?.contains("/promotion") ==
                                          true) {
                                        icon = AppIcon.promotionBold;
                                      }
                                      return SvgPicture.asset(
                                        icon,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          notification.title,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          notification.body,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              // "${CommonFn.parseDMY(notification.createdAt)} ${CommonFn.parseHMS(notification.createdAt)}",
                                              CommonFn.renderAgo(
                                                  notification.createdAt),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.secondary,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 12);
                      },
                      itemCount:
                          controller.notificationList.value?.data.length ?? 0,
                    );
                  }),
                ),
              ),
              if (controller.notificationLoading) ...[
                CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                const SizedBox(height: 32),
              ]
            ],
          ),
        ),
      );
    });
  }
}
