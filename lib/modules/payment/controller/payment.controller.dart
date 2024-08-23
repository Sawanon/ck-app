import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentController extends GetxController {
  List<Lottery> lotteryList = <Lottery>[];
  List<Bank> bankList = [];
  DateTime? lotteryDate;
  String? lotteryDateStrYMD;
  int? totalAmount;
  Bank? selectedBank;
  bool isLoading = false;

  Future<void> getBank() async {
    final appwriteController = AppWriteController.to;
    final bankDocuments = await appwriteController.listBank();
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

  void payLottery(Bank bank, int totalAmount) async {
    logger.d("boom !");
    final storage = StorageController.to;
    final sessionId = await storage.getSessionId();
    final user = await AppWriteController.to.user;
    final credential = "$sessionId:${user.$id}";
    final bearer = base64Encode(utf8.encode(credential));
    final transactions = lotteryList
        .map(
          (lottery) => lottery.toJson(),
        )
        .toList();
    final dio = Dio();
    final responseTransaction = await dio.post(
      "${AppConst.cloudfareUrl}/createTransaction",
      data: {
        "totalAmount": totalAmount,
        "bankId": bank.$id,
        "lotteryDateStr": lotteryDateStrYMD!,
        "transactions": transactions,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $bearer",
        },
      ),
    );
    logger.w(responseTransaction.data);
    return;
    //TODO: should be move this to back-end
    final response = await dio.post(
      "${AppConst.cloudfareUrl}/bank/ldbpay/v1/authService/token",
      options: Options(
        headers: {
          "Authorization": "Basic c2F3YW5vbjoxMjM0NTY=",
        },
      ),
    );
    final accessToken = response.data['access_token'];
    logger.d("access_token: $accessToken");
    final responseDeeplink = await dio.post(
      "${AppConst.cloudfareUrl}/bank/ldbpay/v1/payment/generateLink.service",
      options: Options(
        headers: {
          "Authorization": "Basic $accessToken",
        },
      ),
      data: {
        "merchantId": "LDB0302000002",
        "merchantAcct": "4404FE0FDEA841C04BB68A35B0392F68",
        "customerId": "123",
        "referentId": "12321352",
        "amount": "$totalAmount",
        "remark": "ldbpay",
        "urlBack": "https://lottobkk.net",
        "urlCallBack": "${AppConst.cloudfareUrl}/payment",
        "additional1": "EWRWR",
        "additional2": "33432",
        "additional3": "ASAA",
        "additional4": "QQQQQQQ"
      },
    );
    final link = responseDeeplink.data['link'];
    logger.d(link);
    await launchUrl(Uri.parse('$link'));
  }

  void createInvoice(Bank bank, int totalAmount) async {
    try {
      isLoading = true;
      update();
      final appwriteController = AppWriteController.to;
      final invoiceDocument = await appwriteController.createInvoice(
        totalAmount,
        bank.$id,
        lotteryDateStrYMD!,
      );
      List<String> listTransactionId = [];
      if (invoiceDocument!.data.isNotEmpty) {
        for (var lottery in lotteryList) {
          final transactionDocument =
              await appwriteController.createTransaction(
            lottery,
            lotteryDateStrYMD!,
            bank.$id,
            lottery.toDigit(),
          );
          listTransactionId.add(transactionDocument!.$id);

          await appwriteController.addAccumulate(
            lotteryDateStrYMD!,
            lottery,
            transactionDocument.$id,
          );
        }
      }
      final invoiceDocumentUpdate = await appwriteController.updateInvoice(
        invoiceDocument.$id,
        lotteryDateStrYMD!,
        listTransactionId,
      );
      logger.d(invoiceDocumentUpdate!.$id);
      isLoading = false;
      update();
      final user = await appwriteController.user;
      final bill = Bill(
        firstName: user.name.split(" ").first,
        lastName: user.name.split(" ")[1],
        phoneNumber: user.phone,
        dateTime: DateTime.parse(invoiceDocumentUpdate.$createdAt),
        lotteryDateStr: lotteryDateStrYMD!,
        lotteryList: lotteryList,
        totalAmount: totalAmount.toString(),
        invoiceId: invoiceDocumentUpdate.$id,
        bankName: bank.name,
      );
      Get.offNamed(
        RouteName.bill,
        arguments: {
          "bill": bill,
        },
      );
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(
        message: "$e",
      );
      isLoading = false;
      update();
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
