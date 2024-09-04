import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/history.dart';
import 'package:lottery_ck/modules/history/controller/history_buy.controller.dart';
import 'package:lottery_ck/modules/history/view/lotterynumber.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HistoryBuyPage extends StatelessWidget {
  const HistoryBuyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryBuyController>(
      initState: (state) {
        HistoryBuyController.to.visitPage();
      },
      builder: (controller) {
        return Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                width: 135,
                child: DropdownButton(
                  padding: const EdgeInsets.all(0),
                  isExpanded: true,
                  underline: Container(),
                  value: controller.selectedLotteryDate,
                  borderRadius: BorderRadius.circular(20),
                  isDense: true,
                  items: controller.lotteryDateList.map(
                    (lotteryDate) {
                      return DropdownMenuItem(
                        value: lotteryDate.dateTime,
                        child: Container(
                          width: 135,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(left: 10),
                          decoration: const BoxDecoration(
                              // color: Colors.lime,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            CommonFn.parseDMY(lotteryDate.dateTime),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    controller.onChangeLotteryDate(value);
                  },
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: AppColors.primary,
                color: Colors.white,
                onRefresh: controller.refreshHistory,
                child: Obx(() {
                  return Skeletonizer(
                    enabled: controller.loadingHistoryList.value,
                    child: ListView(
                      // physics: RangeMaintainingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 8),
                      // clipBehavior: Clip.none,
                      // shrinkWrap: true,
                      children: (controller.loadingHistoryList.value
                              ? [History.empty, History.empty, History.empty]
                              : controller.historyList)
                          .map(
                        (history) {
                          // TODO:
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 8, right: 8, top: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 15,
                                  offset: const Offset(4, 4),
                                )
                              ],
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              shadowColor: Colors.grey.withOpacity(0.5),
                              color: Colors.white,
                              child: InkWell(
                                overlayColor: WidgetStateProperty.all<Color>(
                                    Colors.grey.shade400),
                                onTap: () =>
                                    controller.makeBillDialog(context, history),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'ວັນທີ ${history.date}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'ເວລາຂອງການຊື້ ${history.time}',
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'ລະຫັດໃບເກັບເງິນຫວຍ: ${history.invoiceId}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            CommonFn.parseMoney(
                                                history.totalAmount),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  249, 49, 55, 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'ເລກທີ່ເຈົ້າຊື້',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Skeletonizer(
                                                    enabled: controller
                                                        .loadingTransactionId
                                                        .value,
                                                    child: Wrap(
                                                      spacing: 8.0,
                                                      runSpacing: 6.0,
                                                      children: (controller
                                                                  .loadingTransactionId
                                                                  .value
                                                              ? [
                                                                  '00',
                                                                  '00',
                                                                  '00',
                                                                ]
                                                              : history
                                                                  .lotteryList)
                                                          .map((lottery) {
                                                        return Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8),
                                                          alignment:
                                                              Alignment.center,
                                                          width: 74,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.15),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          child: Text(
                                                            '$lottery',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
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
