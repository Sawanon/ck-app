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
    // lotteryList = buyLotteryController.lotteryList;
    final homeController = HomeController.to;
    lotteryDate = homeController.lotteryDate;
    final lotteryDateStrYMD = CommonFn.parseYMD(homeController.lotteryDate!);
    this.lotteryDateStrYMD = lotteryDateStrYMD.split("-").join("");
    totalAmount = buyLotteryController.totalAmount.value;
  }

  void payLottery(Bank bank, int amount, BuildContext context) async {
    Get.to(PinVerifyPage(disabledBackButton: false), arguments: {
      "whenSuccess": () async {
        logger.d("boom !");
        Get.back();
        createInvoice(bank);
        // logger.d("should back !");
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
        totalAmount: invoiceMeta.amount.toString(),
        invoiceId: invoiceDocuments.data['billId'],
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
          "onInit": () async {
//             {
//    "status": 200,
//    "message": "Request success",
//    "data": {
//      "98218": "36724",
//      "transData": [
//        {
//          "transCashOutID": "20241003161621980177",
//          "transStatus": "R",
//          "accountNo": "XXXXXX5064",
//          "accountNameEN": "CK ",
//          "accountRef": "2055265064",
//          "accountType": "TC WALLET",
//          "transExpiry": "2024-10-03 16:21:21.98"
//        }
//      ],
//      "otpRefNo": "094N6GR4",
//      "otpRefCode": "9P92",
//      "otpLockFlag": "0",
//      "openSMS": "Y",
//      "responseCode": "0000",
//      "responseMessage": "Operation success",
//      "responseStatus": "SUCCESS",
//      "transID": "66fe5cff001ff257203a",
//      "processTime": 5775,
//      "serverDatetime": "2024-10-03 16:16:27",
//      "serverDatetimeMs": 1727946987736
//    };
//  }
            logger.d("get otp");
            final dio = Dio();
            final token = await AppWriteController.to.getCredential();
            final response = await dio.post(
              "${AppConst.apiUrl}/payment",
              data: {
                "bankId": bank.$id,
                "phone": user.phone,
                "totalAmount": invoiceMeta.amount,
                "invoiceId": invoiceMeta.invoiceId,
                "lotteryDateStr": invoiceMeta.lotteryDateStr,
              },
              options: Options(
                headers: {
                  "Authorization": "Bearer $token",
                },
              ),
            );
            logger.d(response.data);
            otpRefNo = response.data['data']['otpRefNo'];
            otpRefCode = response.data['data']['otpRefCode'];
            transCashOutID =
                response.data['data']['transData'][0]['transCashOutID'];
          },
          "onConfirm": (otp) async {
            final dio = Dio();
            final token = await AppWriteController.to.getCredential();
            //   {
//     "invoiceId": "66fcd1a900023a859e9c",
//     "otpRefNo": "LSA0PACX",
//     "otpRefCode": "7ZBH",
//     "otp": "287163",
//     "transCashOutID": "20241002122325525571",
//     "lotteryDate": "20241004"
// }
            final response = await dio.post(
              "${AppConst.apiUrl}/payment/confirm",
              data: {
                "invoiceId": invoiceMeta.invoiceId,
                "otpRefNo": otpRefNo,
                "otpRefCode": otpRefCode,
                "otp": otp,
                "transCashOutID": transCashOutID,
                "lotteryDate": invoiceMeta.lotteryDateStr,
              },
              options: Options(
                headers: {
                  "Authorization": "Bearer $token",
                },
              ),
            );
            logger.f("boom !!!!");
            logger.d(response.data);
            if (response.data['responseCode'] != '0000') {
              Get.dialog(DialogApp(
                title: Text(
                  "${response.data['responseStatus']}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                details: Text(
                  "${response.data['responseMessage']}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ));
              // responseMessage
              return;
            }
            Get.back();
            showBill(invoiceMeta.invoiceId!);

            // goto show bill
          }
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
      // {
      //     "lotteryDateStr": "20241004", /
      //     // "bankId": "66f3794c00365ecfc225",
      //     "totalAmount": 4000, /
      //     "customerId": "testCustimerId",
      //     "phone": "+8562054656226",
      //     "invoiceId": "66fb89d80009543b3c00",
      //     "transactions": [
      //         {
      //         //    "$id": "66fb89da000cb8af416f",
      //             "lottery": "234",
      //             "digit_1": null,
      //             "digit_2": null,
      //             "digit_3": null,
      //             "digit_4": "2",
      //             "digit_5": "3",
      //             "digit_6": "4",
      //             "lotteryType": 3,
      //             "amount": 5000,
      //             "userId": "66e9b066000956d5e74e"
      //         },
      //         {
      //             "$id": null,
      //             "lottery": "235",
      //             "digit_1": null,
      //             "digit_2": null,
      //             "digit_3": null,
      //             "digit_4": "2",
      //             "digit_5": "3",
      //             "digit_6": "5",
      //             "lotteryType": 3,
      //             "amount": 30000000,
      //             "userId": "66e9b066000956d5e74e"
      //         }
      //     ]
      // }
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
    setup();
    super.onInit();
  }
}
