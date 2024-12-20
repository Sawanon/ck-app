import 'dart:async';
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
import 'package:pubnub/pubnub.dart';
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
  int? pointMonney;
  StreamSubscription<String>? streamInvoice;
  Subscription? subscriptionPubnub;

  void getPointRaio() async {
    final pointRatio = await AppWriteController.to.getPointRaio();
    logger.d(pointRatio);
  }

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
    // TODO: develop remove on production
    bankList?.add(
      Bank(
        $id: 'fake',
        name: 'BCEL',
        fullName: 'BCEL',
        downtime: '21:00-00:00',
      ),
    );
    if (bankList != null) {
      this.bankList = bankList;
      update();
    }
  }

  bool checkActiveBank(String downtime) {
    final [start, end] = downtime.split("-");
    TimeOfDay now = TimeOfDay.now();
    final startTime = TimeOfDay(
        hour: int.parse(start.split(":")[0]),
        minute: int.parse(start.split(":")[1]));
    final endTime = TimeOfDay(
        hour: int.parse(end.split(":")[0]),
        minute: int.parse(end.split(":")[1]));
    // logger.d("now: $now");
    // logger.d("startTime: $startTime");
    // logger.d("endTime: $endTime");
    final isEndTimeBeforeStart = CommonFn.isBeforeTime(endTime, startTime);
    // logger.d("isEndTimeBeforeStart: $isEndTimeBeforeStart");
    final nowAfterStart = CommonFn.isSameAfterTime(now, startTime);
    final nowBeforeEnd = CommonFn.isSameBeforeTime(now, endTime);
    // logger.d("nowAfterStart: $nowAfterStart");
    // logger.d("nowBeforeEnd: $nowBeforeEnd");
    if (isEndTimeBeforeStart && nowAfterStart) {
      return false;
    }
    if (nowAfterStart && nowBeforeEnd) {
      return false;
    }
    return true;
  }

  void setup() async {
    point = null;
    setLotteryDate();
    getBank();
    listenInvoiceExpire();
  }

  void listenInvoiceExpire() {
    streamInvoice = BuyLotteryController.to.invoiceRemainExpireStr.listen(
      (value) {
        if (value == "") {
          Get.back();
        }
      },
    );
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
    if (bank.downtime != null) {
      final bankValid = validBank(bank);
      if (!bankValid) return;
    }
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

  Future<void> subRealTime(String invoiceId) async {
    // Create PubNub instance with default keyset.
    var pubnub = PubNub(
      defaultKeyset: Keyset(
        publishKey: 'pub-c-ff681b02-4518-4dbd-a081-f98d1b2fcef6',
        subscribeKey: 'sub-c-8ae0d87d-51b2-4f42-83b6-e201bb96d7bd',
        userId: UserId('sawanon'),
      ),
    );

    // Subscribe to a channel
    var channel = "hello_world-$invoiceId";
    subscriptionPubnub = pubnub.subscribe(channels: {channel});

    logger.d("subscription start");
    // Print every message
    subscriptionPubnub?.messages.listen((message) {
      logger.w(message.content);
      showBill(invoiceId);
      // subscriptionPubnub?.unsubscribe();
      // subscriptionPubnub?.cancel();
      subscriptionPubnub?.dispose();
    })
      ?..onDone(
        () {
          logger.d("subscription done");
        },
      )
      ..onError(
        (error, stackTrace) {
          logger.e(error);
          logger.e(stackTrace);
        },
      );
    // ..onError((e) {
    //   logger.e(e);
    // })
    // ..onDone(
    //   () {
    //     logger.d("subscription success");
    //   },
    // );
    // Send a message every second for 5 seconds
    // for (var i = 1; i <= 5; i++) {
    //   await pubnub.publish(channel, 'Message no. $i');
    //   await Future.delayed(Duration(seconds: 1));
    // }

    // Unsubscribe and quit
    // await subscription.dispose();
  }

  bool validBank(Bank bank) {
    final active = checkActiveBank(bank.downtime!);
    logger.f("active: $active");
    if (!active) {
      Get.dialog(
        DialogApp(
          title: Text("ช่องทางการชำระเงินนี้ยังไม่เปิดให้ใช้งาน"),
          details: Text("ปิดใช้งานในช่วงเวลา ${bank.downtime}"),
          disableConfirm: true,
        ),
      );
      return false;
    }
    return true;
  }

  void createInvoice(Bank bank) async {
    try {
      if (bank.downtime != null) {
        final bankValid = validBank(bank);
        if (!bankValid) return;
      }
      logger.d("bank name: ${bank.name}");
      final invoiceMeta = BuyLotteryController.to.invoiceMeta.value;
      if (bank.$id == "fake") {
        // await subRealTime();
        const bcelUrl = "http://192.168.1.107:3002";
        final userApp = LayoutController.to.userApp;
        logger.d("${invoiceMeta.toJson(userApp!.userId)}");

        subRealTime(invoiceMeta.invoiceId!);
        await Future.delayed(const Duration(seconds: 2));
        final dio = Dio();
        final response = await dio.post(
          "$bcelUrl/requestPayment",
          data: {
            "uuid": invoiceMeta.invoiceId,
            "amount": invoiceMeta.amount,
          },
        );
        logger.d(response);

        // await launchUrl(
        //   Uri.parse("$bcelUrl/payment"),
        //   mode: LaunchMode.externalApplication,
        // );
        Get.rawSnackbar(message: "fake");
        return;
      }
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
      // final user = await AppWriteController.to.user;
      final userApp = LayoutController.to.userApp;
      if (userApp == null) throw "not found user please login";
      final storage = StorageController.to;
      final sessionId = await storage.getSessionId();
      final credential = "$sessionId:${userApp.userId}";
      final bearer = base64Encode(utf8.encode(credential));
      final dio = Dio();
      final payload = {
        "bankId": bank.$id,
        "phone": userApp.phoneNumber,
        "totalAmount": invoiceMeta.totalAmount,
        "invoiceId": invoiceMeta.invoiceId,
        "lotteryDateStr": invoiceMeta.lotteryDateStr,
        "customerId": userApp.customerId,
        "point": point,
      };
      logger.w(payload);
      final responseTransaction = await dio.post(
        "${AppConst.apiUrl}/payment",
        // "https://1f12-223-24-93-229.ngrok-free.app/api/payment",
        // https://a6d2-2405-9800-b920-2f86-d4ea-ac87-e5a6-607c.ngrok-free.app
        // "https://a6d2-2405-9800-b920-2f86-d4ea-ac87-e5a6-607c.ngrok-free.app/api/transaction",
        data: payload,
        options: Options(
          headers: {
            "Authorization": "Bearer $bearer",
          },
        ),
      );
      logger.w("responseTransaction");
      logger.w(responseTransaction);
      final result = responseTransaction.data['data'];
      logger.w(result);
      final payment = result['payment'];
      final deeplink = payment['dataResponse']['link'];

      await launchUrl(Uri.parse('$deeplink'));
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
        Get.rawSnackbar(message: e.response?.statusMessage);
      }
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

  @override
  void onClose() {
    logger.d("cancel");
    streamInvoice?.cancel();
    // subscriptionPubnub?.unsubscribe();
    // subscriptionPubnub?.cancel();
    subscriptionPubnub?.dispose();
    super.onClose();
  }
}
