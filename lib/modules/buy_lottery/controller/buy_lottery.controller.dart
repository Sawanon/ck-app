import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class BuyLotteryController extends GetxController {
  static BuyLotteryController get to => Get.find();
  GlobalKey<FormState>? formKey = GlobalKey();
  FocusNode priceNode = FocusNode();
  FocusNode lotteryNode = FocusNode();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController lotteryTextController = TextEditingController();

  String? lottery;
  int? price;

  RxBool isUserLoggedIn = false.obs;
  RxList<Lottery> lotteryList = <Lottery>[].obs;
  final totalAmount = 0.obs;

  bool get lotteryIsEmpty => lotteryList.isEmpty;
  late StreamSubscription<bool> keyboardSubscription;

  void gotoLoginPage() {
    Get.toNamed(RouteName.login);
  }

  void onFucusTextInput(bool isFocus) {
    final layoutController = LayoutController.to;
    final homeController = HomeController.to;
    if (isFocus) {
      layoutController.removePaddingBottom();
      homeController.lotteryFullScreen();
      return;
    }
    layoutController.resetPaddingBottom();
    homeController.lotteryResetScreen();
  }

  void onFocus() {
    onFucusTextInput(priceNode.hasFocus || lotteryNode.hasFocus);
  }

  void setupNode() {
    priceNode.addListener(onFocus);
    lotteryNode.addListener(onFocus);
  }

  void addLottery(String lottery, int price) {
    try {
      final findLottery = lotteryList.where(
        (data) {
          return data.lottery == lottery;
        },
      ).toList();
      logger.d(findLottery.length);
      if (findLottery.isNotEmpty) {
        final currentLottery = findLottery[0];
        final total = currentLottery.price + price;
        currentLottery.price = total;
        update();
      } else {
        lotteryList.add(Lottery(lottery: lottery, price: price));
      }
      calculateTotalAmount();
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: '$e');
    }
  }

  void calculateTotalAmount() {
    final total = CommonFn.calculateTotalPrice(lotteryList);
    totalAmount.value = total;
  }

  void removeLottery(String lottery) {
    lotteryList.removeWhere((data) => data.lottery == lottery);
    calculateTotalAmount();
  }

  void removeAllLottery() {
    lotteryList.clear();
    calculateTotalAmount();
  }

  void submitAddLottery(String? lottery, int? price) {
    if (formKey?.currentState != null && formKey!.currentState!.validate()) {
      if (lottery == null || price == null) {
        alertLotteryEmpty();
        alertPrice();
        return;
      }
      final valid = validateLottery(lottery, price);
      if (valid) {
        addLottery(lottery, price);
        lotteryNode.requestFocus();
      }
    }
  }

  bool validateLottery(String lottery, int price) {
    try {
      if (price < 1000) {
        throw "ໃສ່ລາຄາຕໍ່າສຸດ 1000";
      }
      if (lottery.length < 2 || lottery.length > 3) {
        throw "ກະລຸນາຊື້ 2-3 ຕໍາແຫນ່ງ.";
      }
      return true;
    } catch (e) {
      logger.w(e.toString());
      alertPrice(e.toString());
      return false;
    }
  }

  void alertPrice([String? title]) {
    if (!Get.isSnackbarOpen) {
      Get.rawSnackbar(
        messageText: Text(
          title ?? "ກະລຸນາໃສ່ລາຄາ.",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
      // Get.snackbar(
      //   title ?? "ກະລຸນາໃສ່ລາຄາ.",
      //   '',
      //   messageText: Container(),
      //   backgroundColor: AppColors.primary.withOpacity(0.7),
      //   colorText: Colors.white,
      // );
    }
  }

  void alertLotteryEmpty([String? title]) {
    if (!Get.isSnackbarOpen) {
      Get.rawSnackbar(
        messageText: Text(
          "Please enter lottery",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.errorBorder,
        overlayColor: Colors.white,
      );
    }
  }

  void confirmLottery(BuildContext context) async {
    if (lotteryList.isEmpty) {
      Get.rawSnackbar(message: "Please add lottery");
      return;
    }
    try {
      await AppWriteController.to.user;
    } on Exception catch (e) {
      logger.e("$e");
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "ກະລຸນາເຂົ້າສູ່ລະບົບ",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "ກະລຸນາເຂົ້າສູ່ລະບົບກ່ອນທີ່ຈະຊື້ຫວຍ.",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LongButton(
                      onPressed: () {
                        navigator?.pop();
                        gotoLoginPage();
                        formKey = null;
                      },
                      child: Text(
                        "LOG IN",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
      Get.rawSnackbar(message: "Please sign in");
      return;
    }
    Get.toNamed(RouteName.payment);
  }

  void clearLottery() {
    priceTextController.clear();
    lotteryTextController.clear();
    priceNode.unfocus();
    lotteryNode.unfocus();
    removeAllLottery();
    // totalAmount.value = 0;
    // lotteryList.clear();
  }

  void onChangePrice(String price) {
    if (price.isEmpty) {
      this.price = null;
      return;
    }
    this.price = int.parse(price);
  }

  @override
  void onInit() {
    // checkUser();
    setupNode();
    keyboardSubscription = KeyboardVisibilityController().onChange.listen(
      (event) {
        onFucusTextInput(event);
      },
    );
    super.onInit();
  }

  @override
  void onClose() {
    keyboardSubscription.cancel();
    super.onClose();
  }
}
