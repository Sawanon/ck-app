import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/utils.dart';
import 'package:pinput/pinput.dart';

class RandomController extends GetxController {
  RxInt digit = 2.obs;

  int? digit1;
  int? digit2;
  int? digit3;
  int? digit4;
  int? digit5;
  int? digit6;
  FocusNode focus1 = FocusNode();
  FocusNode focus2 = FocusNode();
  FocusNode focus3 = FocusNode();
  FocusNode focus4 = FocusNode();
  FocusNode focus5 = FocusNode();
  FocusNode focus6 = FocusNode();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();

  int? numberLottery;
  int? price;

  bool get disabledConfirm => numberLottery == null || price == null;

  void onChangeDigit(int value) {
    digit.value = value;
    if (value <= 2) {
      controller1.setText("");
      controller2.setText("");
      controller3.setText("");
      controller4.setText("");
      digit1 = null;
      digit2 = null;
      digit3 = null;
      digit4 = null;
    } else if (value <= 3) {
      controller1.setText("");
      controller2.setText("");
      controller3.setText("");
      digit1 = null;
      digit2 = null;
      digit3 = null;
    } else if (value <= 4) {
      controller1.setText("");
      controller2.setText("");
      digit1 = null;
      digit2 = null;
    } else if (value <= 5) {
      controller1.setText("");
      digit1 = null;
    }
  }

  bool isNumber(String value) {
    try {
      int.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  void onChangeDigitValue(String value, int digit) {
    try {
      final intValue = isNumber(value) ? int.parse(value) : null;
      switch (digit) {
        case 1:
          digit1 = intValue;
          break;
        case 2:
          digit2 = intValue;
          break;
        case 3:
          digit3 = intValue;
          break;
        case 4:
          digit4 = intValue;
          break;
        case 5:
          digit5 = intValue;
          break;
        case 6:
          digit6 = intValue;
          break;
        default:
          break;
      }
    } catch (e) {
      logger.e(e);
    }
  }

  void onChangeNumberLottery(String value) {
    try {
      numberLottery = isNumber(value) ? int.parse(value) : null;
      update();
    } catch (e) {
      logger.e(e);
    }
  }

  void onChangePrice(String value) {
    try {
      price = isNumber(value) ? int.parse(value) : null;
      update();
    } catch (e) {
      logger.e(e);
    }
  }

  String generateLottery(
    int digit, {
    required int? digit1,
    required int? digit2,
    required int? digit3,
    required int? digit4,
    required int? digit5,
    required int? digit6,
  }) {
    final powValue = pow(10, digit);
    // logger.d(powValue);
    int randomNumber = Random().nextInt(powValue.toInt());
    String result = randomNumber.toString().padLeft(digit, '0');
    if (digit1 != null) {
      result = "$digit1${result.substring(1)}";
    }
    if (digit2 != null) {
      result =
          "${result.substring(0, digit - 5)}$digit2${result.substring(digit - 4)}";
    }
    if (digit3 != null) {
      result =
          "${result.substring(0, digit - 4)}$digit3${result.substring(digit - 3)}";
    }
    if (digit4 != null) {
      result =
          "${result.substring(0, digit - 3)}$digit4${result.substring(digit - 2)}";
    }
    if (digit5 != null) {
      result =
          "${result.substring(0, digit - 2)}$digit5${result.substring(digit - 1)}";
    }
    if (digit6 != null) {
      result = "${result.substring(0, digit - 1)}$digit6";
    }
    // logger.w(result);
    return result;
  }

  void submitRandom() {
    final numberLottery = this.numberLottery;
    final price = this.price;
    if (numberLottery == null) {
      return;
    }
    if (price == null) {
      return;
    }
    if (price % 1000 != 0) {
      BuyLotteryController.to.showInvalidPrice();
      return;
    }
    List<String> lotteryList = [];
    Map<String, int> lotteryMap = {};
    // logger.w(lotteryMap['111']);
    // lotteryMap['111'] = 1000;
    // logger.w(lotteryMap['111']);
    // lotteryMap['111'] = 2000;
    // logger.w(lotteryMap['111']);
    int maxRound = 100;
    int count = 0;
    // loop with number lottery
    for (var i = 0; i < numberLottery; i++) {
      // random lottery
      final randomNumber = generateLottery(
        digit.value,
        digit1: digit1,
        digit2: digit2,
        digit3: digit3,
        digit4: digit4,
        digit5: digit5,
        digit6: digit6,
      );
      lotteryList.add(randomNumber);
      // already this lottery number
      if (lotteryMap[randomNumber] != null) {
        logger.w("repeat !! $randomNumber");
        // Repeat until it doesn't repeat
        while (true) {
          final randomNumber = generateLottery(
            digit.value,
            digit1: digit1,
            digit2: digit2,
            digit3: digit3,
            digit4: digit4,
            digit5: digit5,
            digit6: digit6,
          );
          // doesn't repeat stop
          if (lotteryMap[randomNumber] == null) {
            lotteryMap[randomNumber] = price;
            break;
          }
          count++;
          // max round for toomany rounds
          if (count >= maxRound) {
            logger.w("max round !");
            break;
          }
        }
      } else {
        lotteryMap[randomNumber] = price;
      }
    }
    logger.d(lotteryList);
    logger.w(lotteryMap);
    // final lotteryListClass =
    List<Map<String, dynamic>> lotteryMapList = [];
    for (var element in lotteryMap.entries) {
      logger.w('key: ${element.key}');
      logger.w('value: ${element.value}');
      lotteryMapList.add({
        "lottery": element.key,
        "price": element.value.toString(),
      });
    }
    logger.w("data");
    logger.d(lotteryMapList);
    Get.back();
    Future.delayed(
      const Duration(milliseconds: 250),
      () {
        BuyLotteryController.to.onClickAnimalBuy(lotteryMapList);
      },
    );
  }
}
