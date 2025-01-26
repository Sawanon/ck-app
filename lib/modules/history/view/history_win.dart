import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/history/controller/history_win.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:lottery_ck/utils/theme.dart';

Color checkWin(String buyNumber, String winNumber) {
  logger.d("buyNumber: $buyNumber");
  logger.d("winNumber: $winNumber");
  final cutNumber = winNumber.substring(winNumber.length - buyNumber.length);
  // print('buyNumber: $buyNumber, winNumber: $winNumber, cutNumber: $cutNumber');
  if (cutNumber == buyNumber) {
    return AppColors.winContainer;
  }
  return Colors.grey;
}

class HistoryWinPage extends StatelessWidget {
  const HistoryWinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryWinController>(
      initState: (state) {
        HistoryWinController.to.listWinInVoice();
      },
      builder: (controller) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
                      )),
                  width: 135,
                  child: DropdownButton<String>(
                    padding: const EdgeInsets.all(0),
                    isExpanded: true,
                    underline: Container(),
                    value: controller.selectedMonth,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    isDense: true,
                    items: controller.lotteryMonthList
                        .map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Container(
                          width: 135,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(left: 10),
                          decoration: const BoxDecoration(
                              // color: Colors.lime,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            e,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (e) {
                      if (e == null) return;
                      controller.changeMonth(e);
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              // height: MediaQuery.of(context).size.height,
              // decoration: BoxDecoration(color: Colors.black26),
              child: RefreshIndicator(
                onRefresh: () async {
                  logger.d("message: Refresh");
                  await controller.listWinInVoice(controller.selectedMonth);
                },
                child: Obx(() {
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 8),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          // TODO: hard code
                          // logger.d(
                          //     controller.winInvoice[index]['\$collectionId']);
                          // return;
                          final winInvoice = controller.winInvoice[index];
                          final lotteryDateStr = winInvoice['\$collectionId']
                              .toString()
                              .split("_")
                              .first;
                          logger.d(lotteryDateStr);
                          controller.openWinDetail(
                              winInvoice["\$id"], lotteryDateStr);
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              AppTheme.softShadow,
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${AppLocale.lotteryDateAt.getString(context)} ${CommonFn.parseCollectionToDate(controller.winInvoice[index]["\$collectionId"])}',
                                  )
                                ],
                              ),
                              const SizedBox(height: 12),
                              Builder(builder: (context) {
                                final winInvoice = controller.winInvoice[index];
                                // $collectionId
                                final winNumber = controller.findWinLottery(
                                  winInvoice['\$collectionId'],
                                );
                                if (winNumber == null) {
                                  return Container(
                                    child: Text("-"),
                                  );
                                }
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: winNumber.split('').map((number) {
                                    return Container(
                                      padding: EdgeInsets.all(3),
                                      width: MediaQuery.of(context).size.width /
                                              6 -
                                          8,
                                      height:
                                          MediaQuery.of(context).size.width /
                                                  6 -
                                              8,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                            borderRadius:
                                                BorderRadius.circular(100),
                                          ),
                                          child: Center(
                                            child: Text(
                                              number,
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                              Container(
                                margin: EdgeInsets.only(top: 16),
                                height: 1,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'วันที่ ${CommonFn.parseDMY(DateTime.parse(controller.winInvoice[index]["\$createdAt"]))} เวลาซื้อ ${CommonFn.parseHMS(DateTime.parse(controller.winInvoice[index]["\$createdAt"]))}'),
                                      SizedBox(height: 4),
                                      Text(
                                          'เลขที่บิลหวย: ${controller.winInvoice[index]["billId"]}'),
                                    ],
                                  ),
                                  Text(
                                    CommonFn.parseMoney(controller
                                        .winInvoice[index]["totalAmount"]),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(249, 49, 55, 1),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('เลขที่ซื้อ'),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Wrap(
                                      spacing: 8.0,
                                      runSpacing: 6.0,
                                      children: (controller.winInvoice[index]
                                              ["transactionList"] as List)
                                          .map((transaction) {
                                        return Builder(builder: (context) {
                                          logger
                                              .w(controller.winInvoice[index]);
                                          final winNumber =
                                              controller.findWinNumber(
                                                  controller.winInvoice[index]
                                                      ["transactionList"]);
                                          logger.d("winNumber: $winNumber");
                                          if (winNumber == null) {
                                            return Text("-");
                                          }
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: checkWin(
                                                transaction['lottery'],
                                                winNumber,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            width: 74,
                                            alignment: Alignment.center,
                                            child: Text(
                                              transaction['lottery'],
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          );
                                        });
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox();
                    },
                    // itemCount: winNumber.length,
                    itemCount: controller.winInvoice.length,
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}
