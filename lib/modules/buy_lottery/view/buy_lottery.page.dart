import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery_fullscreen.dart';
import 'package:lottery_ck/modules/lottery_history/view/lottery_history.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';

class BuyLotteryPage extends StatelessWidget {
  const BuyLotteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyLotteryController>(builder: (controller) {
      return DefaultTabController(
        length: 2,
        initialIndex: controller.parentTab,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            // bottom: PreferredSize(preferredSize: Size(0, 0), child: Container()),
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            toolbarHeight: 48,
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              tabs: [
                Tab(
                  child: Text(
                    AppLocale.buyLottery.getString(context),
                  ),
                ),
                Tab(
                  child: Text(AppLocale.lotteryResult.getString(context)),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              BuyLotteryFullscreenPage(),
              LotteryHistoryPage(),
            ],
          ),
        ),
      );
    });
  }
}
