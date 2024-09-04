import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class HistoryWinController extends GetxController {
  static HistoryWinController get to => Get.find();
  String lotteryMonth = "09-2024";
  RxList winInvoice = [].obs;

  Future<void> listWinInVoice([String? lotteryMonth]) async {
    winInvoice.clear();
    final lotteryMonthRevers =
        (lotteryMonth ?? this.lotteryMonth).split("-").reversed.join("");
    logger.d(lotteryMonthRevers);
    final listInvoiceCollection =
        await AppWriteController.to.listLotteryCollection(lotteryMonthRevers);
    if (listInvoiceCollection == null) {
      return;
    }
    logger.d(listInvoiceCollection);
    for (var invoiceCollection in listInvoiceCollection) {
      if (invoiceCollection is String) {
        final winInvoice =
            await AppWriteController.to.listWinInvoices(invoiceCollection);
        logger.w(winInvoice);
        if (winInvoice == null) continue;

        this.winInvoice.value = [...this.winInvoice, ...winInvoice];
      }
    }
  }

  String? findWinNumber(List transactionList) {
    final winLottery = transactionList.where(
      (transaction) {
        if (transaction["lotteryHistory"] != null) {
          return true;
        }
        return false;
      },
    ).toList();
    if (winLottery.isEmpty) return null;
    return winLottery.first["lotteryHistory"]['lottery'].first as String;
  }

  void openWinDetail(String invoiceId, String lotteryStr) async {
    // final testInvoice = "66d525ec000a12bdf1ab";
    // final testLotteryDate = "20240905";
    Get.toNamed(
      RouteName.winbill,
      arguments: {
        "invoiceId": invoiceId,
        "lotteryStr": lotteryStr,
        // "invoiceId": testInvoice,
        // "lotteryStr": testLotteryDate,
      },
    );
  }

  @override
  void onInit() {
    logger.w("oninit history win");
    super.onInit();
  }
}
