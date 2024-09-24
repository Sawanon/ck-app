import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/pin/view/pin_verify.dart';
import 'package:lottery_ck/modules/pin/view/verify_pin.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentController extends GetxController {
  static PaymentController get to => Get.find();
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

  Future<void> checkType() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    logger.d("canAuthenticateWithBiometrics: $canAuthenticateWithBiometrics");
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    logger.d("canAuthenticate: $canAuthenticate");
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    logger
        .w("availableBiometrics.isNotEmpty: ${availableBiometrics.isNotEmpty}");
    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.
      logger.w("exists biometrics");
    }
    logger.d("availableBiometrics: $availableBiometrics");
    if (availableBiometrics.contains(BiometricType.weak) &&
        availableBiometrics.contains(BiometricType.strong)) {
      logger.w("weak and strong biometrics");
      await _authencated();
    }

    if (availableBiometrics.contains(BiometricType.fingerprint) ||
        availableBiometrics.contains(BiometricType.face)) {
      logger.w("fingerprint: ${BiometricType.fingerprint}");
      logger.w("face: ${BiometricType.face}");
      await _authencated();
    }
  }

  Future<void> _authencated() async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      bool authencated = await auth.authenticate(
        localizedReason: 'test',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      logger.d("authencated: $authencated");
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  void payLottery(Bank bank, int totalAmount, BuildContext context) async {
    Get.to(PinVerifyPage(disabledBackButton: false), arguments: {
      "whenSuccess": () async {
        logger.d("boom !");
        createInvoice(bank, totalAmount);
        Get.back();
      }
    });
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
      final appwriteController = AppWriteController.to;
      final user = await appwriteController.user;
      final invoiceDocuments = await appwriteController.getInvoice(
        invoiceId,
        lotteryDateStrYMD!,
      );
      logger.d(invoiceDocuments?.data);

      final bill = Bill(
        firstName: user.name.split(" ").first,
        lastName: user.name.split(" ")[1],
        phoneNumber: user.phone,
        dateTime: DateTime.parse(invoiceDocuments!.$createdAt),
        lotteryDateStr: lotteryDateStrYMD!,
        lotteryList: lotteryList,
        totalAmount: totalAmount.toString(),
        invoiceId: invoiceDocuments.$id,
        bankName: selectedBank!.name,
      );
      Get.offNamed(
        RouteName.bill,
        arguments: {
          "bill": bill,
        },
      );
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  void createInvoice(Bank bank, int totalAmount) async {
    try {
      isLoading = true;
      update();
      final user = await AppWriteController.to.user;
      final storage = StorageController.to;
      final sessionId = await storage.getSessionId();
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
        // "${AppConst.apiUrl}/transaction/",
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
      final result = responseTransaction.data;
      final deeplink = result['deeplink'];
      final invoiceDocument = result['invoice'];
      logger.w(invoiceDocument);
      await launchUrl(Uri.parse('${deeplink['link']}'));
      isLoading = false;
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(
        message: "$e",
      );
      isLoading = false;
    } finally {
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
