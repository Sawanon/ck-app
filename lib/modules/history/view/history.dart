import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/buylottery.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/history/controller/history.controller.dart';
import 'package:lottery_ck/modules/history/view/history_buy.dart';
import 'package:lottery_ck/modules/history/view/history_win.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/lottery_history/view/lottery_history.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
      initState: (state) {
        HistoryController.to.setup();
      },
      builder: (controller) {
        if (controller.loading) {
          return Center(child: CircularProgressIndicator());
        }
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              // fit: StackFit.expand,
              children: [
                Expanded(
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
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: const BoxDecoration(
                          color: AppColors.primary,
                          // borderRadius: BorderRadius.only(
                          //   topLeft: Radius.circular(24),
                          //   bottomRight: Radius.circular(24),
                          // ),
                        ),
                        tabs: [
                          Tab(
                            child: Text(
                              AppLocale.buyHistory.getString(context),
                              style: GoogleFonts.prompt(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocale.winHistory.getString(context),
                              style: GoogleFonts.prompt(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocale.lotteryResult.getString(context),
                              style: GoogleFonts.prompt(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        HistoryBuyPage(),
                        HistoryWinPage(),
                        LotteryHistoryPage(),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   color: Colors.white,
                //   padding: const EdgeInsets.only(
                //     top: 8,
                //     bottom: 44,
                //     left: 16,
                //     right: 16,
                //   ),
                //   child: BuylotteryComponent(),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
