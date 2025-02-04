import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class NewsListComponent extends StatelessWidget {
  const NewsListComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.listNews();
              // _notificationViewModel.clearNews();
              // _notificationViewModel.getNews();
            },
            child: Obx(() {
              if (controller.newsList.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.asset(
                          AppIcon.news,
                        ),
                        // child: SvgPicture.asset(
                        //   AppIcon.news,
                        //   colorFilter: const ColorFilter.mode(
                        //     AppColors.disableText,
                        //     BlendMode.srcIn,
                        //   ),
                        // ),
                      ),
                      Text(
                        AppLocale.noNews.getString(context),
                        style: TextStyle(
                          color: AppColors.disableText,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemBuilder: (context, index) {
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
                          controller
                              .openNewsDetail(controller.newsList[index].$id);
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
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(90),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      AppColors.yellowGradient,
                                      AppColors.redGradient,
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.newspaper_rounded,
                                  size: 36,
                                  color: Colors.white,
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
                                        controller.newsList[index].name,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        // '${notifications[index]['content']}',
                                        controller.newsList[index].detail ??
                                            "-",
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            // '12/05/2023',
                                            controller.newsList[index]
                                                        .startDate !=
                                                    null
                                                ? CommonFn.parseDMY(controller
                                                    .newsList[index].startDate!)
                                                : "-",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
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
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
                itemCount: controller.newsList.length,
              );
            }),
          ),
        );
      },
    );
  }
}
