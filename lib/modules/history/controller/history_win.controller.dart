import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/lottery_history/controller/lottery_history.controller.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class HistoryWinController extends GetxController {
  static HistoryWinController get to => Get.find();
  RxList winInvoice = [].obs;
  List<String> lotteryMonthList = [];
  String selectedMonth = "";

  void changeMonth(String yearMonth) {
    selectedMonth = yearMonth;
    listWinInVoice(yearMonth);
    update();
  }

  Future<void> listWinInVoice([String? lotteryMonth]) async {
    winInvoice.clear();
    logger.d(selectedMonth);
    final lotteryMonthRevers =
        (lotteryMonth ?? selectedMonth).split("-").reversed.join("");
    logger.d(lotteryMonthRevers);
    final listInvoiceCollection =
        await AppWriteController.to.listLotteryCollection(lotteryMonthRevers);
    logger.d(listInvoiceCollection);
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

  String getLotteryDateFromCollection(String collectionId) {
    final lotteryDateStr = collectionId.split("_").first;
    final lotteryDate =
        "${lotteryDateStr.substring(6, 8)}-${lotteryDateStr.substring(4, 6)}-${lotteryDateStr.substring(0, 4)}";
    return lotteryDate;
  }

  String findWinLottery(String collectionId) {
    // lotteryHistoryList // 20250122_invoice
    final lotteryDate = getLotteryDateFromCollection(collectionId);
    final lotteryHistoryList =
        LotteryHistoryController.to.lotteryHistoryList.value;
    logger.w(lotteryHistoryList);
    final result = lotteryHistoryList.where(
      (lottery) {
        return lottery['lotteryDate'] == lotteryDate;
      },
    ).toList();
    if (result.isEmpty) {
      return "";
    }
    return result.first['lottery'];
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

  void getLotteryMonthList() async {
    final now = DateTime.now();
    final releaseAppDate = DateTime(2024, 10);
    List<String> lotteryMonthList = [];
    for (var i = 0; i < 6; i++) {
      final dateMonth = DateTime(now.year, now.month - i);
      lotteryMonthList.add(
          '${dateMonth.month.toString().padLeft(2, '0')}-${dateMonth.year}');
      if (dateMonth.isBefore(releaseAppDate)) {
        break;
      }
    }
    selectedMonth = lotteryMonthList.first;
    this.lotteryMonthList = lotteryMonthList;
    update();
  }

  @override
  void onInit() {
    getLotteryMonthList();
    super.onInit();
  }
}
