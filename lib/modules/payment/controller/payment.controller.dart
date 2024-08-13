import 'package:get/get.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/utils.dart';

class PaymentController extends GetxController {
  List<Lottery> lotteryList = <Lottery>[];
  List<Bank> bankList = [];

  void getBank() async {
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

  void setup() {
    final buyLotteryController = BuyLotteryController.to;
    lotteryList = buyLotteryController.lotteryList;
  }

  void payLottery(Bank bank) async {
    logger.d(bank.$id);
    final appwriteController = AppWriteController.to;
    final document = await appwriteController.createInvoice(
      '1000',
      bank.$id,
    );
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
