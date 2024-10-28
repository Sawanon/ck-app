import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';

class RandomPage extends StatefulWidget {
  const RandomPage({super.key});

  @override
  State<RandomPage> createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage> {
  bool isOpen = false;
  bool isChangeToLottery = false;
  String? randomLottery;

  String generateThreeDigitRandomNumber() {
    int randomNumber = Random().nextInt(1000);
    return randomNumber.toString().padLeft(3, '0');
  }

  void openCard() async {
    setState(() {
      final luckyNumberResult = generateThreeDigitRandomNumber();
      randomLottery = luckyNumberResult;
      StorageController.to.setLuckyNumber(luckyNumberResult, DateTime.now());
      logger.d(randomLottery);
      isOpen = true;
    });
    await Future.delayed(
      const Duration(milliseconds: 500),
      () {
        setState(() {
          isChangeToLottery = true;
        });
      },
    );
  }

  void buyLottery() async {
    logger.d("dfsdfs");
    if (randomLottery == null) return;
    Get.back();
    LayoutController.to.changeTab(TabApp.lottery);
    await Future.delayed(const Duration(microseconds: 260), () {
      BuyLotteryController.to.buyLotteryByRandom(randomLottery!);
    });
  }

  void setup() async {
    final luckyNumberStore = await StorageController.to.getRandomLottery();
    logger.d(luckyNumberStore);
    if (luckyNumberStore != null) {
      final randomDate = DateTime.parse(luckyNumberStore['randomDate']);
      if (DateTime.now().day > randomDate.day) {
        return;
      }
      setState(() {
        randomLottery = luckyNumberStore['luckyNumber'];
        isOpen = true;
      });
      await Future.delayed(
        const Duration(milliseconds: 500),
        () {
          setState(() {
            isChangeToLottery = true;
          });
        },
      );
    }
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/random/wallpaper-small.png",
            fit: BoxFit.fitHeight,
          ),
          SafeArea(
            // top: false,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 0),
                  color: Colors.white,
                  child: Header(
                      title: AppLocale.lotteryPredict.getString(context)),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          AppLocale.randomTitle.getString(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Image.asset(
                                "assets/random/${isChangeToLottery ? "${randomLottery?[0] ?? "0"}.jpg" : "card_empty.png"}",
                              ),
                            )
                                .animate(
                                  target: isOpen ? 1 : 0,
                                )
                                .flip(
                                  begin: 1,
                                  end: 0,
                                  duration: const Duration(seconds: 1),
                                  direction: Axis.horizontal,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Image.asset(
                                "assets/random/${isChangeToLottery ? "${randomLottery?[1] ?? "0"}.jpg" : "card_empty.png"}",
                              ),
                            )
                                .animate(
                                  target: isOpen ? 1 : 0,
                                )
                                .flip(
                                  begin: 1,
                                  end: 0,
                                  duration: const Duration(seconds: 1),
                                  direction: Axis.horizontal,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Image.asset(
                                "assets/random/${isChangeToLottery ? "${randomLottery?[2] ?? "0"}.jpg" : "card_empty.png"}",
                              ),
                            )
                                .animate(
                                  target: isOpen ? 1 : 0,
                                )
                                .flip(
                                  begin: 1,
                                  end: 0,
                                  duration: const Duration(seconds: 1),
                                  direction: Axis.horizontal,
                                ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: randomLottery != null
                            ? LongButton(
                                onPressed: () {
                                  buyLottery();
                                },
                                child: Text(
                                  AppLocale.buy.getString(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: LongButton(
                                  disabled: randomLottery != null,
                                  onPressed: () {
                                    openCard();
                                  },
                                  child: Text(
                                    AppLocale.open.getString(context),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
