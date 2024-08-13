import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';

class BuyLotteryPage extends StatelessWidget {
  const BuyLotteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyLotteryController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.amber,
            child: Text('data: ${controller.isUserLoggedIn}'),
          ),
        ),
      );
    });
  }
}
