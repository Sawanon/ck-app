import 'package:get/get.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class PaymentController extends GetxController {
  List<Lottery> lotteryList = <Lottery>[];
  List<Bank> bankList = [];
  DateTime? lotteryDate;
  String? lotteryDateStrYMD;
  int? totalAmount;
  Bank? selectedBank;

  Future<void> getBank() async {
    final appwriteController = AppWriteController.to;
    final bankDocuments = await appwriteController.getBank();
    logger.d(bankDocuments?.documents);

    final bankList = bankDocuments?.documents.map(
      (document) {
        return Bank.fromJson(document.data);
      },
    ).toList();
    if (bankList != null) {
      this.bankList = bankList;
      update();
    }
  }

  void setup() async {
    setLotteryDate();
    getBank();
  }

  void setLotteryDate() {
    final buyLotteryController = BuyLotteryController.to;
    lotteryList = buyLotteryController.lotteryList;
    final homeController = HomeController.to;
    lotteryDate = homeController.lotteryDate;
    final lotteryDateStrYMD = CommonFn.parseYMD(homeController.lotteryDate!);
    this.lotteryDateStrYMD = lotteryDateStrYMD.split("-").join("");
    totalAmount = buyLotteryController.totalAmount.value;
  }

  void payLottery(Bank bank) async {
    try {
      final appwriteController = AppWriteController.to;
      final invoiceDocument = await appwriteController.createInvoice(
        '1000',
        bank.$id,
        lotteryDateStrYMD!,
      );
      List<String> listTransactionId = [];
      if (invoiceDocument!.data.isEmpty) {
        for (var data in lotteryList) {
          logger.d(data.type);
          logger.d(data.toDigit());
          final transactionDocument =
              await appwriteController.createTransaction(
            data,
            lotteryDateStrYMD!,
            bank.$id,
            data.toDigit(),
          );
          listTransactionId.add(transactionDocument!.$id);
        }
      }
      final invoiceDocumentUpdate = await appwriteController.updateInvoice(
        invoiceDocument.$id,
        lotteryDateStrYMD!,
        listTransactionId,
      );
      logger.d(invoiceDocumentUpdate!.$id);
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(
        message: "$e",
      );
    }
  }

  void selectBank(Bank bank) {
    selectedBank = bank;
    update();
  }

  bool get enablePay => selectedBank != null;

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
