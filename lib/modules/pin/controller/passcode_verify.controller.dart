import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dev/dialog_otp.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/model/get_argument/otp.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class PasscodeVerifyController extends GetxController {
  static PasscodeVerifyController get to => Get.find();
  int maxRetry = 3;
  String? delayMessage;
  Duration retryDelay = Duration.zero;
  RxBool pendingVerify = false.obs;
  String? errorMessage;
  bool disable = false;
  Timer? _timer;
  Duration remainingTime = Duration.zero;
  String? blockMessage;

  String getErrorMessageWhenHaveRemain(int remain) {
    return "${AppLocale.passcodeInvalid.getString(Get.context!)} (${AppLocale.passcodeRemain.getString(Get.context!).replaceAll("{remain}", "$remain")})";
  }

  Future<void> forgetPasscode(
      String phoneNumber, String userId, void Function() whenSuccess) async {
    String? otpRef;
    Get.toNamed(
      RouteName.otp,
      arguments: OTPArgument(
        action: OTPAction.changePasscode,
        phoneNumber: phoneNumber,
        onInit: () async {
          final response = await AppWriteController.to.getOTPUser(phoneNumber);
          if (response.isSuccess == false || response.data == null) {
            Get.dialog(
              DialogApp(
                title:
                    Text(AppLocale.somethingWentWrong.getString(Get.context!)),
                details: Text(response.message),
                disableConfirm: true,
                onCancel: () {
                  Get.back();
                },
              ),
            );
            return null;
          }
          final data = response.data!;
          Get.dialog(
            DialogOtpComponent(otp: data.otp),
          );
          otpRef = data.otpRef;
          return data.otpRef;
        },
        whenConfirmOTP: (otp) async {
          //
          final result =
              await AppWriteController.to.confirmOTPUser(userId, otp, otpRef!);
          logger.d(result);
          if (result == null) return;
          // final secret = result['data']['secret'];
          Get.toNamed(
            RouteName.changePasscode,
            arguments: {
              "userId": userId,
              "whenSuccess": () async {
                // final session = await AppWriteController.to
                //     .createSession(userId, secret);
                // if (session == null) {
                //   Get.snackbar(
                //     "Something went wrong login:65",
                //     "session is null Please try again later or plaese contact admin",
                //   );
                //   // navigator?.pop();
                //   return;
                // }
                // final availableBiometrics =
                //     await CommonFn.availableBiometrics();
                // if (availableBiometrics) {
                //   Get.toNamed(RouteName.enableBiometrics, arguments: {
                //     "whenSuccess": () async {
                //       // LayoutController.to.intialApp();
                //       // Get.offAllNamed(RouteName.layout);
                //       whenSuccess();
                //       return;
                //     }
                //   });
                //   return;
                // }
                whenSuccess();
                // LayoutController.to.intialApp();
                // Get.offAllNamed(RouteName.layout);
              }
            },
          );
          //
        },
      ),
    );
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

  Future<bool> verifyPasscode(String passcode, String userId) async {
    try {
      logger.d("before maxRetry: $maxRetry");
      logger.d("before delayMessage: $delayMessage");
      logger.d("before retryDelay: $retryDelay");
      pendingVerify.value = true;
      // final userId = arguments["userId"];
      final response =
          await AppWriteController.to.verifyPasscode(passcode, userId);
      if (response == null) return false;
      logger.d("response?[pass] : ${response.toMap()}");
      logger.d(response.toMap());
      if (response.pass == true) {
        maxRetry = 3;
        // whenSuccess();
        StorageController.to.removePassCodeDelay();
        return true;
      } else {
        final remain = response.data?.remain;
        if (remain != null) {
          errorMessage = getErrorMessageWhenHaveRemain(remain);
          StorageController.to.setPasscodeDelay({
            "remain": remain,
            "blockUntil": response.data?.blockUntil,
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

  Future<bool> useBiometrics() async {
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
      return false;
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
      return false;
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
      return false;
    }
    bool isEnable = await CommonFn.requestBiometrics();
    logger.d("isEnable: $isEnable");
    return isEnable;
  }
}
