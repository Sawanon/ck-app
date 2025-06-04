import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';

class MonneyConfirmOTPController extends GetxController {
  static MonneyConfirmOTPController get to => Get.find();
  final argrument = Get.arguments;
  final String phoneNumber = Get.arguments['phoneNumber'];
  RxBool enableOTP = false.obs;
  // final Future<void> Function() _onInit = Get.arguments['onInit'];
  // final Future<void> Function(String otp) onConfirm =
  //     Get.arguments['onConfirm'];

  RxBool disabledReOTP = true.obs;
  RxBool loadingSendOTP = false.obs;
  Rx<Duration> remainingTime = Duration.zero.obs;
  String? otp = '';

  String? otpRefNo;
  String? otpRefCode;
  String? transCashOutID;
  String? transID;
  Timer? _timer;

  void enableResendOTP() {
    disabledReOTP.value = false;
  }

  void confirmOTP(String otp) async {
    // onConfirm(otp);
    final invoiceMeta = BuyLotteryController.to.invoiceMeta.value;
    try {
      final dio = Dio();
      final token = await AppWriteController.to.getCredential();
      final payload = {
        "invoiceId": invoiceMeta.invoiceId,
        "transID": transID,
        "otpRefNo": otpRefNo,
        "otpRefCode": otpRefCode,
        "otp": otp,
        "transCashOutID": transCashOutID,
        "lotteryDate": invoiceMeta.lotteryDateStr,
      };
      logger.d(payload);
      final response = await dio.post(
        "${AppConst.apiUrl}/payment/confirm",
        data: payload,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      logger.d(response.data);
      if (response.data['responseCode'] != '0000') {
        Get.dialog(
          DialogApp(
            disableConfirm: true,
            cancelText: Text(
              AppLocale.close.getString(Get.context!),
              style: TextStyle(
                color: AppColors.primary,
              ),
            ),
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
          ),
        );
        // responseMessage
        return;
      }
      BuyLotteryController.to.removeInvoiceWhenPaymentSuccess();
      Get.back();
      PaymentController.to.showBill(invoiceMeta.invoiceId!);
    } on DioException catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
        try {
          final error = jsonDecode(e.response?.data['message']);
          logger.e(error);
          Get.dialog(
            DialogApp(
              disableConfirm: true,
              title: Text("Error"),
              details: Text("$error"),
              onCancel: () {
                Get.back();
              },
            ),
          );
        } catch (error) {
          Get.dialog(
            DialogApp(
              disableConfirm: true,
              title: Text("Error: ${e.response?.statusCode}"),
              details: Text("${e.response?.statusMessage}"),
              onCancel: () {
                Get.back();
              },
            ),
          );
          return null;
        }
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        logger.e(e.requestOptions);
        logger.e(e.message);
      }
    }
  }

  void resendOTP() async {
    _setup();
  }

  void _setup() async {
    try {
      final bankId = argrument['bankId'];
      final phoneNumber = argrument['phoneNumber'];
      final totalAmount = argrument['totalAmount'];
      final invoiceId = argrument['invoiceId'];
      final lotteryDateStr = argrument['lotteryDateStr'];
      final int? point = argrument['point'];
      final userApp = UserController.to.user.value;
      final dio = Dio();
      final token = await AppWriteController.to.getCredential();
      Map payload = {
        "bankId": bankId,
        "phone": phoneNumber,
        "totalAmount": totalAmount,
        "invoiceId": invoiceId,
        "lotteryDateStr": lotteryDateStr,
        "customerId": userApp!.customerId,
      };
      if (point != null) {
        payload['point'] = point;
      }
      logger.w(payload);
      final response = await dio.post(
        "${AppConst.apiUrl}/payment",
        data: payload,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      logger.d(response.data);
      if (response.data['data']['payment']['responseCode'] != '0000') {
        Get.dialog(
          DialogApp(
            disableConfirm: true,
            cancelText: const Text(
              "Close",
              style: TextStyle(
                color: AppColors.primary,
              ),
            ),
            title: Text(
              "${response.data['data']['payment']['responseStatus']}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            details: Text(
              "${response.data['data']['payment']['responseMessage']}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      enableOTP.value = true;
      otpRefNo = response.data['data']['payment']['otpRefNo'];
      otpRefCode = response.data['data']['payment']['otpRefCode'];
      transCashOutID =
          response.data['data']['payment']['transData'][0]['transCashOutID'];
      transID = response.data['data']['payment']['transID'];
      final newExpire = DateTime.parse(
          response.data['data']['payment']['transData'][0]['transExpiry']);
      BuyLotteryController.to.startCountDownInvoiceExpire(newExpire);
      update();
    } on DioException catch (e) {
      if (e.response != null) {
        logger.e(e.response?.statusCode);
        logger.e(e.response?.statusMessage);
        logger.e(e.response?.data);
        logger.e(e.response?.headers);
        logger.e(e.response?.requestOptions);
        if (e.response?.data is Map) {
          handleErrorAddTransaction(e.response?.data);
          return;
        }
        Get.dialog(
          DialogApp(
            disableConfirm: true,
            title: Text("Error: ${e.response?.statusCode}"),
            details: Text("${e.response?.statusMessage}"),
            onCancel: () {
              Get.back();
            },
          ),
        );
      }
    }
  }

  void handleErrorAddTransaction(Map errorData) {
    final String message = errorData['message'];
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
        onCancel: () {
          Get.back();
        },
        cancelText: Text("Back"),
        details: Text(message),
        disableConfirm: true,
      ),
    );
  }

  void startTimerOTP() {
    _timer?.cancel();
  }

  @override
  void onInit() {
    _setup();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
