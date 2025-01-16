import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottery_ck/components/coupons.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/model/coupon.dart';
import 'package:lottery_ck/model/invoice_meta.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/payment/view/bank.dart';
import 'package:lottery_ck/modules/payment/view/bonus_detail.dart';
import 'package:lottery_ck/modules/payment/view/use_point.dart';
import 'package:lottery_ck/modules/pin/view/pin_verify.dart';
import 'package:lottery_ck/modules/pin/view/verify_pin.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
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
  int routeLevel = 0;
  bool isOpenedDialog = false;
  List<Coupon> couponsList = [];
  int maxPercentPointCanuse = 0;

  void getPointRaio() async {
    final pointRatio = await AppWriteController.to.getPointRaio();
    logger.d(pointRatio);
  }

  void onChangePoint(int value) {
    if (value <= 0) {
      point = null;
    } else {
      point = value;
    }
    update();
  }

  Future<void> getBank() async {
    final appwriteController = AppWriteController.to;
    final bankDocuments = await appwriteController.listBank();
    final bankList = bankDocuments?.documents.map(
      (document) {
        return Bank.fromJson(document.data);
      },
    ).toList();
    // TODO: develop remove on production
    // bankList?.add(
    //   Bank(
    //     $id: 'fake',
    //     name: 'BCEL',
    //     fullName: 'BCEL',
    //     downtime: '21:00-00:00',
    //   ),
    // );
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
    await getBank();
    listenInvoiceExpire();
    listMyCoupons();
    await getPoinCanUseOnInvoice();
  }

  void listenInvoiceExpire() {
    streamInvoice = BuyLotteryController.to.invoiceRemainExpireStr.listen(
      (value) {
        if (value == "") {
          if (isOpenedDialog) {
            Get.back();
          }
          Get.back();
        }
      },
    );
  }

  void setLotteryDate() {
    // final buyLotteryController = BuyLotteryController.to;
    // lotteryList = buyLotteryController.lotteryList;
    final homeController = HomeController.to;
    lotteryDate = homeController.lotteryDate;
    final lotteryDateStrYMD = CommonFn.parseYMD(homeController.lotteryDate!);
    this.lotteryDateStrYMD = lotteryDateStrYMD.split("-").join("");
    // totalAmount = buyLotteryController.totalAmount.value;
  }

  void payLottery(Bank bank, BuildContext context) async {
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
      // final bill = Bill(
      //   firstName: userApp!.firstName,
      //   lastName: userApp.lastName,
      //   phoneNumber: userApp.phoneNumber,
      //   dateTime: DateTime.parse(invoiceDocuments!.$createdAt),
      //   lotteryDateStr: lotteryDateStrYMD!,
      //   lotteryList: invoiceMeta.transactions,
      //   totalAmount: invoiceMeta.totalAmount.toString(),
      //   amount: invoiceMeta.amount,
      //   billId: "2025011349fk9499f9",
      //   // invoiceId: invoiceMeta,
      //   // bankName: selectedBank!.fullName,
      //   bankName: "Lao Development Bank (LDB)",
      //   customerId: userApp.customerId!,
      // );
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
      if (bank.name == "ldb") {
        final canLaunch = await canLaunchUrl(Uri.parse("ldbpay://ldblao.la"));
        logger.w(canLaunch);
        if (canLaunch == false) {
          logger.d("in if");
          await launchUrl(Uri.parse(
              'https://play.google.com/store/apps/details?id=com.ldb.wallet'));
          return;
        }
      }
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
      if (bank.name == "ldb") {
        try {
          await launchUrl(Uri.parse('$deeplink'));
        } catch (e) {
          logger.e("$e");
          await launchUrl(Uri.parse(
              'https://play.google.com/store/apps/details?id=com.ldb.wallet'));
        }
      }
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

  void showBottomModalPoint(BuildContext context) {
    final int myPoint = SettingController.to.user?.point != null
        ? SettingController.to.user!.point
        : 0;
    int maxPointCanUse = 0;
    final invoice = BuyLotteryController.to.invoiceMeta.value;

    if (maxPercentPointCanuse != 0) {
      final valueCanUse = invoice.amount * (maxPercentPointCanuse / 100);
      if (myPoint < valueCanUse) {
        maxPointCanUse = myPoint;
      } else {
        maxPointCanUse = valueCanUse.toInt();
      }
    }
    isOpenedDialog = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return UsePointComponent(
          myPoint: maxPointCanUse,
          onSubmit: (usePoint) {
            onChangePoint(usePoint);
            Get.back();
          },
        );
      },
    ).whenComplete(
      () {
        isOpenedDialog = false;
      },
    );
  }

  Future<void> listMyCoupons() async {
    final user = SettingController.to.user;
    if (user == null) {
      logger.w("user is empty");
      return;
    }
    final response = await AppWriteController.to.listMyCoupons(user.userId);
    if (response.isSuccess == false) {
      Get.dialog(DialogApp(
        title: Text(
          AppLocale.somethingWentWrong.getString(Get.context!),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        details: Text(
          response.message,
        ),
      ));
      return;
    }
    final coupons = response.data;
    if (coupons == null || coupons.isEmpty) {
      return;
    }
    final responsePromotionsList =
        await AppWriteController.to.listPromotionDetail(
      coupons.map((coupon) => coupon.promotionId).toList(),
    );
    if (responsePromotionsList.isSuccess == false ||
        responsePromotionsList.data == null) {
      Get.dialog(DialogApp(
        title: Text(
          AppLocale.somethingWentWrong.getString(Get.context!),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        details: Text(
          responsePromotionsList.message,
        ),
      ));
      return;
    }
    for (var coupon in coupons) {
      final promotionMap = responsePromotionsList.data!.firstWhere(
        (promotion) {
          return promotion['\$id'] == coupon.promotionId;
        },
      );
      coupon.promotion = promotionMap;
    }
    logger.d(responsePromotionsList.data);
    couponsList = coupons;
    update();
  }

  // level can be 1 or -1
  void setRouteLevel(int level) {
    routeLevel += level;
  }

  void gotoSelectPaymentMethod() {
    isOpenedDialog = true;
    Get.to(
      () => const BankPage(),
      transition: Transition.downToUp,
    )!
        .whenComplete(
      () {
        isOpenedDialog = false;
      },
    );
  }

  int get totalAmount =>
      BuyLotteryController.to.invoiceMeta.value.totalAmount - (point ?? 0);

  bool get enablePays => selectedBank != null;

  void gotoCouponPage() {
    isOpenedDialog = true;
    Get.to(
      () => CouponsPage(
        couponsList: couponsList,
        selectedCouponsList:
            BuyLotteryController.to.invoiceMeta.value.couponIds,
      ),
      transition: Transition.downToUp,
    )?.whenComplete(
      () {
        isOpenedDialog = false;
      },
    );
  }

  Future<void> applyCoupon(List<String> couponIdsList) async {
    logger.d(lotteryDateStrYMD);
    final lotteryDate = lotteryDateStrYMD;
    final invoiceId = BuyLotteryController.to.invoiceMeta.value.invoiceId;
    if (lotteryDate == null) {
      logger.e("lotteryDateStrYMD is empty");
      return;
    }
    if (invoiceId == null) {
      logger.e("invoiceId is empty");
      return;
    }

    final response = await AppWriteController.to.applyCoupon(
      lotteryDate: lotteryDate,
      invoiceId: invoiceId,
      couponIdsList: couponIdsList,
    );
    logger.d(response.data);
    if (response.data == null || response.isSuccess == false) {
      Get.dialog(
        DialogApp(
          title: Text(
            AppLocale.somethingWentWrong.getString(Get.context!),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          details: Text(
            response.message,
          ),
        ),
      );
      return;
    }
    final result = response.data!['data'];
    final invoiceRes = result['invoice'];
    final InvoiceMetaData invoice =
        BuyLotteryController.to.invoiceMeta.value.copyWith();
    invoice.amount = invoiceRes['amount'];
    invoice.quota = invoiceRes['quota'];
    invoice.bonus = invoiceRes['bonus'];
    invoice.discount = invoiceRes['discount'];
    invoice.totalAmount = invoiceRes['totalAmount'];
    invoice.transactions.clear();
    invoice.couponIds = invoiceRes['couponId'];
    final List transactions = result['transaction'];
    for (var transaction in transactions) {
      invoice.transactions.add(
        Lottery(
          lottery: transaction['lottery'],
          amount: transaction['amount'],
          lotteryType: transaction['lotteryType'],
          quota: transaction['quota'],
          bonus: transaction['bonus'],
          discount: transaction['discount'],
          totalAmount: transaction['totalAmount'],
        ),
      );
    }
    BuyLotteryController.to.setInvoice(invoice);
  }

  void showBonusDetail(BuildContext context) {
    isOpenedDialog = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return const BonusDetailComponent();
      },
    ).whenComplete(
      () {
        isOpenedDialog = false;
      },
    );
  }

  Future<void> getPoinCanUseOnInvoice() async {
    final response = await AppWriteController.to.getPointCanUseOnInvoice();
    if (response.isSuccess == false) {
      Get.dialog(
        DialogApp(
          title: Text(
            AppLocale.somethingWentWrong.getString(Get.context!),
          ),
          details: Text(
            response.message,
          ),
        ),
      );
      return;
    }
    if (response.data == null) {
      Get.dialog(
        DialogApp(
          title: Text(
            AppLocale.somethingWentWrong.getString(Get.context!),
          ),
          details: const Text(
            "point can use on invoice is empty",
          ),
        ),
      );
      return;
    }
    maxPercentPointCanuse = response.data!.percent;
    update();
  }

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
