import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/notification/controller/notification.controller.dart';
import 'package:lottery_ck/modules/notification/view/news_list_component.dart';
import 'package:lottery_ck/modules/notification/view/notification_list.dart';
import 'package:lottery_ck/modules/notification/view/promotion_list_component.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        return DefaultTabController(
          length: 3,
          initialIndex: controller.currentTab,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              // bottom: PreferredSize(preferredSize: Size(0, 0), child: Container()),
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              toolbarHeight: 42,
              title: TabBar(
                unselectedLabelColor: Colors.grey,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const BoxDecoration(
                  color: AppColors.primary,
                  // border: Border(
                  //   left: BorderSide(
                  //     width: 1,
                  //     color: Colors.grey,
                  //   ),
                  //   right: BorderSide(
                  //     width: 1,
                  //     color: Colors.grey,
                  //   ),
                  // ),
                ),
                tabs: [
                  Tab(
                    child: Text(
                      AppLocale.promotion.getString(context),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocale.news.getString(context),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocale.notification.getString(context),
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                PromotionListComponent(),
                NewsListComponent(),
                NotificationList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
