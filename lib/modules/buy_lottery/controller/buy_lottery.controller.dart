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
  // Map<String, dynamic> invoice = {};
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

  InvoiceMetaData? createInvoiceForPreCheck(Lottery lottery) {
    logger.d(userApp);
    if (userApp == null) return null;
    logger.d(invoiceMeta.value.invoiceId);
    if (invoiceMeta.value.invoiceId == null) {
      // create a new invoice and pre-check
      final lotteryDate = HomeController.to.lotteryDate;
      if (lotteryDate == null) return null;
      final lotteryDateStr = CommonFn.parseLotteryDateCollection(lotteryDate);
      final amount = CommonFn.calculateTotalPrice([lottery]);
      final invoice = InvoiceMetaData(
        amount: amount,
        totalAmount: amount,
        transactions: [lottery],
        customerId: userApp!.customerId!,
        phone: userApp!.phoneNumber,
        lotteryDateStr: lotteryDateStr,
      );
      logger.d(invoice.toJson(userApp!.userId));
      calPrePromotion(invoice);
      logger.w(invoice.toJson(userApp!.userId));
      return invoice;
    } else {
      // create invoice from old ref and pre-check
      // check has exist transaction lottery
      // final backUpInvoice = invoiceMeta.value.copyWith();
      InvoiceMetaData cloneInvoice = InvoiceMetaData.empty();
      cloneInvoice = invoiceMeta.value.copyWith();
      final findTrasaction = cloneInvoice.transactions.where(
        (transaction) {
          return transaction.lottery == lottery.lottery;
        },
      ).toList();
      logger.e(findTrasaction.length);
      if (findTrasaction.isNotEmpty) {
        // already exist lottery number
        // final amount = CommonFn.calculateTotalPrice([lottery]);
        findTrasaction.first.price = findTrasaction.first.price + lottery.price;
        cloneInvoice.transactions = findTrasaction;
        logger.w("meta");
        logger.w(cloneInvoice.toJson(userApp!.userId));
        calPrePromotion(cloneInvoice);
        calculatePreTotalAmount(cloneInvoice);
        logger.w(cloneInvoice.toJson(userApp!.userId));
        return cloneInvoice;
      } else {
        // dosen't exist lottery number
        cloneInvoice.transactions.clear();
        cloneInvoice.transactions.add(lottery);
        calPrePromotion(cloneInvoice);
        calculatePreTotalAmount(cloneInvoice);
        logger.w(cloneInvoice.toJson(userApp!.userId));
        // logger.f(invoiceMeta.value.toJson(userApp!.userId));
        return cloneInvoice;
      }
    }
    return null;
  }

  InvoiceMetaData? createInvoiceForUse(Lottery lottery) {
    if (userApp == null) return null;
    logger.d(invoiceMeta.value.invoiceId);
    if (invoiceMeta.value.invoiceId == null) {
      // create a new invoice and pre-check
      final lotteryDate = HomeController.to.lotteryDate;
      if (lotteryDate == null) return null;
      final lotteryDateStr = CommonFn.parseLotteryDateCollection(lotteryDate);
      final amount = CommonFn.calculateTotalPrice([lottery]);
      final invoice = InvoiceMetaData(
        amount: amount,
        totalAmount: amount,
        transactions: [lottery],
        customerId: userApp!.customerId!,
        phone: userApp!.phoneNumber,
        lotteryDateStr: lotteryDateStr,
      );
      logger.d(invoice.toJson(userApp!.userId));
      calPrePromotion(invoice);
      logger.w(invoice.toJson(userApp!.userId));
      return invoice;
    } else {
      // create invoice from old ref and pre-check
      // check has exist transaction lottery
      // final backUpInvoice = invoiceMeta.value.copyWith();
      InvoiceMetaData cloneInvoice = invoiceMeta.value.copyWith();
      final findTrasaction = cloneInvoice.transactions.where(
        (transaction) {
          return transaction.lottery == lottery.lottery;
        },
      ).toList();
      logger.e(findTrasaction.length);
      if (findTrasaction.isNotEmpty) {
        // already exist lottery number
        // final amount = CommonFn.calculateTotalPrice([lottery]);
        findTrasaction.first.price = findTrasaction.first.price + lottery.price;
        calPrePromotion(cloneInvoice);
        calculatePreTotalAmount(cloneInvoice);
        return cloneInvoice;
      } else {
        // dosen't exist lottery number
        cloneInvoice.transactions.add(lottery);
        calPrePromotion(cloneInvoice);
        calculatePreTotalAmount(cloneInvoice);
        // logger.f(invoiceMeta.value.toJson(userApp!.userId));
        return cloneInvoice;
      }
    }
    return null;
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
              "${invoiceRemainExpire.value.inMinutes.remainder(60)}:${invoiceRemainExpire.value.inSeconds.remainder(60)}";
          // logger.d("run ! ${remainingDateTime.value.inSeconds}");
          return;
        }
        logger.e("stop !");
        timer.cancel();
      },
    );
  }

  Future<InvoiceMetaData?> fakeAPITransaction(InvoiceMetaData invoicePreCheck,
      InvoiceMetaData invoiceForUser, InvoiceMetaData oldInvoice) async {
    final fakeResponse = await addTransaction(invoicePreCheck);
    logger.d("fakeResponse: $fakeResponse");
    if (fakeResponse == null) {
      Get.rawSnackbar(message: "Transaction not found");
      return null;
    }
    if (fakeResponse['invoice']['status'] == false) {
      Get.snackbar(
        "create invoice failed",
        "$fakeResponse",
        duration: const Duration(seconds: 10),
      );
      return null;
    }
    final invoiceId = (fakeResponse['invoice'] as Map)['\$id'];
    StorageController.to.setInvoiceMetaId(invoiceId);
    invoiceForUser.invoiceId = invoiceId;
    invoiceForUser.expire = fakeResponse['invoice']['expire'];
    final expireDateTime = DateTime.parse(invoiceForUser.expire!);
    startCountDownInvoiceExpire(expireDateTime);
    List<String> transactionFailed = [];
    for (var transaction in invoicePreCheck.transactions) {
      final transactionData =
          fakeResponse['transaction']![transaction.lottery] as Map;
      if (transactionData['status'] == false) {
        transactionFailed.add(transaction.lottery);
        continue;
      }
      transaction.id = transactionData['data']['\$id'];
    }
    List<Lottery> removeTransaction = [];
    for (var transaction in invoiceForUser.transactions) {
      if (transactionFailed.contains(transaction.lottery)) {
        final findOldTransaction = oldInvoice.transactions.where(
            (_transaction) => _transaction.lottery == transaction.lottery);
        if (findOldTransaction.isNotEmpty) {
          transaction = findOldTransaction.first.copyWith();
          logger.e("pass !!");
        } else {
          removeTransaction.add(transaction);
        }
        continue;
      }
    }
    if (removeTransaction.isNotEmpty) {
      invoiceForUser.transactions.removeWhere(
          (transaction) => removeTransaction.contains(transaction));
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
            '"${removeTransaction.map((e) => e.lottery).toList().join(",")}" ${AppLocale.pleaseBuyLessOrAnotherLottery.getString(Get.context!)}'),
        disableConfirm: true,
        cancelText: Text(
          AppLocale.close.getString(Get.context!),
          style: TextStyle(
            color: AppColors.primary,
          ),
        ),
      ));
    }
    return invoiceForUser;
  }

  bool lotteryIsValid(Lottery lottery) {
    final buyLotteryConfig = buyLotteryConfigs
        .where(
          (buyLotteryConfig) =>
              buyLotteryConfig.lotteryType == lottery.lotteryType,
        )
        .toList();
    logger.d("buyLotteryConfig: $buyLotteryConfig");
    final currentLottery = lottery;
    final total = currentLottery.price + lottery.price;
    if (buyLotteryConfig.isNotEmpty) {
      final config = buyLotteryConfig.first;
      if (config.max != null) {
        if (config.max! < total) {
          Get.snackbar("more than quota",
              "please buy maximum ${config.max} per lottery");
          return false;
        }
        if (config.min! > lottery.price) {
          Get.snackbar("less than quota",
              "please buy minumum ${config.max} per lottery");
          return false;
        }
      }
    }
    return true;
  }

  Future<void> addLottery(String lottery, int price) async {
    try {
      logger.w(lottery);
      logger.w(price);
      final lotteryClass = Lottery(
        lottery: lottery,
        price: price,
        lotteryType: lottery.length,
        totalAmount: price,
      );
      if (!lotteryIsValid(lotteryClass)) {
        return;
      }
      final oldInvoice = invoiceMeta.value.copyWith();

      final invoicePreCheck = createInvoiceForPreCheck(lotteryClass);
      final invoiceForUser = createInvoiceForUse(lotteryClass);
      if (invoicePreCheck == null || invoiceForUser == null) {
        Get.snackbar("Error", "can't create invoice");
        return;
      }
      logger.f("preChcek");
      logger.d(invoicePreCheck.toJson(userApp!.userId));
      logger.f("foruse");
      logger.d(invoiceForUser.toJson(userApp!.userId));
      final responseInvoice =
          await fakeAPITransaction(invoicePreCheck, invoiceForUser, oldInvoice);
      if (responseInvoice == null) {
        Get.snackbar("Error", "can't create invoice from API");
        return;
      }
      calPrePromotion(invoiceForUser);
      calculatePreTotalAmount(invoiceForUser);
      logger.w("response");
      logger.d(responseInvoice.toJson(userApp!.userId));
      invoiceMeta.value = invoiceForUser;
    } catch (e) {
      logger.e(e.toString());
      Get.snackbar("Error", "can't add lottery");
    }
    return;
    try {
      final findLottery = lotteryList.where(
        (data) {
          return data.lottery == lottery;
        },
      ).toList();
      String? invoiceId;
      if (findLottery.isNotEmpty) {
        final lottery = findLottery.first;
        final buyLotteryConfig = buyLotteryConfigs
            .where(
              (buyLotteryConfig) =>
                  buyLotteryConfig.lotteryType == lottery.lotteryType,
            )
            .toList();
        logger.d("buyLotteryConfig: $buyLotteryConfig");
        final currentLottery = lottery;
        final total = currentLottery.price + price;
        if (buyLotteryConfig.isNotEmpty) {
          final config = buyLotteryConfig.first;
          if (config.max != null) {
            if (config.max! < total) {
              Get.snackbar("more than quota",
                  "please buy maximum ${config.max} per lottery");
              return;
            }
            if (config.min! > lottery.price) {
              Get.snackbar("less than quota",
                  "please buy minumum ${config.max} per lottery");
              return;
            }
          }
        }
        // api /transaction
        // final isSuccess = await addTransaction(lotteryList);
        // if (!isSuccess) {
        //   return;
        // }
        currentLottery.price = total;
        update();
      } else {
        final currentLottery = Lottery(
          lottery: lottery,
          price: price,
          lotteryType: lottery.length,
        );
        // // FIXME: precheck
        InvoiceMetaData invoicePreCheck = InvoiceMetaData.empty();
        invoicePreCheck.transactions = [
          currentLottery,
          ...invoiceMeta.value.transactions
        ];
        final reultPreCheck = calPromotion(invoicePreCheck);
        logger.d("prechec invoice: ${reultPreCheck?.transactions}");
        logger.d("precheck : ${reultPreCheck?.transactions.first.bonus}");
        // final result = await addTransaction(currentLottery);
        // if (result == null) {
        //   throw "add transaction failed";
        // }
        // // 66fdb5c4002ac10d0ca8
        // invoiceId = result['invoiceId'];

        lotteryList.add(currentLottery);
      }
      calculateTotalAmount();
      if (invoiceMeta.value.invoiceId == null) {
        final user = await AppWriteController.to.getUserApp();
        if (user == null) {
          throw "User is not logged in";
        }
        final lotteryDate = HomeController.to.lotteryDate;
        if (lotteryDate == null) {
          Get.snackbar("lottery date is not avaliable", "");
          return;
        }
        invoiceMeta.value = InvoiceMetaData(
          amount: totalAmount.value,
          customerId: '',
          lotteryDateStr: CommonFn.parseLotteryDateCollection(lotteryDate),
          phone: user.phoneNumber,
          totalAmount: invoiceMeta.value.totalAmount,
          bonus: invoiceMeta.value.bonus,
          invoiceId: invoiceId,
          transactions: lotteryList,
        );
        logger.d("invoiceMeta: ${invoiceMeta.value.invoiceId}");
      } else {
        invoiceMeta.value.transactions = lotteryList.value;
      }
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: '$e');
    }
  }

  // Future<Map?> addTransaction(Lottery transaction) async {
  Future<Map?> addTransaction(InvoiceMetaData invoiceMeta) async {
    try {
      isLoadingAddLottery.value = true;
      final dio = Dio();
      final token = await AppWriteController.to.getCredential();
      final response = await dio.post(
        // "https://59c5-2405-9800-b920-2f86-4453-eaab-1aa0-9520.ngrok-free.app/api/transaction",
        "${AppConst.apiUrl}/transaction",
        data: invoiceMeta.toJson(userApp!.userId),
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      logger.d("response");
      logger.d(response.data);
      logger.d("invoiceMeta!.invoice.\$id: ${invoiceMeta.invoiceId}");
      // invoice.invoice.$id;
      return response.data;
    } catch (e) {
      logger.e("$e");
      return null;
    } finally {
      isLoadingAddLottery.value = false;
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
  }

  void submitAddLottery(String? lottery, int? price) async {
    logger.d("formKey?.currentState: ${formKey?.currentState}");

    if (formKey?.currentState != null && formKey!.currentState!.validate()) {
      if (lottery == null || price == null) {
        alertLotteryEmpty();
        alertPrice();
        return;
      }
      if (price % 1000 != 0) {
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
        return;
      }
      final valid = validateLottery(lottery, price);
      if (valid) {
        await addLottery(lottery, price);
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
    if (invoiceMeta.value.transactions.isEmpty) {
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
                        "ເຂົ້າສູ່ລະບົບ",
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
      arguments: [onClickAnimalBuy],
    );
  }

  void onClickAnimalBuy(List<Map<String, dynamic>> lotteryList) async {
    logger.d(lotteryList);
    for (var lottery in lotteryList) {
      await addLottery(lottery["lottery"], int.parse(lottery["price"]));
    }
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

  InvoiceMetaData? calPrePromotion(InvoiceMetaData invoicePreCheck) {
    for (var promotion in promotionList) {
      switch (promotion['type']) {
        case 'condition':
          // check condition
          return calPreConditionPromotion(promotion, invoicePreCheck);
        case 'percent':
          // check percentage
          break;
        default:
          return null;
      }
    }
    return null;
  }

  InvoiceMetaData? calPreConditionPromotion(
      Map promotion, InvoiceMetaData invoiceMetaData) {
    List conditionsList = (promotion['condition'] as List)
        .map((promotion) => jsonDecode(promotion))
        .toList();
    conditionsList.sort(
      (a, b) {
        return int.parse(b['value']).compareTo(int.parse(a['value']));
      },
    );
    for (var condition in conditionsList) {
      logger.d(condition);
      if (condition['parameter'] == "buyAmount") {
        // calculate amount from invoice
        final isPassPromotion = conditionOperation(
            condition['condition'], invoiceMetaData.amount, condition['value']);
        logger.d(
            "isPassPromotion: ${invoiceMetaData.amount} ${condition['condition']} ${condition['value']} => $isPassPromotion");
        if (isPassPromotion) {
          if (condition['type'] == "percent") {
            final bonus = int.parse(condition['bonus']);
            invoiceMetaData.bonus = bonus;
            for (var transaction in invoiceMetaData.transactions) {
              transaction.bonus = bonus;
              transaction.totalAmount =
                  transaction.price + calfromPercent(bonus, transaction.price);
            }
            invoiceMetaData.totalAmount = invoiceMetaData.amount +
                calfromPercent(bonus, invoiceMetaData.amount);
          }
          return invoiceMetaData;
        }
      }
    }
    return invoiceMetaData;
    // logger.d("calConditionPromotion invoice: $invoiceMetaData");
  }

  InvoiceMetaData? calConditionPromotion(
      Map promotion, Rx<InvoiceMetaData> invoiceMetaData, bool preCheck,
      [InvoiceMetaData? invoicePreCheck]) {
    List conditionsList = (promotion['condition'] as List)
        .map((promotion) => jsonDecode(promotion))
        .toList();
    conditionsList.sort(
      (a, b) {
        return int.parse(b['value']).compareTo(int.parse(a['value']));
      },
    );
    if (preCheck) {
      for (var condition in conditionsList) {
        logger.d(condition);
        if (condition['parameter'] == "buyAmount") {
          // calculate amount from invoice
          final isPassPromotion = conditionOperation(condition['condition'],
              invoicePreCheck!.amount, condition['value']);
          logger.d(
              "isPassPromotion: ${invoicePreCheck.amount} ${condition['condition']} ${condition['value']} => $isPassPromotion");
          if (isPassPromotion) {
            if (condition['type'] == "percent") {
              final bonus = int.parse(condition['bonus']);
              invoicePreCheck.bonus = bonus;
              for (var transaction in invoicePreCheck.transactions) {
                transaction.bonus = bonus;
                transaction.totalAmount = transaction.price +
                    calfromPercent(bonus, transaction.price);
              }
              invoicePreCheck.totalAmount = invoicePreCheck.amount +
                  calfromPercent(bonus, invoicePreCheck.amount);
            }
            return invoicePreCheck;
          }
        }
      }
      return invoicePreCheck;
    } else {
      for (var condition in conditionsList) {
        logger.d(condition);
        if (condition['parameter'] == "buyAmount") {
          // calculate amount from invoice
          final isPassPromotion = conditionOperation(condition['condition'],
              invoiceMetaData.value.amount, condition['value']);
          logger.d(
              "isPassPromotion: ${invoiceMetaData.value.amount} ${condition['condition']} ${condition['value']} => $isPassPromotion");
          if (isPassPromotion) {
            if (condition['type'] == "percent") {
              final bonus = int.parse(condition['bonus']);
              invoiceMetaData.value.bonus = bonus;
              for (var transaction in invoiceMetaData.value.transactions) {
                transaction.bonus = bonus;
                transaction.totalAmount = transaction.price +
                    calfromPercent(bonus, transaction.price);
              }
              invoiceMetaData.value.totalAmount = invoiceMetaData.value.amount +
                  calfromPercent(bonus, invoiceMetaData.value.amount);
            }
            return invoiceMetaData.value;
          }
        }
      }
    }
    return null;
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
    logger.w("promotionList");
    logger.d(promotionList);
    if (promotionList == null) return;
    this.promotionList.value = promotionList;
  }

  ResponseInvoiceAddTransaction fakeQuotaFull() {
    // try {
    ResponseInvoiceAddTransaction test =
        ResponseInvoiceAddTransaction.fromJson({
      "invoice": {
        "status": null,
        "totalAmount": 5000,
        "bonus": null,
        "totalTransfer": null,
        "totalWin": null,
        "is_win": false,
        "is_transfer": false,
        "transferBy": null,
        "calBy": null,
        "userId": "66e9b066000956d5e74e",
        "billNumber": null,
        "bankId": null,
        "billId": "testCustimerId2410312:34:17",
        "transactionId": [],
        "\$id": "66fb89d80009543b3c00",
        "\$createdAt": "2024-10-01T05:34:18.916+00:00",
        "\$updatedAt": "2024-10-01T05:42:41.717+00:00",
        "\$permissions": [],
        "\$databaseId": "lottory",
        "\$collectionId": "20241004_invoice"
      },
      "transaction": {
        "234": {
          "status": true,
          "data": {
            "lottery": "234",
            "digit_1": null,
            "digit_2": null,
            "digit_3": null,
            "digit_4": "2",
            "digit_5": "3",
            "digit_6": "4",
            "lotteryType": 3,
            "amount": 5000,
            "userId": "66e9b066000956d5e74e",
            "invoiceId": "66fb8bcf001f2a49aa4a",
            "\$id": "66fb8bd000172c45b498",
            "\$permissions": [],
            "\$createdAt": "2024-10-01T05:42:40.729+00:00",
            "\$updatedAt": "2024-10-01T05:42:40.729+00:00",
            "paymentMethod": null,
            "status": null,
            "winAmount": null,
            "bonus": null,
            "bankId": null,
            "calBy": null,
            "is_win": null,
            "lottery_history_id": null,
            "transferBy": null,
            "rewardId": null,
            "\$databaseId": "lottory",
            "\$collectionId": "20241004_transaction"
          },
          "message": "Buy quota successfully"
        },
        "235": {
          "status": false,
          "data": {"lottery": "235", "quotaRemain": 500000},
          "message": "Quota exceeded"
        }
      }
    });
    logger.d("test: $test");
    logger.d("object: ${test.transaction['235']?.status}");
    return test;
    // } catch (e) {
    //   logger.e("error $e");
    // }
  }

  void getUseApp() async {
    userApp ??= await AppWriteController.to.getUserApp();
  }

  @override
  void onInit() {
    // checkUser();
    listBuyLotteryConfigs();
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
    priceNode.removeListener(onFocus);
    lotteryNode.removeListener(onFocus);
    _timer?.cancel();
    super.onClose();
  }
}
