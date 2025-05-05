import 'package:get/get.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class WinBillContoller extends GetxController {
  final argument = Get.arguments;
  Bill? bill;
  Map? invoice;
  void openWinDetail() async {
    final invoiceId = argument["invoiceId"];
    final lotteryStr = argument["lotteryStr"];
    final appwriteController = AppWriteController.to;
    final invoice = await appwriteController.getInvoice(invoiceId, lotteryStr);
    final user = await appwriteController.user;
    final userApp = await appwriteController.getUserApp();
    if (invoice == null) return;
    logger.w("invoice: ${invoice.data}");
    this.invoice = invoice.data;
    final bank = await appwriteController.getBankById(invoice.data["bankId"]);
    List<Lottery> transactionList = [];
    for (var transactionId in invoice.data["transactionId"]) {
      final transactionDocument = await appwriteController.getTransactionById(
        transactionId,
        lotteryStr,
      );
      transactionList.add(Lottery.fromJson(transactionDocument!.data));
    }
    bill = Bill(
      firstName: user.name.split(" ").first,
      lastName: user.name.split(" ")[1],
      phoneNumber: user.phone,
      dateTime: DateTime.parse(invoice.$createdAt), //TODO:toLocal()
      lotteryDateStr: lotteryStr,
      lotteryList: transactionList,
      totalAmount: invoice.data["totalAmount"].toString(),
      amount: invoice.data["amount"],
      billId: invoice.data['billNumber'],
      bankName: bank?.fullName ?? "-",
      customerId: userApp!.customerId!,
      point: invoice.data['point'],
      pointMoney: invoice.data['pointMoney'],
      discount: invoice.data['discount'],
      refCode: invoice.data['bankRef'],
      isSpecialWin: invoice.data['is_special_win'],
    );
    logger.d(bill);
    update();
  }

  @override
  void onInit() {
    openWinDetail();
    super.onInit();
  }
}
