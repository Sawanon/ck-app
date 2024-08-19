import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/model/history.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/bill/view/bill_component.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class LotteryDate {
  late DateTime dateTime;
  late DateTime startTime;
  late DateTime endTime;

  LotteryDate({
    required DateTime dateTime,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    this.dateTime = dateTime.toLocal();
    this.startTime = startTime.toLocal();
    this.endTime = endTime.toLocal();
  }

  static LotteryDate fromJson(Map json) => LotteryDate(
        dateTime: DateTime.parse(json['datetime']),
        startTime: DateTime.parse(json['start_time']),
        endTime: DateTime.parse(json['end_time']),
      );

  @override
  String toString() {
    return dateTime.toString();
  }
}

class HistoryBuyController extends GetxController {
  static HistoryBuyController get to => Get.find();
  DateTime? selectedLotteryDate;
  List<LotteryDate> lotteryDateList = [];
  RxList<History> historyList = <History>[].obs;
  RxList invoiceDetail = [].obs;

  void listLotteryDate() async {
    try {
      final appwriteController = AppWriteController.to;
      final lotteryDateList = await appwriteController.listLotteryDate();
      if (lotteryDateList == null) {
        return;
      }
      this.lotteryDateList = lotteryDateList.reversed.toList();
      selectedLotteryDate = this.lotteryDateList.first.dateTime;
      update();
    } on Exception catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  Future getHistoryBuy(DateTime lotteryDate) async {
    final lotteryStr = CommonFn.parseYMD(lotteryDate).split("-").join("");
    final response = await AppWriteController.to.getHistoryBuy(lotteryStr);
    logger.d(response);
    if (response == null) {
      //TODO: this lottery date is empty
      return;
    }
    List<History> historyList = [];
    for (var invoice in response.documents) {
      historyList.add(History.fromJson(invoice.data));
    }
    this.historyList.value = historyList;
  }

  Future<Document> getTransaction(String transactionId) async {
    final lotteryStr =
        CommonFn.parseYMD(selectedLotteryDate!).split("-").join("");
    final transaction = await AppWriteController.to.getTransactionById(
      transactionId,
      lotteryStr,
    );
    return transaction!;
  }

  Future<void> onChangeLotteryDate(DateTime lotteryDate) async {
    logger.d("fetch API !");
    await getHistoryBuy(lotteryDate);
    selectedLotteryDate = lotteryDate;
    update();
    for (var history in historyList) {
      final lotteryList = [];
      for (var transactionId in history.transactionIdList) {
        final transaction = await getTransaction(transactionId);
        lotteryList.add(transaction.data['lottery']);
      }
      history.lotteryList = lotteryList;
    }
    update();
  }

  Future<void> refreshHistory() async {
    if (selectedLotteryDate == null) {
      return;
    }
    await onChangeLotteryDate(selectedLotteryDate!);
  }

  void visitPage() async {
    if (selectedLotteryDate == null || historyList.isNotEmpty) return;

    await onChangeLotteryDate(selectedLotteryDate!);
    logger.w("visitPage");
  }

  void makeBillDialog(BuildContext context, History history) async {
    final appwriteController = AppWriteController.to;
    final user = await appwriteController.account.get();
    final bank = await appwriteController.getBankById(history.bankId);
    List<Lottery> transactionList = [];
    final lotteryStr =
        CommonFn.parseYMD(selectedLotteryDate!).split("-").join("");
    for (var transactionId in history.transactionIdList) {
      final transactionDocument = await appwriteController.getTransactionById(
        transactionId,
        lotteryStr,
      );
      transactionList.add(Lottery.fromJson(transactionDocument!.data));
    }
    final bill = Bill(
      firstName: user.name.split(" ").first,
      lastName: user.name.split(" ")[1],
      phoneNumber: user.phone,
      dateTime: DateTime.parse(history.createdAt), //TODO:toLocal()
      lotteryDateStr: lotteryStr,
      lotteryList: transactionList,
      totalAmount: history.totalAmount.toString(),
      invoiceId: history.invoiceId,
      bankName: bank?.name ?? "-",
    );
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(child: BillComponent(bill: bill)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: LongButton(
                    onPressed: () {
                      navigator?.pop();
                    },
                    child: const Text(
                      "ປິດ",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void onInit() {
    listLotteryDate();
    super.onInit();
  }
}
