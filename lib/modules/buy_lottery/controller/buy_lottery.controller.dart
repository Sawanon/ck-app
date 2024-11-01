import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/model/buy_lottery_configs.dart';
import 'package:lottery_ck/model/invoice_meta.dart';
import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/model/response_add_transaction.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/mmoney/controller/confirm_otp.controller.dart';
import 'package:lottery_ck/modules/mmoney/view/confirm_otp.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class BuyLotteryController extends GetxController {
  static BuyLotteryController get to => Get.find();
  GlobalKey<FormState>? formKey = GlobalKey();
  FocusNode priceNode = FocusNode();
  FocusNode lotteryNode = FocusNode();
  TextEditingController priceTextController = TextEditingController();
  TextEditingController lotteryTextController = TextEditingController();
  List<BuyLotteryConfigs> buyLotteryConfigs = [];
  Rx<InvoiceMetaData> invoiceMeta = InvoiceMetaData.empty().obs;

  RxBool isLoadingAddLottery = false.obs;
  RxList promotionList = [].obs;
  UserApp? userApp;
  int parentTab = 0;
  Timer? _timer;
  Rx<Duration> invoiceRemainExpire = Duration.zero.obs;
  RxString invoiceRemainExpireStr = "".obs;

  String? lottery;
  int? price;

  RxBool isUserLoggedIn = false.obs;
  RxList<Lottery> lotteryList = <Lottery>[].obs;
  final totalAmount = 0.obs;

  bool get lotteryIsEmpty => lotteryList.isEmpty;
  late StreamSubscription<bool> keyboardSubscription;
  Map<String, dynamic>? quotaMap;
  RxBool disabledBuy = true.obs;

  void enableBuy() {
    disabledBuy.value = false;
  }

  void disableBuy() {
    disabledBuy.value = true;
  }

  void gotoLoginPage() {
    Get.toNamed(RouteName.login);
  }

  void chnageParentTab(int index) {
    parentTab = index;
    update();
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

  void startCountDownInvoiceExpire(DateTime expire) {
    final currentDateTime = DateTime.now();
    invoiceRemainExpire.value = expire.difference(currentDateTime);
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (invoiceRemainExpire.value.inSeconds > 0) {
          invoiceRemainExpire.value -= const Duration(seconds: 1);
          invoiceRemainExpireStr.value =
              "${invoiceRemainExpire.value.inMinutes.remainder(60).toString().padLeft(2, '0')}:${invoiceRemainExpire.value.inSeconds.remainder(60).toString().padLeft(2, '0')}";
          // logger.d("run ! ${remainingDateTime.value.inSeconds}");
          return;
        }
        invoiceRemainExpireStr.value = "";
        logger.e("stop !");
        clearInvoice();
        enableResendOTPPayment();
        timer.cancel();
      },
    );
  }

  void clearInvoice() {
    invoiceMeta.value = InvoiceMetaData.empty();
  }

  void enableResendOTPPayment() {
    try {
      MonneyConfirmOTPController.to.enableResendOTP();
    } catch (e) {
      logger.e("$e");
    }
  }

  bool lotteryIsValid(Lottery lottery) {
    final buyLotteryConfig = buyLotteryConfigs
        .where(
          (buyLotteryConfig) =>
              buyLotteryConfig.lotteryType == lottery.lotteryType,
        )
        .toList();
    logger.d("buyLotteryConfig: $buyLotteryConfig");
    int total = lottery.amount;
    final existTransaction = invoiceMeta.value.transactions
        .where((element) => element.lottery == lottery.lottery)
        .toList();
    if (existTransaction.isNotEmpty) {
      total = existTransaction.first.amount + total;
    }

    if (buyLotteryConfig.isNotEmpty) {
      final config = buyLotteryConfig.first;
      if (config.max != null) {
        if (config.max! <= total) {
          // TODO: change to dialog
          Get.dialog(
            DialogApp(
              title: Text(
                AppLocale.exceededQuota.getString(Get.context!),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              details: Text(
                AppLocale.pleaseBuyMax
                    .getString(Get.context!)
                    .replaceAll("{max}", "${config.max}"),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),
              disableConfirm: true,
            ),
          );
          return false;
        }
        if (config.min! > lottery.amount) {
          Get.dialog(
            DialogApp(
              title: Text(
                AppLocale.lessThanQuota.getString(Get.context!),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              details: Text(
                AppLocale.pleaseBuyMax
                    .getString(Get.context!)
                    .replaceAll("{max}", "${config.min}"),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),
              disableConfirm: true,
            ),
          );
          return false;
        }
      }
    }
    return true;
  }

  // Future<Map?> addTransaction(Lottery transaction) async {
  Future<Map?> addTransaction(InvoiceMetaData invoiceMeta) async {
    try {
      isLoadingAddLottery.value = true;
      final dio = Dio();
      final token = await AppWriteController.to.getCredential();
      logger.d("payload");
      final payload = invoiceMeta.toJson(userApp!.userId);
      logger.d(payload);
      final response = await dio.post(
        "${AppConst.apiUrl}/transaction",
        data: payload,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        if (e.response?.data is Map) {
          handleErrorAddTransaction(e.response?.data);
        }
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
      }
      return null;
    } catch (e) {
      logger.e("$e");
      return null;
    } finally {
      isLoadingAddLottery.value = false;
    }
  }

  void handleErrorAddTransaction(Map errorData) {
    final String message = errorData['message'];
    if (message.toLowerCase() == "emergency stop") {
      HomeController.to.getLotteryDate();
      Get.dialog(
        DialogApp(
          title: const Text(
            "Error",
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          details: Text(message),
          disableConfirm: true,
        ),
      );
    }
  }

  void calculateTotalAmount() {
    final total = CommonFn.calculateTotalPrice(invoiceMeta.value.transactions);
    invoiceMeta.value.amount = total;
    invoiceMeta.value.totalAmount = total;
    invoiceMeta.value.bonus = null;
    calPromotion();
  }

  void calculatePreTotalAmount(InvoiceMetaData invoiceMetaData) {
    final total = CommonFn.calculateTotalPrice(invoiceMetaData.transactions);
    invoiceMetaData.amount = total;
    invoiceMetaData.totalAmount = total;
    invoiceMetaData.bonus = null;
    calPrePromotion(invoiceMetaData);
  }

//FIXME: how to remove api transaction invoice meta
  void _removeLottery(String lottery) {
    lotteryList.removeWhere((data) => data.lottery == lottery);
    calculateTotalAmount();
  }

  void removeLottery(Lottery lottery) async {
    logger.d(lottery.toJson());
    final cloneInvoice = invoiceMeta.value.copyWith();
    // remove only one transaction
    cloneInvoice.transactions = [lottery];
    final removedInvoice = await fakeRemoveLotteryWithAPI(cloneInvoice);
    if (removedInvoice == null) {
      Get.rawSnackbar(message: "delete lottery failed");
      return;
    }
    calculatePreTotalAmount(removedInvoice);
    logger.w(removedInvoice.toJson(userApp!.userId));
    invoiceMeta.value = removedInvoice;
  }

  Future<InvoiceMetaData?> fakeRemoveLotteryWithAPI(
      InvoiceMetaData invoiceMeta) async {
    try {
      List<Lottery> toRemove = [];
      logger.d(invoiceMeta.toJson(userApp!.userId));
      for (var transaction in invoiceMeta.transactions) {
        toRemove.add(transaction);
      }
      invoiceMeta.transactions
          .removeWhere((element) => toRemove.contains(element));
      return invoiceMeta;
    } catch (e) {
      return null;
    }
  }

  void _removeAllLottery() {
    lotteryList.clear();
    calculateTotalAmount();
  }

  void removeAllLottery() {
    invoiceMeta.value = InvoiceMetaData.empty();
    invoiceRemainExpireStr.value = "";
    _timer?.cancel();
  }

  void showInvalidPrice() {
    Get.rawSnackbar(
      backgroundColor: Colors.amber,
      messageText: Text(
        AppLocale.amountNotCorrect.getString(Get.context!),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void submitAddLottery(String? lottery, int? price) async {
    logger.d("formKey?.currentState: ${formKey?.currentState}");
    if (userApp == null) {
      showLoginDialog();
      return;
    }
    if (formKey?.currentState != null && formKey!.currentState!.validate()) {
      if (lottery == null || price == null) {
        alertLotteryEmpty();
        alertPrice();
        return;
      }
      if (price % 1000 != 0) {
        showInvalidPrice();
        return;
      }
      final valid = validateLottery(lottery, price);
      if (valid) {
        final lotteryData = Lottery(
          lottery: lottery,
          amount: price,
          lotteryType: lottery.length,
          quota: price,
          totalAmount: price,
        );
        await createTransaction([lotteryData]);
        lotteryNode.requestFocus();
      }
    }
  }

  bool validateLottery(String lottery, int price) {
    try {
      if (price < 1000) {
        throw "ໃສ່ລາຄາຕໍ່າສຸດ 1000";
      }
      if (quotaMap?['${lottery.length}'] == "0") {
        throw AppLocale.disableLotteryType
            .getString(Get.context!)
            .replaceAll("{lotteryType}", "${lottery.length}");
      }
      // if (lottery.length < 2 || lottery.length > 3) {
      //   throw "ກະລຸນາຊື້ 2-3 ຕໍາແຫນ່ງ.";
      // }
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

  void showLoginDialog() {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
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
                      "ເຂົ້າສູ່ລະບົບ",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void confirmLottery(BuildContext context) async {
    if (invoiceMeta.value.transactions.isEmpty) {
      Get.rawSnackbar(message: "Please add lottery");
      return;
    }
    try {
      await AppWriteController.to.user;
    } on Exception catch (e) {
      logger.e("$e");
      if (context.mounted) {
        showLoginDialog();
      }
      Get.rawSnackbar(message: "Please sign in");
      return;
    }

    if (HomeController.to.lotteryDateStr == null) {
      Get.rawSnackbar(message: "ขณะนี้ยังไม่เปิดบริการให้ซือในขณะนี้");
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
      priceTextController.text = "";
      return;
    }
    final onlyNumber = price.replaceAll(",", "");
    final priceInt = int.parse(onlyNumber);
    priceTextController.text = CommonFn.parseMoney(priceInt);
    this.price = priceInt;
  }

  void gotoAnimalPage() {
    Get.toNamed(
      RouteName.animal,
      arguments: [onClickAnimalBuy, disabledBuy.value],
    );
  }

  void showDialogCloseSale() {
    Get.dialog(
      DialogApp(
        title: Text(
          AppLocale.closeSale.getString(Get.context!),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        disableConfirm: true,
      ),
    );
  }

  void onClickAnimalBuy(List<Map<String, dynamic>> lotteryMapList) async {
    logger.d("callback");
    if (disabledBuy.value) {
      Future.delayed(const Duration(milliseconds: 250), () {
        showDialogCloseSale();
      });
      return;
    }
    if (userApp == null) {
      // delay after back from animal page
      Future.delayed(const Duration(milliseconds: 250), () {
        showLoginDialog();
      });
      return;
    }
    final lotteryList = lotteryMapList
        .map(
          (lottery) => Lottery(
            lottery: lottery['lottery'],
            amount: int.parse(lottery['price']),
            lotteryType: lottery['lottery'].length,
            quota: int.parse(lottery['price']),
            totalAmount: int.parse(lottery['price']),
          ),
        )
        .toList();
    createTransaction(lotteryList);
  }

  Future<void> createTransaction(List<Lottery> lotteryList) async {
    // logger.d("run in function");
    // lotteryList.forEach((e) {
    //   logger.w(e.toJson());
    // });
    // return;
    if (lotteryList.isEmpty) {
      logger.e("lotteryList isEmpty length:${lotteryList.length}");
      return;
    }
    if (invoiceMeta.value.invoiceId == null) {
      final lotteryDate = HomeController.to.lotteryDate;
      if (lotteryDate == null) return;
      final lotteryDateStr = CommonFn.parseLotteryDateCollection(lotteryDate);
      final amount = CommonFn.calculateTotalPrice(lotteryList);
      final invoicePayload = InvoiceMetaData(
        amount: amount,
        customerId: userApp!.customerId!,
        lotteryDateStr: lotteryDateStr,
        phone: userApp!.phoneNumber,
        totalAmount: amount,
        transactions: lotteryList,
        price: amount,
        quota: amount,
      );
      calPrePromotion(invoicePayload);
      logger.w(invoicePayload.toJson(userApp!.userId));
      // tag:create
      final responseCreateInvoice = await addTransaction(invoicePayload);
      logger.w(responseCreateInvoice);
      if (responseCreateInvoice == null) {
        return;
      }
      // handle expire invoice - sawanon:20241022
      final invoiceExpire = responseCreateInvoice['invoice']['expire'];
      invoicePayload.expire = invoiceExpire;
      final expireDateTime = DateTime.parse(invoiceExpire);
      startCountDownInvoiceExpire(expireDateTime);
      // gen invoice from response - sawanon:20241022
      final emptyInvoice = InvoiceMetaData.empty();
      final invoiceId = responseCreateInvoice['invoice']['\$id'];
      StorageController.to.setInvoiceMetaId(invoiceId);
      emptyInvoice.invoiceId = invoiceId;
      emptyInvoice.lotteryDateStr = lotteryDateStr;
      // responseTransactions => {"123": {$id: '3ofodf', amount: 1000,}}
      final List<Lottery> transactionFailed = [];
      final responseTransactionsList =
          responseCreateInvoice['transaction'] as Map;
      for (var transaction in invoicePayload.transactions) {
        final responseTransaction =
            responseTransactionsList[transaction.lottery];
        if (responseTransaction['status'] == true) {
          transaction.id = responseTransaction['data']['\$id'];
          emptyInvoice.transactions.add(transaction);
          emptyInvoice.quota += transaction.quota;
          emptyInvoice.discount =
              (emptyInvoice.discount ?? 0) + (transaction.discount ?? 0);
          emptyInvoice.amount += transaction.amount;
          emptyInvoice.bonus =
              (emptyInvoice.bonus ?? 0) + (transaction.bonus ?? 0);
          emptyInvoice.totalAmount += transaction.totalAmount!;
        } else {
          transactionFailed.add(transaction);
        }
      }
      logger.e(transactionFailed);
      invoiceMeta.value = emptyInvoice.copyWith();
      if (transactionFailed.isNotEmpty) {
        Get.dialog(DialogApp(
          title: Text(
            AppLocale.someLotteryQuotaExceeded.getString(Get.context!),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          details: Text(
              '"${transactionFailed.map((e) => e.lottery).toList().join(",")}" ${AppLocale.pleaseBuyLessOrAnotherLottery.getString(Get.context!)}'),
          disableConfirm: true,
          cancelText: Text(
            AppLocale.close.getString(Get.context!),
            style: TextStyle(
              color: AppColors.primary,
            ),
          ),
        ));
      }
    } else {
      // update invoice when you have invoice - sawanon:20241022
      InvoiceMetaData cloneInvoice = invoiceMeta.value.copyWith();
      // find is exist in invoice ?
      final List<Lottery> lotteryUpdateLise = [];
      for (var lotteryData in lotteryList) {
        final transaction = cloneInvoice.transactions
            .where((transaction) => transaction.lottery == lotteryData.lottery)
            .toList();
        if (transaction.isNotEmpty) {
          // update
          transaction.first.quota += lotteryData.quota;
          logger.w("update: ${lotteryData.quota}");
          lotteryUpdateLise.add(transaction.first);
        } else {
          // add new
          cloneInvoice.transactions.add(lotteryData);
        }
      }
      for (var transaction in cloneInvoice.transactions) {
        transaction.amount = transaction.quota;
        transaction.totalAmount = transaction.quota;
        transaction.discount = null;
        transaction.discountType = null;
        transaction.bonus = null;
        transaction.bonusType = null;
      }
      cloneInvoice = calPrePromotion(cloneInvoice);
      // FIXME: clone all bonus to payload and new invoiceMeta.value !!!
      logger.w(cloneInvoice.toJson(userApp!.userId));
      final List<Lottery> newTransactions = [];
      final List<Lottery> updateTransactions = [];
      // final newTransactions = cloneInvoice.transactions
      //     .where((tranaction) => tranaction.id == null)
      //     .toList();
      for (var cloneTransaction in cloneInvoice.transactions) {
        if (cloneTransaction.id == null) {
          newTransactions.add(cloneTransaction);
        } else {
          final findLottery = lotteryUpdateLise
              .where((lotteryData) =>
                  lotteryData.lottery == cloneTransaction.lottery)
              .toList();
          if (findLottery.isNotEmpty) {
            updateTransactions.add(cloneTransaction);
          }
        }
      }
      logger.d(newTransactions.length);
      logger.d(updateTransactions.length);
      final invoicePayload = cloneInvoice.copyWith();
      invoicePayload.transactions.clear();
      invoicePayload.transactions = [...newTransactions, ...updateTransactions];
      // final emptyInvoice = InvoiceMetaData.empty();
      logger.w(invoicePayload.toJson(userApp!.userId));
      // logger.d("exist invoice");
      // tag:update
      final responseUpdateInvoice = await addTransaction(invoicePayload);
      if (responseUpdateInvoice == null) {
        return;
      }
      // if (responseUpdateInvoice == null ||
      //     responseUpdateInvoice['invoice']['status'] == false) {
      //   Get.dialog(DialogApp(
      //     title: const Text("update invoice failed"),
      //     // FIXME: ask gie for detail message when create invoice failed
      //     details: Text("$responseUpdateInvoice"),
      //     disableConfirm: true,
      //     cancelText: Text(
      //       AppLocale.close.getString(Get.context!),
      //       style: const TextStyle(
      //         color: AppColors.primary,
      //       ),
      //     ),
      //   ));
      //   return;
      // }
      final List<Lottery> transactionFailed = [];
      final responseTransactionsList =
          responseUpdateInvoice['transaction'] as Map;
      InvoiceMetaData cloneInvoiceForCheckValue = invoiceMeta.value.copyWith();
      for (var transaction in invoicePayload.transactions) {
        logger.w(transaction.toJson());
        final responseTransaction =
            responseTransactionsList[transaction.lottery];
        if (responseTransaction['status'] == true) {
          // final findExistTransaction = updateTransactions
          //     .where((transactionUpdate) =>
          //         transactionUpdate.lottery == transaction.lottery)
          //     .toList();
          if (transaction.id != null) {
            // update
            final index = cloneInvoiceForCheckValue.transactions.indexWhere(
                (transactionUpdate) =>
                    transactionUpdate.lottery == transaction.lottery);
            cloneInvoiceForCheckValue.transactions[index] = transaction;
            logger.d(transaction.toJson());
            // for (var transactionUpdate
            //     in cloneInvoiceForCheckValue.transactions) {
            //   if (transactionUpdate.lottery == transaction.lottery) {
            //     transactionUpdate = transaction;
            //     break;
            //   }
            // }
          } else {
            // add
            transaction.id = responseTransaction['data']['\$id'];
            cloneInvoiceForCheckValue.transactions.add(transaction);
          }
        } else {
          transactionFailed.add(transaction);
        }
      }
      for (var transaction in cloneInvoiceForCheckValue.transactions) {
        transaction.amount = transaction.quota;
        transaction.totalAmount = transaction.quota;
        transaction.discount = null;
        transaction.discountType = null;
        transaction.bonus = null;
        transaction.bonusType = null;
      }
      cloneInvoiceForCheckValue.quota = 0;
      cloneInvoiceForCheckValue.discount = null;
      cloneInvoiceForCheckValue.amount = 0;
      cloneInvoiceForCheckValue.bonus = null;
      cloneInvoiceForCheckValue.totalAmount = 0;
      cloneInvoiceForCheckValue = calPrePromotion(cloneInvoiceForCheckValue);
      // for (var transaction in cloneInvoiceForCheckValue.transactions) {
      //   cloneInvoiceForCheckValue.quota += transaction.quota;
      //   cloneInvoiceForCheckValue.discount = (transaction.discount ?? 0) +
      //       (cloneInvoiceForCheckValue.discount ?? 0);
      //   cloneInvoiceForCheckValue.amount += transaction.amount;
      //   cloneInvoiceForCheckValue.bonus =
      //       (transaction.bonus ?? 0) + (cloneInvoiceForCheckValue.bonus ?? 0);
      //   cloneInvoiceForCheckValue.totalAmount += transaction.totalAmount!;
      // }
      logger.d(cloneInvoiceForCheckValue.toJson(userApp!.userId));
      invoiceMeta.value = cloneInvoiceForCheckValue;
      if (transactionFailed.isNotEmpty) {
        Get.dialog(DialogApp(
          title: Text(
            AppLocale.someLotteryQuotaExceeded.getString(Get.context!),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          details: Text(
              '"${transactionFailed.map((e) => e.lottery).toList().join(",")}" ${AppLocale.pleaseBuyLessOrAnotherLottery.getString(Get.context!)}'),
          disableConfirm: true,
          cancelText: Text(
            AppLocale.close.getString(Get.context!),
            style: TextStyle(
              color: AppColors.primary,
            ),
          ),
        ));
      }
      // emptyInvoice.quota += transaction.quota;
      // emptyInvoice.discount =
      //     (emptyInvoice.discount ?? 0) + (transaction.discount ?? 0);
      // emptyInvoice.amount += transaction.amount;
      // emptyInvoice.bonus =
      //     (emptyInvoice.bonus ?? 0) + (transaction.bonus ?? 0);
      // emptyInvoice.totalAmount += transaction.totalAmount!;
    }
    logger.d(invoiceMeta.value.toJson(userApp!.userId));
  }

  void buyLotteryByRandom(String lotteryNumber) async {
    if (disabledBuy.value) {
      showDialogCloseSale();
      return;
    }
    logger.d(lotteryNumber);
    final listPermutations = generatePermutations(lotteryNumber.split(""));
    logger.d(listPermutations);
    final List<Lottery> listAllFormat = listPermutations.map(
      (lotteryNumberArray) {
        final lottery = lotteryNumberArray.join("");
        return Lottery(
          amount: 1000,
          lottery: lottery,
          lotteryType: lottery.length,
          quota: 1000,
          totalAmount: 1000,
        );
      },
    ).toList();
    // logger.d(listAllFormat);
    await createTransaction(listAllFormat);
  }

  List<List<String>> generatePermutations(List<String> list) {
    if (list.length == 1) {
      return [list];
    }

    final permutations = <List<String>>[];

    for (var i = 0; i < list.length; i++) {
      var current = list[i];
      var remaining = List.of(list)..removeAt(i);
      var subPermutations = generatePermutations(remaining);

      for (var perm in subPermutations) {
        permutations.add([current, ...perm]);
      }
    }

    return permutations;
  }

  void listBuyLotteryConfigs() async {
    final buyLotteryConfigsList =
        await AppWriteController.to.listBuyLotteryConfigs();
    if (buyLotteryConfigsList == null) {
      return;
    }
    logger.d("buyLotteryConfigsList: $buyLotteryConfigsList");
    buyLotteryConfigs = buyLotteryConfigsList;
    update();
  }

  InvoiceMetaData? calPromotion([InvoiceMetaData? invoicePreCheck]) {
    for (var promotion in promotionList) {
      switch (promotion['type']) {
        case 'condition':
        // check condition
        // return calConditionPromotion(
        //     promotion, invoiceMeta, invoicePreCheck != null, invoicePreCheck);
        case 'percent':
          // check percentage
          break;
        default:
          return null;
      }
    }
    return null;
  }

  InvoiceMetaData calPrePromotion(InvoiceMetaData invoicePreCheck) {
    InvoiceMetaData _invoicePreCheck = invoicePreCheck;
    for (var promotion in promotionList) {
      switch (promotion['type']) {
        case 'condition':
          // check condition
          _invoicePreCheck =
              calPreConditionPromotion(promotion, _invoicePreCheck);
        case 'percent':
          // check percentage
          _invoicePreCheck = calPrePercent(promotion, _invoicePreCheck);
          break;
        case 'fixed':
          _invoicePreCheck = calPreFixed(promotion, _invoicePreCheck);
          // _invoicePreCheck = calPrePercent(promotion, _invoicePreCheck);
          break;
        default:
          break;
        // return _invoicePreCheck;
      }
    }
    return _invoicePreCheck;
  }

  InvoiceMetaData calPreFixed(Map promotion, InvoiceMetaData invoiceMetaData) {
    final bonusFixed = int.parse(
        jsonDecode((promotion['condition'] as List).first)['bonus'] as String);
    logger.w(bonusFixed);
    if (bonusFixed < 0) {
      // discount
      final discount = bonusFixed;
      for (var transaction in invoiceMetaData.transactions) {
        transaction.discount = (transaction.discount ?? 0) + discount;
        transaction.amount = transaction.discount! + transaction.quota;
      }
    } else {
      // bonus
      for (var transaction in invoiceMetaData.transactions) {
        transaction.bonus = (transaction.bonus ?? 0) + bonusFixed;
        transaction.totalAmount = transaction.bonus! + transaction.quota;
      }
    }
    invoiceMetaData.discount = invoiceMetaData.transactions
        .fold(0, (prev, transaction) => prev! + (transaction.discount ?? 0));
    invoiceMetaData.bonus = invoiceMetaData.transactions.fold(
        0,
        (previousValue, transaction) =>
            previousValue! + (transaction.bonus ?? 0));
    invoiceMetaData.amount = invoiceMetaData.transactions
        .fold(0, (prev, transaction) => prev + transaction.amount);
    invoiceMetaData.quota = invoiceMetaData.transactions
        .fold(0, (prev, transaction) => prev + transaction.quota);
    invoiceMetaData.totalAmount = invoiceMetaData.transactions
        .fold(0, (prev, transaction) => prev + transaction.totalAmount!);
    return invoiceMetaData;
  }

  InvoiceMetaData calPrePercent(
      Map promotion, InvoiceMetaData invoiceMetaData) {
    final bonusPercent = int.parse(
        (jsonDecode((promotion['condition'] as List).first)['bonus'] as String)
            .replaceAll("%", ""));
    if (bonusPercent < 0) {
      // discount
      final discountPercent = bonusPercent;
      for (var transaction in invoiceMetaData.transactions) {
        transaction.discount = (transaction.discount ?? 0) +
            calfromPercent(discountPercent, transaction.quota);
        transaction.amount = transaction.discount! + transaction.quota;
      }
      invoiceMetaData.discount = invoiceMetaData.transactions.fold(
          0,
          (previousValue, transaction) =>
              previousValue! + transaction.discount!);
    } else {
      // bonus
      for (var transaction in invoiceMetaData.transactions) {
        transaction.bonus = (transaction.bonus ?? 0) +
            calfromPercent(bonusPercent, transaction.quota);
        transaction.totalAmount = transaction.bonus! + transaction.quota;
      }
      invoiceMetaData.bonus = invoiceMetaData.transactions
          .fold(0, (prev, transaction) => prev! + transaction.bonus!);
    }
    invoiceMetaData.amount = invoiceMetaData.transactions
        .fold(0, (prev, transaction) => prev + transaction.amount);
    invoiceMetaData.quota = invoiceMetaData.transactions
        .fold(0, (prev, transaction) => prev + transaction.quota);
    invoiceMetaData.totalAmount = invoiceMetaData.transactions
        .fold(0, (prev, transaction) => prev + transaction.totalAmount!);
    logger.d(bonusPercent);
    return invoiceMetaData;
  }

  InvoiceMetaData calPreConditionPromotion(
      Map promotion, InvoiceMetaData invoiceMetaData) {
    List conditionsList = (promotion['condition'] as List)
        .map((promotion) => jsonDecode(promotion))
        .toList();
    conditionsList.sort(
      (a, b) {
        return int.parse(b['value']).compareTo(int.parse(a['value']));
      },
    );
    for (var transaction in invoiceMetaData.transactions) {
      for (var condition in conditionsList) {
        final isPassPromotion = conditionOperation(
            condition['condition'], transaction.quota, condition['value']);
        logger.e("isPassPromotion: $isPassPromotion");
        if (isPassPromotion) {
          if (condition['type'] == "percent") {
            final bonusPercent = int.parse(condition['bonus']);
            if (bonusPercent < 0) {
              // discount
              final discountPercent = bonusPercent;
              transaction.discount = (transaction.discount ?? 0) +
                  calfromPercent(discountPercent, transaction.quota);
              transaction.amount = transaction.discount! + transaction.quota;
            } else {
              // bonus
              transaction.bonus = (transaction.bonus ?? 0) +
                  calfromPercent(bonusPercent, transaction.quota);
              transaction.totalAmount = transaction.quota + transaction.bonus!;
            }
          } else if (condition['type'] == "fixed") {
            final bonus = int.parse(condition['bonus']);
            if (bonus < 0) {
              // discount
              final discount = bonus;
              transaction.discount = (transaction.discount ?? 0) + discount;
              transaction.amount = transaction.discount! + transaction.quota;
            } else {
              // bonus
              transaction.bonus = (transaction.bonus ?? 0) + bonus;
              transaction.totalAmount = transaction.bonus! + transaction.quota;
            }
          }
          break;
        }
      }
    }
    invoiceMetaData.discount = invoiceMetaData.transactions
        .fold(0, (prev, transaction) => prev! + (transaction.discount ?? 0));
    invoiceMetaData.bonus = invoiceMetaData.transactions.fold(
        0,
        (previousValue, transaction) =>
            previousValue! + (transaction.bonus ?? 0));
    invoiceMetaData.amount = invoiceMetaData.transactions
        .fold(0, (prev, transaction) => prev + transaction.amount);
    invoiceMetaData.quota = invoiceMetaData.transactions
        .fold(0, (prev, transaction) => prev + transaction.quota);
    invoiceMetaData.totalAmount = invoiceMetaData.transactions
        .fold(0, (prev, transaction) => prev + transaction.totalAmount!);
    return invoiceMetaData;
    for (var condition in conditionsList) {
      logger.d(condition);
      if (condition['parameter'] == "buyAmount") {
        // calculate amount from invoice
        final isPassPromotion = conditionOperation(
            condition['condition'], invoiceMetaData.quota, condition['value']);
        logger.d(
            "isPassPromotion: ${invoiceMetaData.quota} ${condition['condition']} ${condition['value']} => $isPassPromotion");
        if (isPassPromotion) {
          if (condition['type'] == "percent") {
            final bonusPercent = int.parse(condition['bonus']);
            logger.d("bonusPercent: $bonusPercent");
            if (bonusPercent < 0) {
              // discount
              // final discountPercent = bonusPercent;
              // for (var transaction in invoiceMetaData.transactions) {
              //   transaction.discount = (transaction.discount ?? 0) +
              //       calfromPercent(discountPercent, transaction.quota);
              //   transaction.amount =
              //       calfromPercent(discountPercent, transaction.quota) +
              //           transaction.amount;
              // }
              // invoiceMetaData.discount = invoiceMetaData.transactions.fold(
              //     0,
              //     (previousValue, transaction) =>
              //         previousValue! + transaction.discount!);
            } else {
              for (var transaction in invoiceMetaData.transactions) {
                transaction.bonus = (transaction.bonus ?? 0) +
                    calfromPercent(bonusPercent, transaction.quota);
                transaction.totalAmount =
                    (transaction.totalAmount ?? transaction.quota) +
                        calfromPercent(bonusPercent, transaction.quota);
              }
              invoiceMetaData.bonus = invoiceMetaData.transactions.fold(
                  0,
                  (previousValue, transaction) =>
                      previousValue! + transaction.bonus!);
            }
            invoiceMetaData.amount = invoiceMetaData.transactions
                .fold(0, (prev, transaction) => prev + transaction.amount);
            invoiceMetaData.quota = invoiceMetaData.transactions
                .fold(0, (prev, transaction) => prev + transaction.quota);
            invoiceMetaData.totalAmount = invoiceMetaData.transactions.fold(
                0, (prev, transaction) => prev + transaction.totalAmount!);
          }
          return invoiceMetaData;
        }
      }
    }
    return invoiceMetaData;
    // logger.d("calConditionPromotion invoice: $invoiceMetaData");
  }

  int calfromPercent(int bonus, int amount) {
    final bonusAmount = ((bonus / 100) * amount).toInt();
    return bonusAmount;
  }

  bool conditionOperation(String operation, value1, value2) {
    final v1 = value1 is int ? value1 : int.parse(value1);
    final v2 = value2 is int ? value2 : int.parse(value2);
    switch (operation) {
      case "=":
        return v1 == v2;
      case ">":
        return v1 > v2;
      case ">=":
        return v1 >= v2;
      default:
        return false;
    }
  }

// TODO: get promotion
  void listPromotions() async {
    final promotionList =
        await AppWriteController.to.listCurrentActivePromotions();
    // logger.w("promotionList");
    // logger.d(promotionList);
    if (promotionList == null) return;
    this.promotionList.value = promotionList;
  }

  void getUseApp() async {
    logger.d("userApp:");
    logger.d(userApp);
    if (userApp == null) {
      userApp = await AppWriteController.to.getUserApp();
    }
  }

  void getQuota() async {
    if (userApp == null) return;
    final quotaList = await AppWriteController.to.getQuota();
    if (quotaList == null) {
      Get.dialog(
        const DialogApp(
          title: Text(
            "Server error",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          details: Text(
            "Can't get quota from server",
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      );
      return;
    }
    Map<String, dynamic> quotaMap = {};
    for (var quota in quotaList.documents) {
      final thisQuotaMap = {
        '${quota.data['type']}': '${quota.data['amount']}',
      };
      quotaMap.addAll(thisQuotaMap);
    }
    logger.d(quotaMap);
    this.quotaMap = quotaMap;
    startTimerGetQuota();
  }

  Timer? _timerGetQuota;
  void startTimerGetQuota() async {
    _timerGetQuota?.cancel();
    _timerGetQuota = Timer.periodic(
      const Duration(minutes: 10),
      (timer) {
        getQuota();
      },
    );
  }

  @override
  void onInit() {
    // checkUser();
    listBuyLotteryConfigs();
    getUseApp();
    listPromotions();
    setupNode();
    getQuota();
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
    priceNode.removeListener(onFocus);
    lotteryNode.removeListener(onFocus);
    _timer?.cancel();
    _timerGetQuota?.cancel();
    super.onClose();
  }
}
