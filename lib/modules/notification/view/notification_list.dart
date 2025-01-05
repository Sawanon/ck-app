import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              logger.d("onRefresh");
            },
            child: Obx(() {
              if (controller.notificationList.isEmpty) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      // color: Colors.red,
                      ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: SvgPicture.asset(
                          AppIcon.notification,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        "No Notification",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                      top: index == 0 ? 36 : 12,
                      bottom: 12,
                      left: 8,
                      right: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                    child: Text(
                      "data",
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 12);
                },
                itemCount: controller.notificationList.length,
              );
            }),
          ),
        ),
      );
    });
  }
}
