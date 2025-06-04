import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/coupons.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/controller/user_controller.dart';
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
import 'package:lottery_ck/modules/payment/view/coupon_detail.dart';
import 'package:lottery_ck/modules/payment/view/coupon_remove.dart';
import 'package:lottery_ck/modules/payment/view/promotion_detail.dart';
import 'package:lottery_ck/modules/payment/view/promotion_list.dart';
import 'package:lottery_ck/modules/payment/view/use_point.dart';
import 'package:lottery_ck/modules/pin/view/pin_verify.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:lottery_ck/utils/location.dart';
import 'package:pubnub/networking.dart';
import 'package:pubnub/pubnub.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentController extends GetxController {
  static PaymentController get to => Get.find();
  // List<Lottery> lotteryList = <Lottery>[];
  List<Bank> bankList = [];
  DateTime? lotteryDate;
  String? lotteryDateStrYMD;
  Bank? selectedBank;
  // bool isLoading = false;
  RxBool isLoading = false.obs;
  String? confirmOTP;
  String? otpRefNo;
  String? otpRefCode;
  String? transCashOutID;
  String? transID;
  int? point;
  int? pointMonney;
  StreamSubscription<String>? streamInvoice;
  Subscription? subscriptionPubnub;
  Subscription? subscriptionPubnubLDB;
  int routeLevel = 0;
  bool isOpenedDialog = false;
  List<Coupon> couponsList = [];
  int maxPercentPointCanuse = 0;
  bool isUsePoint = false;
  bool isCanUsePoint = false;
  List<Map> promotionList = [];
  List<Map> promotionBankList = [];
  List promotionActive = [];
  double? latitude;
  double? longitude;

  Future<void> getPosition() async {
    logger.w("start: getPosition");
    final stopwatch = Stopwatch()..start();
    final position = await LocationService.getCurrentLocation();
    stopwatch.stop();
    logger.f("stopwatch: getPosition ${stopwatch.elapsedMilliseconds} ms");
    latitude = position.latitude;
    longitude = position.longitude;
    logger.w("end: getPosition");
  }

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
    final bankList = await appwriteController.listBank();
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

  bool disableBank(Bank bank) {
    if (bank.name.toLowerCase() == "mmoney") {
      final totalAmount =
          BuyLotteryController.to.invoiceMeta.value.amount - (point ?? 0);
      const minimumPrice = 1000;
      // logger.d(totalAmount);
      // logger.d(minimumPrice);
      // logger.d("totalAmount < minimumPrice: ${totalAmount < minimumPrice}");
      if (totalAmount < minimumPrice) {
        return true;
      }
    }
    return false;
  }

  Future<void> setUpCouponAndPointAgain() async {
    final invoice = BuyLotteryController.to.invoiceMeta.value;
    if (invoice.couponIds == null) {
      return;
    }
    final couponIds = invoice.couponIds!.map((coupon) {
      return coupon.toString();
    }).toList();
    await applyCoupon(couponIds);
  }

  void checkCanUsePoint() {
    final invoice = BuyLotteryController.to.invoiceMeta.value;
    final user = UserController.to.user.value;
    if (user == null) {
      return;
    }
    logger.w("point: ${user.point}");
    logger.w("amount: ${invoice.amount}");
    if (user.point >= invoice.amount) {
      isCanUsePoint = true;
      update();
    }
  }

  Future<void> listPromotion() async {
    final user = UserController.to.user.value;
    if (user == null) return;
    final userGroups = await AppWriteController.to.listMyGroup(user.userId);
    // logger.w("userGroups: $userGroups");
    if (userGroups == null) {
      logger.e("can't list user groups: listGroup NotificationController");
      return;
    }
    final groupIds =
        userGroups.map((group) => group['\$id'] as String).toList();
    final promotionListData =
        await AppWriteController.to.listPromotions(groupIds);
    logger.w(promotionListData);
    if (promotionListData == null) return;
    // for (var promotion in promotionListData) {
    //   logger.w(promotion);
    // }
    // receive_type: register, friend, kyc
    final List<Map> promotionBankList = [];
    final filteredPromotionList = promotionListData.where((promotion) {
      if (promotion['bank'] != null) {
        promotionBankList.add(promotion);
      }
      final promotionType = promotion['receive_type'] as String;
      final ignoreReceiveType = ["register", "friend", "kyc", "bank"];
      return !ignoreReceiveType.contains(promotionType);
    }).toList();
    // logger.w(filteredPromotionList);
    promotionList = filteredPromotionList;
    this.promotionBankList = promotionBankList;
    // update();
  }

  void setup() async {
    isLoading.value = true;
    point = null;
    getPosition();
    setLotteryDate();
    await getBank();
    listenInvoiceExpire();
    // listMyCoupons();
    listPromotion();
    await getPoinCanUseOnInvoice();
    await setUpCouponAndPointAgain();
    // await clearPoint();
    checkCanUsePoint();
    isLoading.value = false;
    applyDefaultPromotion();
  }

  void applyDefaultPromotion() async {
    // applyPromotion
    final response = await applyPromotion(null);
    logger.w("onInit apply promotion: $response");
  }

  Future<void> clearPoint() async {
    final invoice = BuyLotteryController.to.invoiceMeta.value;
    if (invoice.point != null && invoice.point != 0) {
      Get.dialog(
        DialogApp(
          title: Text(
            AppLocale.clearPointTitle.getString(Get.context!),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          details: Text(AppLocale.clearPointDetail.getString(Get.context!)),
          disableConfirm: true,
          cancelText: Text(AppLocale.close.getString(Get.context!)),
        ),
      );
      await applyPoint(0, false);
    }
  }

  void listenInvoiceExpire() {
    streamInvoice = BuyLotteryController.to.invoiceRemainExpireStr.listen(
      (value) {
        if (value == "") {
          if (Get.isDialogOpen == true) {
            Get.back();
          }
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
    isLoading.value = true;
    // Get.to(
    //   PinVerifyPage(disabledBackButton: false),
    //   arguments: {
    //     "userId": LayoutController.to.userApp!.userId,
    //     "whenSuccess": () async {
    //       logger.d("boom !");
    //       Get.back();
    await createInvoice(bank);
    isLoading.value = false;
    // logger.d("should back !");
    //     }
    //   },
    // );
    // await Pin.verifyPin(
    //   context,
    //   () {
    //     logger.d("boom !");
    //     navigator?.pop();
    //     createInvoice(bank, totalAmount);
    //   },
    // );
  }

  void showBill(String invoiceId, [String? refCode]) async {
    try {
      final invoiceMeta = BuyLotteryController.to.invoiceMeta.value.copyWith();
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
        billId: invoiceDocuments.data['billNumber'] ?? "-",
        // invoiceId: invoiceMeta,
        bankName: selectedBank!.fullName,
        customerId: userApp.customerId!,
        refCode: refCode,
        discount: invoiceDocuments.data['discount'],
        point: invoiceDocuments.data['point'],
        pointMoney: invoiceDocuments.data['pointMoney'],
      );
      Get.toNamed(
        RouteName.bill,
        arguments: {
          "bill": bill,
          "onClose": () {
            // Get.offNamed(RouteName.layout);
            Get.back();
            Get.back();
          },
        },
      );
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  Future<void> subRealTimeLDB(String uuid, String invoiceId) async {
    // Create PubNub instance with default keyset.
    var pubnub = PubNub(
      defaultKeyset: Keyset(
        // publishKey: 'pub-c-ff681b02-4518-4dbd-a081-f98d1b2fcef6',
        // subscribeKey: 'sub-c-8ae0d87d-51b2-4f42-83b6-e201bb96d7bd',
        subscribeKey: 'sub-c-ccd836b1-b45e-488e-9960-d9ebc02a9078',
        userId: UserId(uuid),
      ),
    );
    const channel = "LDB0300100541";
    subscriptionPubnubLDB = pubnub.subscribe(channels: {channel});
    logger.w("start sub real-time LDB");
    subscriptionPubnubLDB?.presence.listen((event) {
      logger.w(event);
      logger.w(event.occupancy);
      logger.w(event.action);
    });
    subscriptionPubnubLDB?.messages.listen((message) {
      logger.w(message.content);
      showBill(invoiceId);
      BuyLotteryController.to.removeInvoiceWhenPaymentSuccess();
      subscriptionPubnubLDB?.dispose();
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
  }

  Future<void> subRealTime(String uuid, String invoiceId) async {
    try {
      // Create PubNub instance with default keyset.
      // publishKey: 'pub-c-ff681b02-4518-4dbd-a081-f98d1b2fcef6',
      // subscribeKey: 'sub-c-8ae0d87d-51b2-4f42-83b6-e201bb96d7bd',
      var pubnub = PubNub(
        networking: NetworkingModule(
          retryPolicy: RetryPolicy.exponential(maxRetries: 10),
        ),
        defaultKeyset: Keyset(
          subscribeKey: AppConst.pubNubSubscribeKeyBCEL,
          userId: const UserId(AppConst.pubNubUserIdBCEL),
        ),
      );

      // Subscribe to a channel
      const mcid = 'mch5c2f0404102fb';
      var channel = "uuid-$mcid-$uuid";
      subscriptionPubnub = pubnub.subscribe(channels: {channel});
      logger.d("channel: $channel");
      logger.d("subscription start: $invoiceId");
      Get.rawSnackbar(
        icon: const Icon(Icons.check),
        message: "subscription start: $invoiceId",
        backgroundColor: Colors.green,
        overlayColor: Colors.white,
      );
      // Print every message
      subscriptionPubnub?.messages.listen((message) {
        final contentJson = jsonDecode(message.content);
        logger.w(contentJson);
        final String? fccref = contentJson['fccref'];
        subscriptionPubnub?.dispose();
        showBill(invoiceId, fccref);
        BuyLotteryController.to.removeInvoiceWhenPaymentSuccess();
        // subscriptionPubnub?.unsubscribe();
        // subscriptionPubnub?.cancel();
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
            Get.dialog(
              DialogApp(
                title: Text("$error"),
                details: Text("$stackTrace"),
                disableConfirm: true,
              ),
            );
            LayoutController.to.snackBar(
              message: "$error",
            );
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
    } catch (e) {
      Get.dialog(
        DialogApp(
          title: const Text("error"),
          details: Text("$e"),
          disableConfirm: true,
        ),
      );
    }
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

  Future<void> createInvoice(Bank bank) async {
    try {
      if (bank.downtime != null) {
        final bankValid = validBank(bank);
        if (!bankValid) return;
      }
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
      isLoading.value = true;
      // final user = await AppWriteController.to.user;
      final userApp = UserController.to.user.value;
      if (userApp == null) throw "not found user please login";
      final storage = StorageController.to;
      final stopwatchGetSessionId = Stopwatch()..start();
      final sessionId = await storage.getSessionId();
      stopwatchGetSessionId.stop();
      logger.f(
          "stopwatch: getSessionId ${stopwatchGetSessionId.elapsedMilliseconds} ms");
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
        "lat": latitude,
        "long": longitude,
      };
      logger.w(payload);
      // const url =
      //     "https://a8d4-2405-9800-b920-2d16-41b3-6892-29cb-c9f3.ngrok-free.app/api/payment";
      final stopwatchAPI = Stopwatch()..start();
      final responseTransaction = await dio.post(
        // url,
        "${AppConst.apiUrl}/payment",
        data: payload,
        options: Options(
          headers: {
            "Authorization": "Bearer $bearer",
          },
        ),
      );
      stopwatchAPI.stop();
      logger.f("stopwatch: API ${stopwatchAPI.elapsedMilliseconds} ms");
      logger.w("responseTransaction");
      logger.w(responseTransaction.data);
      final result = responseTransaction.data['data'];
      if (bank.name == "bcel") {
        final payment = result['payment'];
        final invoiceMeta = result['invoiceMeta']['data'];
        final newExpire = DateTime.parse(invoiceMeta['expire']);
        final deeplink = payment['deeplink'];
        final uuid = payment['uuid'];
        logger.w("uuid: $uuid");
        await subRealTime(uuid!, invoiceMeta['invoiceId']);
        BuyLotteryController.to.invoiceMeta.value.billId = uuid;
        await launchUrl(Uri.parse('$deeplink'));
        BuyLotteryController.to.startCountDownInvoiceExpire(newExpire);
      }
      // if (bank.name == "ldb") {
      //   final canLaunch = await canLaunchUrl(Uri.parse("ldbpay://ldblao.la"));
      //   logger.w(canLaunch);
      //   if (canLaunch == false) {
      //     logger.d("in if");
      //     await launchUrl(Uri.parse(
      //         'https://play.google.com/store/apps/details?id=com.ldb.wallet'));
      //     return;
      //   }
      // }
      if (bank.name == "ldb") {
        try {
          final payment = result['payment'];
          final invoiceMeta = result['invoiceMeta']['data'];
          final newExpire = DateTime.parse(invoiceMeta['expire']);
          final deeplink = payment['dataResponse']['link'];
          final billId = payment['dataResponse']['billId'];
          // final canLaunch = await canLaunchUrl(Uri.parse("ldbpay://ldblao.la"));
          // logger.w(canLaunch);
          // if (canLaunch == false) {
          //   logger.d("in if");
          //   await launchUrl(Uri.parse(
          //       'https://play.google.com/store/apps/details?id=com.ldb.wallet'));
          //   return;
          // }
          // await Future.delayed(const Duration(seconds: 5));
          logger.d("launchUrl externalApplication");
          await launchUrl(
            Uri.parse('$deeplink'),
            mode: LaunchMode.externalApplication,
          );
          BuyLotteryController.to.startCountDownInvoiceExpire(newExpire);
          // subRealTimeLDB(billId, invoiceMeta['invoiceId']);
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
        isOpenedDialog = true;
        String? message;
        try {
          final dataMap = jsonDecode(e.response?.data['message']);
          message = dataMap['message'];
        } catch (e) {
          logger.e("error jsonDecode $e");
        }
        Get.dialog(
          DialogApp(
            disableConfirm: true,
            title: Text(
              AppLocale.somethingWentWrong.getString(Get.context!),
            ),
            details: Text(
              message ?? e.response?.statusMessage ?? "",
            ),
          ),
        ).whenComplete(
          () {
            isOpenedDialog = false;
          },
        );
        // Get.rawSnackbar(message: e.response?.statusMessage);
      }
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(
        message: "$e",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectBank(Bank bank) async {
    final lotteryDate =
        BuyLotteryController.to.invoiceMeta.value.lotteryDateStr;
    final invoiceId = BuyLotteryController.to.invoiceMeta.value.invoiceId!;
    final invoice = BuyLotteryController.to.invoiceMeta.value;
    final String? promotionId = invoice.promotionIds?.isEmpty == false
        ? invoice.promotionIds!.first
        : null;
    logger.w("promotionId: $promotionId");
    final response = await AppWriteController.to.applyPromotion(
      promotionId,
      invoiceId,
      lotteryDate,
      bank.$id,
    );

    logger.w(response.data);

    if (response.isSuccess == false) {
      Get.dialog(
        DialogApp(
          title: Text(AppLocale.somethingWentWrong.getString(Get.context!)),
          details: Text(
            response.message,
          ),
          disableConfirm: true,
        ),
      );
      return;
    }
    final result = response.data!['data'];
    logger.w(result);

    final invoiceRes = result['invoice'];
    final InvoiceMetaData invoiceClone =
        BuyLotteryController.to.invoiceMeta.value.copyWith();
    invoiceClone.amount = invoiceRes['amount'];
    invoiceClone.quota = invoiceRes['quota'];
    invoiceClone.bonus = invoiceRes['bonus'];
    invoiceClone.discount = invoiceRes['discount'];
    invoiceClone.totalAmount = invoiceRes['totalAmount'];
    // invoiceClone.transactions.clear();
    invoiceClone.couponIds = invoiceRes['couponId'];
    final point = invoiceRes['receive_point'] as int?;
    invoiceClone.receivePoint = point;
    final pointBank = invoiceRes['pointBank'];
    if (pointBank is num) {
      invoiceClone.pointBank = pointBank.toInt();
    }

    BuyLotteryController.to.setInvoice(invoiceClone);

    selectedBank = bank;
    update();
  }

  bool get enablePay => selectedBank != null;

  Future<void> onChangePointSwitch(bool value) async {
    if (value == false) {
      await applyPoint(0);
      applyDefaultPromotion();
      return;
    }
    final invoice = BuyLotteryController.to.invoiceMeta.value;
    await applyPoint(invoice.quota);
  }

  Future<void> applyPoint(int usePoint, [bool isShowNoti = true]) async {
    final invoice = BuyLotteryController.to.invoiceMeta.value;
    final invoiceId = invoice.invoiceId!;
    final lotteryDateStr = invoice.lotteryDateStr;
    // logger.w("usePoint: $usePoint");
    final response = await AppWriteController.to
        .applyPoint(invoiceId, lotteryDateStr, usePoint);
    // logger.w(response.data);
    if (response.isSuccess == false) {
      Get.dialog(
        DialogApp(
          title: Text(
            AppLocale.somethingWentWrong.getString(Get.context!),
          ),
          details: Text(
            response.message,
          ),
          disableConfirm: true,
        ),
      );
      return;
    }
    final result = response.data!['data'];
    final invoiceRes = result['invoice'];

    final InvoiceMetaData invoiceClone =
        BuyLotteryController.to.invoiceMeta.value.copyWith();
    invoiceClone.amount = invoiceRes['amount'];
    invoiceClone.quota = invoiceRes['quota'];
    invoiceClone.bonus = invoiceRes['bonus'];
    invoiceClone.discount = invoiceRes['discount'];
    invoiceClone.totalAmount = invoiceRes['totalAmount'];
    invoiceClone.promotionIds = invoiceRes['promotionId'];
    // invoiceClone.transactions.clear();
    invoiceClone.couponIds = invoiceRes['couponId'];
    final receivePoint = invoiceRes['receive_point'] as int?;
    invoiceClone.receivePoint = receivePoint;
    invoiceClone.point = invoiceRes['point'];
    invoiceClone.pointMoney = invoiceRes['pointMoney'];

    invoiceClone.discount = invoiceRes['discount'];
    invoiceClone.bonus = invoiceRes['bonus'];
    invoiceClone.amount = invoiceRes['amount'];
    invoiceClone.totalAmount = invoiceRes['totalAmount'];
    final pointBank = invoiceRes['pointBank'];
    if (pointBank is num) {
      invoiceClone.pointBank = pointBank.toInt();
    }
    // final List transactions = result['transaction'];
    // for (var transaction in transactions) {
    //   invoiceClone.transactions.add(
    //     Lottery.fromJson(transaction),
    //   );
    // }
    BuyLotteryController.to.setInvoice(invoiceClone);
    update();

    // final message = AppLocale.youHaveUsedPoints
    //     .getString(Get.context!)
    //     .replaceAll("{point}", "$usePoint");
    // invoice.point = result['invoice']['point'];
    // invoice.pointMoney = result['invoice']['pointMoney'];
    onChangePoint(usePoint);
    // if (isShowNoti) {
    //   Future.delayed(const Duration(milliseconds: 350), () {
    //     Get.rawSnackbar(
    //       messageText: Text(
    //         message,
    //         style: const TextStyle(
    //           color: Colors.white,
    //         ),
    //       ),
    //       backgroundColor: Colors.green,
    //     );
    //   });
    // }
    // if (invoice.couponIds?.isNotEmpty == true) {
    //   invoice.discount = result['invoice']['discount'];
    //   invoice.bonus = result['invoice']['bonus'];
    //   invoice.amount = result['invoice']['amount'];
    //   invoice.totalAmount = result['invoice']['totalAmount'];
    //   // final coupons =
    //   //     invoice.couponIds!.map((coupon) => coupon as String).toList();
    //   // applyCoupon(coupons);
    // }
  }

  void showBottomModalPoint(BuildContext context) {
    final int myPoint = UserController.to.user.value?.point != null
        ? UserController.to.user.value!.point
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
          onSubmit: (usePoint) async {
            await applyPoint(usePoint);
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
    final user = UserController.to.user.value;
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
      final promotionListMap = responsePromotionsList.data!.where(
        (promotion) {
          return promotion['\$id'] == coupon.promotionId;
        },
      );
      if (promotionListMap.isNotEmpty) {
        coupon.promotion = promotionListMap.first;
      }
    }
    logger.d(responsePromotionsList.data);
    couponsList = coupons.where((coupon) => coupon.promotion != null).toList();
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

  void gotoPromotionPage() {
    isOpenedDialog = true;
    final invoice = BuyLotteryController.to.invoiceMeta.value;
    logger.w(invoice.promotionIds);
    Get.to(
      () => PromotionListPage(
        promotionList: promotionList,
        selectedPromotionIds: invoice.promotionIds,
      ),
    )?.whenComplete(
      () {
        isOpenedDialog = false;
      },
    );
  }

  Future<bool> applyPromotion(String? promotionId) async {
    logger.w("promotionId: $promotionId");
    final invoice = BuyLotteryController.to.invoiceMeta.value;
    if (invoice.invoiceId == null) {
      return false;
    }
    final response = await AppWriteController.to.applyPromotion(
      promotionId,
      invoice.invoiceId!,
      invoice.lotteryDateStr,
      selectedBank?.$id,
    );
    logger.w("response applyPromotion");
    logger.d(response.data);
    onChangePoint(0);
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
          disableConfirm: true,
        ),
      );
      return false;
    }
    final data = response.data!['data'];
    // final exPromotionActive = {
    //   "promotionActive": [
    //     {"promotionId": "680b3ec600369b7de577", "canUse": false},
    //     {"promotionId": "67d3a3d10015cd0719dc", "canUse": true}
    //   ],
    // };
    final promotionActive = data['promotionActive'];
    this.promotionActive = promotionActive;
    final invoiceRes = data['invoice'];

    final InvoiceMetaData invoiceClone =
        BuyLotteryController.to.invoiceMeta.value.copyWith();
    invoiceClone.amount = invoiceRes['amount'];
    invoiceClone.quota = invoiceRes['quota'];
    invoiceClone.bonus = invoiceRes['bonus'];
    invoiceClone.discount = invoiceRes['discount'];
    invoiceClone.totalAmount = invoiceRes['totalAmount'];
    invoiceClone.promotionIds = invoiceRes['promotionId'];
    // invoiceClone.transactions.clear();
    invoiceClone.couponIds = invoiceRes['couponId'];
    final point = invoiceRes['receive_point'] as int?;
    invoiceClone.receivePoint = point;
    final pointBank = invoiceRes['pointBank'];
    if (pointBank is num) {
      invoiceClone.pointBank = pointBank.toInt();
    }
    // final List transactions = result['transaction'];
    // for (var transaction in transactions) {
    //   invoiceClone.transactions.add(
    //     Lottery.fromJson(transaction),
    //   );
    // }
    BuyLotteryController.to.setInvoice(invoiceClone);
    update();
    return true;
  }

  Future<void> applyCoupon(List<String> couponIdsList) async {
    logger.d(lotteryDateStrYMD);
    final lotteryDate = lotteryDateStrYMD;
    final invoiceId = BuyLotteryController.to.invoiceMeta.value.invoiceId;
    logger.w("invoiceId: $invoiceId log");
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
      bankId: selectedBank?.$id,
    );
    logger.w(response.data);
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
    final responseCoupon = result['coupon'];
    if (responseCoupon is List) {
      if (responseCoupon.isNotEmpty) {
        final response = responseCoupon.first;
        BuyLotteryController.to.invoiceMeta.value.couponResponse =
            CouponResponse.fromJson(
          response,
        );
      } else {
        BuyLotteryController.to.invoiceMeta.value.couponResponse = null;
      }
    }
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
    final point = invoiceRes['receive_point'] as int?;
    invoice.receivePoint = point;
    final List transactions = result['transaction'];
    for (var transaction in transactions) {
      invoice.transactions.add(
        Lottery.fromJson(transaction),
      );
    }
    BuyLotteryController.to.setInvoice(invoice);
    update();
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

  void showCouponDetailInCouponPage(BuildContext context, Coupon coupon) {
    isOpenedDialog = true;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CouponDetail(
          coupon: coupon,
        );
      },
    ).whenComplete(
      () {
        isOpenedDialog = false;
      },
    );
  }

  void showPromotionDetail(BuildContext context, Map promotion) {
    isOpenedDialog = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return PromotionDetail(promotion: promotion);
      },
    ).whenComplete(
      () {
        isOpenedDialog = false;
      },
    );
  }

  void showCouponDetail(BuildContext context) {
    final invoice = BuyLotteryController.to.invoiceMeta.value;
    if (invoice.couponIds?.isEmpty == true) {
      logger.e("invoice.couponIds?.isEmpty == true");
      return;
    }
    final coupon = couponsList.where(
      (coupon) {
        return coupon.couponId == invoice.couponIds!.first;
      },
    ).toList();
    if (coupon.isEmpty) {
      logger.e("coupon.isEmpty");
      return;
    }
    isOpenedDialog = true;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CouponDetail(
          coupon: coupon.first,
        );
      },
    ).whenComplete(
      () {
        isOpenedDialog = false;
      },
    );
  }

  void showRemoveCouponModal(BuildContext context) async {
    isOpenedDialog = true;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CouponRemove(
          onConfirm: () {
            applyCoupon([]);
            Get.back();
          },
          onCancel: () {
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

  void showCannotBeUsedPoint(BuildContext context) {
    isOpenedDialog = true;
    Get.dialog(
      DialogApp(
        title: Text(
          AppLocale.pointsCannotBeUsedInThisOrder.getString(context),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        details: Text(
          AppLocale.pointCannotBeUsedDetail.getString(context),
          textAlign: TextAlign.center,
        ),
        disableConfirm: true,
      ),
    ).whenComplete(
      () {
        isOpenedDialog = false;
      },
    );
  }

  void removeInvoiceWhenBack() {
    BuyLotteryController.to.removeAllLottery(
      isKeepTransaction: true,
    );
  }

  bool isCanUse(String promotionId) {
    promotionActive;
    final result = promotionActive
        .where((promotion) => promotion['promotionId'] == promotionId)
        .toList();
    if (result.isEmpty) {
      return false;
    }
    return result.first['canUse'];
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
    subscriptionPubnubLDB?.dispose();
    super.onClose();
  }
}
