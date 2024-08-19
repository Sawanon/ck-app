import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/history/controller/history.controller.dart';
import 'package:lottery_ck/modules/history/view/history_buy.dart';
import 'package:lottery_ck/modules/history/view/history_win.dart';
import 'package:lottery_ck/res/color.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(builder: (controller) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            // bottom: PreferredSize(preferredSize: Size(0, 0), child: Container()),
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            toolbarHeight: 48,
            title: const TabBar(
              unselectedLabelColor: Colors.grey,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              tabs: [
                Tab(
                  child: Text(
                    'ປະຫວັດການຊື້',
                  ),
                ),
                Tab(
                  child: Text('ປະຫວັດຖືກ'),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              HistoryBuyPage(),
              HistoryWinPage(),
            ],
          ),
        ),
      );
    });
  }
}
