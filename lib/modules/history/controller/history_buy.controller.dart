import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/model/history.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/model/lottery_date.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/bill/view/bill_component.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class HistoryBuyController extends GetxController {
  static HistoryBuyController get to => Get.find();
  DateTime? selectedLotteryDate;
  List<LotteryDate> lotteryDateList = [];
  RxList<History> historyList = <History>[].obs;
  RxBool loadingHistoryList = false.obs;
  RxBool loadingTransactionId = false.obs;
  // RxBool loadingBill = false.obs;

  void listLotteryDate() async {
    try {
      final appwriteController = AppWriteController.to;
      final lotteryDateList = await appwriteController.listLotteryDate();
      if (lotteryDateList == null) {
        return;
      }
      logger.d(lotteryDateList);
      logger.w("lotteryDateList: ${lotteryDateList.length}");
      // cuuretn datetime and when found after current date keep 1 and remove all
      this.lotteryDateList = lotteryDateList;
      selectedLotteryDate = this.lotteryDateList.first.dateTime;
      update();
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  Future getHistoryBuy(DateTime lotteryDate) async {
    final lotteryStr = CommonFn.parseYMD(lotteryDate).split("-").join("");
    final response = await AppWriteController.to.getHistoryBuy(lotteryStr);
    // TODO: limit lottery date history
    logger.d(response);
    if (response == null) {
      //TODO: this lottery date is empty
      return;
    }
    List<History> historyList = [];
    for (var invoice in response.documents) {
      logger.d("invoice.data: ${invoice.data}");
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
    return;
    loadingHistoryList.value = true;
    await getHistoryBuy(lotteryDate);
    loadingHistoryList.value = false;
    selectedLotteryDate = lotteryDate;
    update();
    loadingTransactionId.value = true;
    for (var history in historyList) {
      final lotteryList = [];
      for (var transactionId in history.transactionIdList) {
        final transaction = await getTransaction(transactionId);
        lotteryList.add(transaction.data['lottery']);
      }
      history.lotteryList = lotteryList;
    }
    loadingTransactionId.value = false;
    update();
  }

  Future<void> refreshHistory() async {
    listLotteryDate();
    if (selectedLotteryDate == null) {
      return;
    }
    await onChangeLotteryDate(selectedLotteryDate!);
  }

  void visitPage() async {
    // try {
    await AppWriteController.to.user;
    // if (selectedLotteryDate == null || historyList.isNotEmpty) return;
    if (selectedLotteryDate == null) return;

    await onChangeLotteryDate(selectedLotteryDate!);
    logger.w("visitPage");
    // } catch (e) {
    //   logger.e("$e");
    //   Get.rawSnackbar(message: "$e");
    // }
  }

  void makeBillDialog(BuildContext context, History history) async {
    // TODO: creaet loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          backgroundColor: Colors.white,
        ),
      ),
    );
    final appwriteController = AppWriteController.to;
    final user = await appwriteController.account.get();
    final userApp = await appwriteController.getUserApp();
    logger.d(history.toJson());
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
    navigator?.pop();
    final bill = Bill(
      firstName: user.name.split(" ").first,
      lastName: user.name.split(" ")[1],
      phoneNumber: user.phone,
      dateTime: DateTime.parse(history.createdAt), //TODO:toLocal()
      lotteryDateStr: lotteryStr,
      lotteryList: transactionList,
      totalAmount: history.totalAmount.toString(),
      amount: history.amount,
      billId: history.billId ?? "-",
      bankName: bank?.fullName ?? "-",
      customerId: userApp!.customerId!,
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
