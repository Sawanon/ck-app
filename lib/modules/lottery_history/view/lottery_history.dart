import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/main.dart';
import 'package:lottery_ck/modules/lottery_history/controller/lottery_history.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/theme.dart';

class LotteryHistoryPage extends StatelessWidget {
  const LotteryHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LotteryHistoryController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              controller.listLotteryHistory();
            },
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.lotteryHistoryList.isEmpty) {
                return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(8),
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  6,
                                  (index) {
                                    return Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width /
                                              6 -
                                          8,
                                      height:
                                          MediaQuery.of(context).size.width /
                                                  6 -
                                              8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2, color: Colors.grey),
                                      ),
                                      child: Text(
                                        "1",
                                        style: TextStyle(fontSize: 32),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                // padding: EdgeInsets.only(top: 16),
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white.withOpacity(0.9),
                                      Colors.white.withOpacity(0.9),
                                      Colors.white,
                                    ],
                                  ),
                                ),
                                child: Text(
                                  "ບໍ່ພົບປະຫວັດການຫວຍ",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return ListView.separated(
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            'งวดวันที่ ${controller.lotteryHistoryList[index]["lotteryDate"]}'),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: (controller.lotteryHistoryList[index]
                                  ["lottery"] as String)
                              .split('')
                              .map((e) {
                            return GestureDetector(
                              onTap: () {
                                controller.listLotteryHistory();
                              },
                              child: Container(
                                padding: EdgeInsets.all(3),
                                width:
                                    MediaQuery.of(context).size.width / 6 - 8,
                                height:
                                    MediaQuery.of(context).size.width / 6 - 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.yellowGradient,
                                      AppColors.redGradient,
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: double.maxFinite,
                                    height: double.maxFinite,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Text(
                                        e,
                                        style: TextStyle(fontSize: 32),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: controller.lotteryHistoryList.length,
                separatorBuilder: (context, index) {
                  return SizedBox();
                },
              );
            }),
          ),
        ),
      );
    });
  }
}
