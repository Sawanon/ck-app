import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/point_topup.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/point/view/bill_point.dart';
import 'package:lottery_ck/modules/point/view/payment_method.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:pubnub/pubnub.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyPointController extends GetxController {
  Map<String, List<int>> pointList = {
    "1": [1000, 3000, 5000],
    "2": [10000, 30000, 50000],
  };
  int? pointWantToBuy;
  TextEditingController pointInpuController = TextEditingController();
  int pointRaio = 1;
  bool isLoading = true;
  List<Bank> bankList = [];
  Bank? selectedBank;
  int selectedPointList = 0;
  Subscription? subscriptionPubnub;

  void onClickPointList(int point) {
    selectedPointList = point;
    update();
  }

  void onChangePoint(String point) {
    if (point == "") {
      pointInpuController.text = "";
      pointWantToBuy = null;
      // clear focus
      selectedPointList = 0;
      update();
      return;
    }
    final pointInt = int.parse(point);
    pointInpuController.text = CommonFn.parseMoney(pointInt);
    pointWantToBuy = pointInt;
    // clear focus
    selectedPointList = 0;
    update();
  }

  Future<void> subRealTime(String uuid) async {
    // Create PubNub instance with default keyset.
    // publishKey: 'pub-c-ff681b02-4518-4dbd-a081-f98d1b2fcef6',
    // subscribeKey: 'sub-c-8ae0d87d-51b2-4f42-83b6-e201bb96d7bd',
    var pubnub = PubNub(
      defaultKeyset: Keyset(
        subscribeKey: 'sub-c-91489692-fa26-11e9-be22-ea7c5aada356',
        userId: const UserId('BCELBANK'),
      ),
    );

    // Subscribe to a channel
    const mcid = 'mch5c2f0404102fb';
    var channel = "uuid-$mcid-$uuid";
    subscriptionPubnub = pubnub.subscribe(channels: {channel});
    logger.d("channel: $channel");
    // Print every message
    subscriptionPubnub?.messages.listen((message) async {
      final contentJson = jsonDecode(message.content);
      logger.w(contentJson);
      // final String? fccref = contentJson['fccref'];
      final response = await AppWriteController.to.getPointTopup(uuid);
      logger.w("key data");
      logger.d(response.toJson());
      if (response.isSuccess == false || response.data == null) {
        Get.dialog(
          DialogApp(
            title: Text("Can't get point transaction data"),
            details: Text(
              response.message,
            ),
            disableConfirm: true,
          ),
        );
        return;
      }
      Get.dialog(
        BillPoint(
          pointTop: response.data!,
          onBackHome: () {
            Get.back();
            Get.back();
          },
          onBuyAgain: () {
            Get.back();
          },
        ),
      );
      SettingController.to.getPoint();
      subscriptionPubnub?.dispose();
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
        },
      );
  }

  void submitBuyPoint() async {
    logger.d("point: $pointWantToBuy");
    if (pointWantToBuy == null) {
      Get.dialog(
        DialogApp(
          title: Text(
            AppLocale.somethingWentWrong.getString(Get.context!),
          ),
          details: Text(
            "Please select point",
          ),
        ),
      );
      return;
    }
    if (selectedBank == null) {
      Get.dialog(
        DialogApp(
          title: Text(
            AppLocale.somethingWentWrong.getString(Get.context!),
          ),
          details: Text(
            "Please select bank",
          ),
        ),
      );
      return;
    }
    if (pointWantToBuy! < 1000) {
      Get.dialog(
        DialogApp(
          title: Text(
            AppLocale.somethingWentWrong.getString(Get.context!),
          ),
          details: Text(
            "Minimum point is 1000",
          ),
        ),
      );
      return;
    }
    final response = await AppWriteController.to.topup(
      pointWantToBuy!,
      selectedBank!.$id,
      SettingController.to.user!.userId,
    );
    logger.w("buy_point.controller.dart:147");
    logger.d(response.data);
    final result = response.data?['data'];
    if (selectedBank?.name == "bcel") {
      final payment = result['payment'];
      final deeplink = payment['deeplink'];
      final uuid = payment['uuid'];
      logger.w("uuid: $uuid");
      await launchUrl(Uri.parse('$deeplink'));

      subRealTime(uuid!);
    }
  }

  void setIsLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> getPointRaio() async {
    final response = await AppWriteController.to.getPointRaio();
    logger.w(response);
    logger.w(response.data);
    if (response.isSuccess == false || response.data == null) {
      logger.w(response.message);
      logger.w(response.data);
      return;
    }
    pointRaio = (1000 / response.data!).round();
  }

  Future<void> listBank() async {
    final bankList = await AppWriteController.to.listBank();
    if (bankList == null) {
      Get.dialog(
        DialogApp(
          title: Text(
            AppLocale.somethingWentWrong.getString(Get.context!),
          ),
          details: Text(
            "Can't get bank list",
          ),
        ),
      );
      return;
    }
    // this.bankList = bankList.where((bank) => bank.name == "mmoney").toList();
    this.bankList = bankList;
  }

  void gotoPaymentMethod() async {
    Get.to(
      () => const PaymentMethod(),
    );
  }

  void selectBank(Bank bank) async {
    selectedBank = bank;
    Get.back();
    update();
  }

  void setup() async {
    await getPointRaio();
    await listBank();
    // pointRaio = (1000 / 100).round();
    setIsLoading(false);
    update();
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }

  @override
  void onClose() {
    subscriptionPubnub?.dispose();
    super.onClose();
  }
}
