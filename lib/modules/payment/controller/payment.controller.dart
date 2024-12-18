import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/model/invoice_meta.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/pin/view/pin_verify.dart';
import 'package:lottery_ck/modules/pin/view/verify_pin.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentController extends GetxController {
  static PaymentController get to => Get.find();
  // List<Lottery> lotteryList = <Lottery>[];
  List<Bank> bankList = [];
  DateTime? lotteryDate;
  String? lotteryDateStrYMD;
  int? totalAmount;
  Bank? selectedBank;
  bool isLoading = false;
  String? confirmOTP;
  String? otpRefNo;
  String? otpRefCode;
  String? transCashOutID;
  String? transID;
  int? point;

  void onChangePoint(int value) {
    point = value;
    update();
  }

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
    point = null;
    setLotteryDate();
    getBank();
  }

  void setLotteryDate() {
    final buyLotteryController = BuyLotteryController.to;
    // lotteryList = buyLotteryController.lotteryList;
    final homeController = HomeController.to;
    lotteryDate = homeController.lotteryDate;
    final lotteryDateStrYMD = CommonFn.parseYMD(homeController.lotteryDate!);
    this.lotteryDateStrYMD = lotteryDateStrYMD.split("-").join("");
    totalAmount = buyLotteryController.totalAmount.value;
  }

  void payLottery(Bank bank, int amount, BuildContext context) async {
    Get.to(
      PinVerifyPage(disabledBackButton: false),
      arguments: {
        "userId": LayoutController.to.userApp!.userId,
        "whenSuccess": () async {
          logger.d("boom !");
          Get.back();
          createInvoice(bank);
          // logger.d("should back !");
        }
      },
    );
    // await Pin.verifyPin(
    //   context,
    //   () {
    //     logger.d("boom !");
    //     navigator?.pop();
    //     createInvoice(bank, totalAmount);
    //   },
    // );
  }

  void showBill(String invoiceId) async {
    try {
      final invoiceMeta = BuyLotteryController.to.invoiceMeta.value;
      final appwriteController = AppWriteController.to;
      // final user = await appwriteController.user;
      final userApp = await appwriteController.getUserApp();
      final invoiceDocuments = await appwriteController.getInvoice(
        invoiceId,
        lotteryDateStrYMD!,
      );
      logger.d(invoiceDocuments?.data);

      final bill = Bill(
        firstName: userApp!.firstName,
        lastName: userApp.lastName,
        phoneNumber: userApp.phoneNumber,
        dateTime: DateTime.parse(invoiceDocuments!.$createdAt),
        lotteryDateStr: lotteryDateStrYMD!,
        lotteryList: invoiceMeta.transactions,
        totalAmount: invoiceMeta.totalAmount.toString(),
        amount: invoiceMeta.amount,
        billId: invoiceDocuments.data['billId'],
        // invoiceId: invoiceMeta,
        bankName: selectedBank!.fullName,
        customerId: userApp.customerId!,
      );
      Get.offNamed(
        RouteName.bill,
        arguments: {"bill": bill, "onClose": () {}},
      );
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  void createInvoice(Bank bank) async {
    try {
      logger.d("bank name: ${bank.name}");
      final invoiceMeta = BuyLotteryController.to.invoiceMeta.value;
      if (bank.name == "mmoney") {
        final user = await AppWriteController.to.user;
        // request cashout => api create invoice success
        Get.toNamed(RouteName.confirmPaymentOTP, arguments: {
          "phoneNumber": user.phone,
          "bankId": bank.$id,
          "totalAmount": invoiceMeta.amount,
          "invoiceId": invoiceMeta.invoiceId,
          "lotteryDateStr": invoiceMeta.lotteryDateStr,
          "point": point,
        });

        // logger.
        return;
      }
      isLoading = true;
      update();
      final user = await AppWriteController.to.user;
      final storage = StorageController.to;
      final sessionId = await storage.getSessionId();
      final credential = "$sessionId:${user.$id}";
      final bearer = base64Encode(utf8.encode(credential));
      final transactions = invoiceMeta.transactions
          .map(
            (lottery) => lottery.toJson(),
          )
          .toList();
      final dio = Dio();
      final responseTransaction = await dio.post(
        // "${AppConst.cloudfareUrl}/createTransaction",
        // https://a6d2-2405-9800-b920-2f86-d4ea-ac87-e5a6-607c.ngrok-free.app
        "https://a6d2-2405-9800-b920-2f86-d4ea-ac87-e5a6-607c.ngrok-free.app/api/transaction",
        data: {
          // "totalAmount": totalAmount, x
          // "bankId": bank.$id, x
          "lotteryDateStr": lotteryDateStrYMD!,
          "transactions": transactions,
          // "customerId": "testCustimerId",
          "phone": user.phone,
          "invoiceId": '?',
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $bearer",
          },
        ),
      );
      final result = responseTransaction.data;
      logger.w(result);
      final deeplink = result['deeplink'];
      final invoiceDocument = result['invoice'];
      logger.w(invoiceDocument);
      await launchUrl(Uri.parse('${deeplink['link']}'));
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(
        message: "$e",
      );
    } finally {
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
    logger.d("payment on init");
    setup();
    super.onInit();
  }
}
