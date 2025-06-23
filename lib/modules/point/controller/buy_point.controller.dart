import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/model/point_topup.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/point/view/bill_point.dart';
import 'package:lottery_ck/modules/point/view/payment_method.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:pubnub/networking.dart';
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
  bool isLoadingPoint = true;
  List<Bank> bankList = [];
  Bank? selectedBank;
  int selectedPointList = 0;
  Subscription? subscriptionPubnub;
  RxBool isLoading = false.obs;

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
      networking: NetworkingModule(
        retryPolicy: RetryPolicy.exponential(maxRetries: 10),
      ),
      defaultKeyset: Keyset(
        subscribeKey: AppConst.pubNubSubscribeKeyBCEL,
        userId: const UserId(AppConst.pubNubUserIdBCEL),
      ),
    );

    // Subscribe to a channel
    const mcid = AppConst.mcid;
    var channel = "uuid-$mcid-$uuid";
    subscriptionPubnub = pubnub.subscribe(channels: {channel});
    logger.d("channel: $channel");
    Get.rawSnackbar(
      icon: const Icon(Icons.check),
      message: "subscription start: $uuid",
      backgroundColor: Colors.green,
      overlayColor: Colors.white,
    );
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
      // SettingController.to.getPoint();
      UserController.to.reLoadUser("buy point con 118");
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
    try {
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
      isLoading.value = true;

      final response = await AppWriteController.to.topup(
        pointWantToBuy!,
        selectedBank!.$id,
        UserController.to.user.value!.userId,
      );
      logger.w("buy_point.controller.dart:147");
      logger.d(response.data);
      final result = response.data?['data'];
      if (selectedBank?.name == "bcel") {
        final payment = result['payment'];
        final deeplink = payment['deeplink'];
        final uuid = payment['uuid'];
        try {
          await launchUrl(Uri.parse('$deeplink'));
        } catch (e) {
          if (Platform.isAndroid) {
            await launchUrl(Uri.parse(
                "https://play.google.com/store/apps/details?id=com.bcel.bcelone"));
          } else if (Platform.isIOS) {
            await launchUrl(Uri.parse(
                "https://apps.apple.com/th/app/bcel-one/id654946527"));
          }
          return;
        }

        subRealTime(uuid!);
      } else if (selectedBank?.name == "ldb") {
        final payment = result['payment'];
        logger.w("payment:186");
        logger.d(payment);
        final deeplink = payment['dataResponse']['link'];
        try {
          await launchUrl(Uri.parse(deeplink));
        } catch (e) {
          if (Platform.isAndroid) {
            await launchUrl(Uri.parse(
                "https://play.google.com/store/apps/details?id=com.ldb.wallet"));
          } else if (Platform.isIOS) {
            await launchUrl(Uri.parse(
                "https://apps.apple.com/th/app/ldb-trust/id1496733309"));
          }
          return;
        }
      }
    } catch (e) {
      logger.e(e);
    } finally {
      isLoading.value = false;
    }
  }

  void setIsLoadingPoint(bool value) {
    isLoadingPoint = value;
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
    this.bankList = bankList.where((bank) => bank.name != "mmoney").toList();
    // this.bankList = bankList;
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
    setIsLoadingPoint(false);
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
