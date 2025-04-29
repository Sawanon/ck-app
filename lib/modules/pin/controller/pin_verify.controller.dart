import 'dart:async';
import 'dart:typed_data';

import 'package:argon2/argon2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class PinVerifyController extends GetxController {
  static PinVerifyController get to => Get.find();
  RxBool pendingVerify = false.obs;

  final arguments = Get.arguments;
  final enableForgetPasscode =
      Get.arguments['enableForgetPasscode'] == null ? false : true;
  final disabledBioMetrics =
      Get.arguments['disabledBioMetrics'] == true ? true : false;
  String? errorMessage;
  String? delayMessage;
  Duration retryDelay = Duration.zero;
  int maxRetry = 3;
  bool disable = false;
  Timer? _timer;
  Duration remainingTime = Duration.zero;
  String? blockMessage;

  void useBiometrics() async {
    final isBiometricsSupport = await CommonFn.canAuthenticate();
    final availableBiosMetrics = await CommonFn.availableBiometrics();
    logger.d("isBiometricsSupport: $isBiometricsSupport");
    logger.d("availableBiosMetrics: $availableBiosMetrics");
    // deivoce not support
    if (!isBiometricsSupport) {
      Get.dialog(
        const DialogApp(
          title: Text("Biometrics is not support"),
          details: Text("Biometrics is not support on your device"),
          disableConfirm: true,
        ),
      );
      return;
    }
    // deivce not enable biometrics features
    if (!availableBiosMetrics) {
      Get.dialog(
        DialogApp(
          title: Text(
            "Biometrics is disable on your device",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          details: Text(
            'Please enable biometrics on your device first go to device "Setting" to enable',
            style: TextStyle(
              color: AppColors.textPrimary,
            ),
          ),
          disableConfirm: true,
          cancelText: Text(
            AppLocale.close.getString(Get.context!),
            style: TextStyle(
              color: AppColors.errorBorder,
            ),
          ),
        ),
      );
      return;
    }
    // setting in app
    final enableBiometrics = await StorageController.to.getEnableBio();
    logger.d("enableBiometrics: $enableBiometrics");
    if (!enableBiometrics) {
      Get.dialog(
        DialogApp(
          title: Text(AppLocale.biometricsAreDisabled.getString(Get.context!)),
          details: Text(
            AppLocale.biometricsAreDisabledDetail.getString(Get.context!),
          ),
          disableConfirm: true,
          cancelText: Text(
            AppLocale.close.getString(Get.context!),
            style: const TextStyle(
              color: AppColors.errorBorder,
            ),
          ),
        ),
      );
      return;
    }
    bool isEnable = await CommonFn.requestBiometrics();
    logger.d("isEnable: $isEnable");
    if (isEnable) {
      whenSuccess();
    }
  }

  void whenSuccess() {
    if (arguments["whenSuccess"] is Function) {
      arguments["whenSuccess"]();
    }
  }

  String getErrorMessageWhenHaveRemain(int remain) {
    return "${AppLocale.passcodeInvalid.getString(Get.context!)} (${AppLocale.passcodeRemain.getString(Get.context!).replaceAll("{remain}", "$remain")})";
  }

  Future<bool> verifyPasscode(String passcode) async {
    try {
      logger.d("before maxRetry: $maxRetry");
      logger.d("before delayMessage: $delayMessage");
      logger.d("before retryDelay: $retryDelay");
      pendingVerify.value = true;
      final userId = arguments["userId"];
      final response =
          await AppWriteController.to.verifyPasscode(passcode, userId);
      if (response == null) return false;
      logger.d("response?[pass] : ${response.toMap()}");
      logger.d(response.toMap());
      if (response.pass == true) {
        maxRetry = 3;
        StorageController.to.removePassCodeDelay();
        whenSuccess();
      } else {
        final remain = response.data?.remain;
        if (remain != null) {
          errorMessage = getErrorMessageWhenHaveRemain(remain);
          StorageController.to.setPasscodeDelay({
            "remain": remain,
            "blockUntil": response.data?.blockUntil?.toIso8601String(),
          });
        } else {
          // lock !
          disable = true;
          maxRetry = 1;
          errorMessage = null;
          if (response.data?.blockUntil != null) {
            startTimer(response.data!.blockUntil!);
          }
          StorageController.to.setPasscodeDelay({
            "remain": 0,
            "blockUntil": response.data?.blockUntil?.toIso8601String(),
          });
          final different =
              response.data?.blockUntil?.difference(DateTime.now());
          logger.d("different: $different");
          if (different != null) {
            final minute =
                different.inMinutes == 0 ? 1 : different.inMinutes + 1;
            delayMessage = AppLocale.passcodeTryAgainTime
                .getString(Get.context!)
                .replaceAll("{minute}", "$minute");
            retryDelay = different;
          }
        }
        update();
      }
      logger.d("after maxRetry: $maxRetry");
      logger.d("after delayMessage: $delayMessage");
      logger.d("after retryDelay: $retryDelay");
      return response.pass;
    } catch (e) {
      logger.d("$e");
      return false;
    } finally {
      pendingVerify.value = false;
    }
  }

  void startTimer(DateTime targetTime) {
    _timer?.cancel();
    remainingTime = targetTime.difference(DateTime.now());
    blockMessage = AppLocale.blockMessage
        .replaceAll("{minute}", "${remainingTime.inMinutes}");
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingTime.inSeconds > 0) {
          remainingTime -= const Duration(seconds: 1);
          final minute =
              remainingTime.inMinutes == 0 ? 1 : remainingTime.inMinutes;
          blockMessage =
              AppLocale.blockMessage.replaceAll("{minute}", "$minute");
        } else {
          logger.d("stop !");
          disable = false;
          _timer?.cancel();
        }
        update();
      },
    );
  }

  void forgetPasscode() async {
    final whenForgetPasscode = arguments['whenForgetPasscode'];
    if (whenForgetPasscode == null) return;
    logger.d("do something");
    if (whenForgetPasscode is Function) {
      whenForgetPasscode();
    }
  }

  void setup() async {
    final passcodeInvalidData = await StorageController.to.getPasscodeDelay();
    logger.w("key 216");
    logger.d(passcodeInvalidData);
    if (passcodeInvalidData == null) return;
    maxRetry = 1;
    if (passcodeInvalidData['remain'] != null &&
        passcodeInvalidData['remain'] != 0) {
      maxRetry = passcodeInvalidData['remain'];
      errorMessage =
          getErrorMessageWhenHaveRemain(passcodeInvalidData['remain']);
    } else {
      if (passcodeInvalidData['blockUntil'] != null) {
        final blockUntil = DateTime.parse(passcodeInvalidData['blockUntil']);
        logger.d(blockUntil);
        if (blockUntil.isAfter(DateTime.now())) {
          final different = blockUntil.difference(DateTime.now());
          logger.d(different);
          disable = true;
          startTimer(blockUntil);
        } else {
          logger.d("unlock");
        }
      }
    }
    update();
  }

  @override
  void onInit() {
    // getPasscode();
    setup();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
