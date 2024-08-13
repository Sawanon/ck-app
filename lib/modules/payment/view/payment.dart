import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';

class PayMentPage extends StatelessWidget {
  const PayMentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Header(
                onTap: () {
                  navigator?.pop();
                },
              ),
              ElevatedButton(
                onPressed: () {
                  controller.getBank();
                },
                child: Text("getbank"),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Column(
                      // shrinkWrap: true,
                      // physics: const BouncingScrollPhysics(),
                      children: controller.lotteryList.map(
                        (data) {
                          return Text(data.lottery);
                        },
                      ).toList(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        // shrinkWrap: true,
                        children: controller.bankList.map(
                          (bank) {
                            return GestureDetector(
                              onTap: () {
                                controller.payLottery(bank);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Image.network(
                                      bank.logo ?? '',
                                      width: 36,
                                      height: 36,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                          width: 36,
                                          height: 36,
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Text(bank.name),
                                  ],
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
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
