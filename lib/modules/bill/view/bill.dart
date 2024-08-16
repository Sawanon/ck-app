import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/bill/controller/bill.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/logo.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class BillPage extends StatelessWidget {
  const BillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Header(
                onTap: () => navigator?.pop(),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // color: Colors.red.shade100,
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: AppColors.secodaryBorder,
                          ),
                        ),
                      ),
                      child: Text(
                        'ກະຊວງການເງິນ ຫວຍພັດທະນາ ຈັດຈໍາໜ່າຍໂດຍ CK GROUP',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secodaryText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Image.asset(
                      Logo.lotto,
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.width / 4,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        controller.test();
                      },
                      child: Image.asset(
                        Logo.ck,
                        height: 40,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "ຊື່ຜູ້ຊື້",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  controller.bill != null
                                      ? "${controller.bill!.firstName} ${controller.bill!.lastName}"
                                      : "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "ວັນທີ ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                Text(
                                  controller.bill != null
                                      ? CommonFn.parseDMY(
                                          controller.bill!.dateTime.toLocal())
                                      : "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "ໂທລະສັບ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  controller.bill != null
                                      ? controller.bill!.phoneNumber
                                      : "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "ວັນທີ ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondary,
                                  ),
                                ),
                                Text(
                                  controller.bill != null
                                      ? CommonFn.parseHMS(
                                          controller.bill!.dateTime.toLocal())
                                      : "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "ງວດວັນທີี่ ${controller.bill != null ? controller.bill!.lotteryDateStr : ""}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 1,
                            color: AppColors.yellowGradient,
                          ),
                          bottom: BorderSide(
                            width: 1,
                            color: AppColors.yellowGradient,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ເລກທີຊື້',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'ຈໍານວນເງິນ',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.bill != null)
                      Column(
                        children: controller.bill!.lotteryList.map(
                          (lottery) {
                            return Container(
                              margin: EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(lottery.lottery),
                                  Text(lottery.price.toString()),
                                ],
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 5,
                            color: AppColors.yellowGradient,
                          ),
                          bottom: BorderSide(
                            width: 5,
                            color: AppColors.yellowGradient,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("ລວມເງິນ"),
                          Text(
                            controller.bill != null
                                ? controller.bill!.totalAmount
                                : "",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
