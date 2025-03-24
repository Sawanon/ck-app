import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/model/bank.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/point/view/payment_method.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

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

  void submitBuyPoint() async {
    logger.d("point: $pointWantToBuy");
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
    this.bankList = bankList.where((bank) => bank.name == "mmoney").toList();
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
}
