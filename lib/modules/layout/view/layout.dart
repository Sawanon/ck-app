import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/navigation_bar.dart';
import 'package:lottery_ck/modules/history/view/history.dart';
import 'package:lottery_ck/modules/home/view/home.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/lottery_history/view/lottery_history.dart';
import 'package:lottery_ck/modules/notification/view/notification.dart';
import 'package:lottery_ck/modules/setting/view/setting.dart';
import 'package:lottery_ck/res/color.dart';

class LayoutPage extends StatelessWidget {
  LayoutPage({super.key});
  final pages = [
    HomePage(),
    HistoryPage(),
    LotteryHistoryPage(),
    NotificationPage(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LayoutController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                padding: EdgeInsets.only(bottom: controller.bottomPadding),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: pages[controller.tabIndex],
                // child: Text('${controller.tabIndex}'),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomNavigationBar(
                  menuIndex: controller.tabIndex,
                  onChangeTab: controller.onChangeTabIndex,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
