import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dev/dialog_otp.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/model/get_argument/otp.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/couldflare/controller/cloudflare.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:unique_identifier/unique_identifier.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginController extends GetxController {
  final devPhone = "+8562055265064";
  static LoginController get to => Get.find();
  String phoneNumber = '';
  GlobalKey<FormState> keyForm = GlobalKey();
  RxBool disableLogin = true.obs;
  WebViewController? webviewController;

  Future<void> login() async {
    final valid = keyForm.currentState?.validate();
    if (valid == null || valid == false) {
      return;
    }
    logger.d(phoneNumber);
    // return;
    Get.toNamed(RouteName.tc, arguments: {
      "onAccept": () async {
        Map<String, dynamic>? responseUser =
            await AppWriteController.to.getToken(phoneNumber);
        logger.d("responseUser: $responseUser");
        // go to otp for verify then go to enter user info - sawanon:20240807
        if (responseUser == null) {
          Get.snackbar("Something went wrong", "please try again later");
          return;
        }
        if (responseUser['ratelimit'] == true) {
          Get.snackbar("Toomany request", "please try again later");
          return;
        }
        // if (token['status'] == false) {
        //   Get.snackbar("${token['status']}", "");
        // }
        if (responseUser['code'] == "user_notfound") {
          // Get.toNamed(
          gotoSignup();
          return;
        }
        // final isActive = await AppWriteController.to.isActiveUser(phoneNumber);
        final isActive = responseUser['data']['active'];
        // final isActive = true;
        if (!isActive) {
          Get.dialog(
            const DialogApp(
              title: Text("You have been blocked from accessing this service"),
              details: Text(
                  "Unfortunately, your account has been temporarily suspended. Please contact our support team for assistance"),
              disableConfirm: true,
            ),
          );
          return;
        }
        // Get.delete<CloudFlareController>();
        getOTPandCreatePin(responseUser);
      }
    });
  }

  void gotoSignup() {
    String? otpRef;
    Get.offNamed(
      RouteName.otp,
      arguments: OTPArgument(
        action: OTPAction.signUp,
        phoneNumber: phoneNumber,
        onInit: () async {
          final result = await AppWriteController.to.getOTP(phoneNumber);
          if (result == null) {
            return null;
          }
          otpRef = result.otpRef;
          Get.dialog(
            DialogOtpComponent(
              otp: result.otp,
            ),
          );
          return result.otpRef;
        },
        whenConfirmOTP: (otp) async {
          final result =
              await AppWriteController.to.confirmOTP(phoneNumber, otp, otpRef!);
          if (result) {
            Get.offNamed(RouteName.signup, arguments: {
              "phoneNumber": phoneNumber,
            });
          }
        },
      ),
      // arguments: {
      //   "action": "signup",
      //   "phoneNumber": phoneNumber,
      //   "whenSuccess": () {
      //     Get.offNamed(RouteName.signup, arguments: {
      //       "phoneNumber": phoneNumber,
      //     });
      //   }
      // },
    );
    Get.delete<CloudFlareController>();
  }

  Future<void> getOTPandCreatePin(Map<String, dynamic> responseUser) async {
    // Get.toNamed(
    if (phoneNumber == devPhone) {
      gotoPinverifyDev(responseUser['data']['userId']);
      return;
    }
    String? otpRef;
    Get.offNamed(
      RouteName.otp,
      arguments: OTPArgument(
        action: OTPAction.signIn,
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
          final result = await AppWriteController.to
              .confirmOTPUser(responseUser['data']['userId'], otp, otpRef!);
          logger.d(result);
          if (result == null) return;
          final secret = result['data']['secret'];

          Get.snackbar("OTP verify successfully !", "");
          Get.offNamed(
            // RouteName.pin,
            RouteName.pinVerify,
            arguments: {
              "userId": responseUser['data']["userId"],
              "enableForgetPasscode": true,
              "whenForgetPasscode": () async {
                Get.rawSnackbar(message: "verify otp");
                Get.toNamed(
                  RouteName.otp,
                  arguments: OTPArgument(
                    action: OTPAction.changePasscode,
                    phoneNumber: phoneNumber,
                    onInit: () async {
                      final response =
                          await AppWriteController.to.getOTPUser(phoneNumber);
                      if (response.isSuccess == false ||
                          response.data == null) {
                        Get.dialog(
                          DialogApp(
                            title: Text(AppLocale.somethingWentWrong
                                .getString(Get.context!)),
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
                      final result = await AppWriteController.to.confirmOTPUser(
                          responseUser['data']['userId'], otp, otpRef!);
                      logger.d(result);
                      if (result == null) return;
                      final secret = result['data']['secret'];
                      Get.toNamed(
                        RouteName.changePasscode,
                        arguments: {
                          "userId": responseUser['data']['userId'],
                          "whenSuccess": () async {
                            final session = await AppWriteController.to
                                .createSession(
                                    responseUser['data']["userId"], secret);
                            if (session == null) {
                              Get.snackbar(
                                "Something went wrong login:65",
                                "session is null Please try again later or plaese contact admin",
                              );
                              // navigator?.pop();
                              return;
                            }
                            final availableBiometrics =
                                await CommonFn.availableBiometrics();
                            if (availableBiometrics) {
                              Get.toNamed(RouteName.enableBiometrics,
                                  arguments: {
                                    "whenSuccess": () async {
                                      LayoutController.to.intialApp();
                                      Get.offAllNamed(RouteName.layout);
                                      return;
                                    }
                                  });
                              return;
                            }
                            LayoutController.to.intialApp();
                            Get.offAllNamed(RouteName.layout);
                          }
                        },
                      );
                      //
                    },
                  ),
                );
              },
              "whenSuccess": () async {
                final session = await AppWriteController.to
                    .createSession(responseUser['data']["userId"], secret);
                if (session == null) {
                  Get.snackbar(
                    "Something went wrong login:65",
                    "session is null Please try again later or plaese contact admin",
                  );
                  // navigator?.pop();
                  return;
                }
                final availableBiometrics =
                    await CommonFn.availableBiometrics();
                if (availableBiometrics) {
                  Get.toNamed(RouteName.enableBiometrics, arguments: {
                    "whenSuccess": () async {
                      LayoutController.to.intialApp();
                      Get.offAllNamed(RouteName.layout);
                      return;
                    }
                  });
                  return;
                }
                LayoutController.to.intialApp();
                Get.offAllNamed(RouteName.layout);
              }
            },
          );
        },
      ),
    );
  }

  Future<void> logout() async {
    logger.d("logout");
    final appwriteController = AppWriteController.to;
    await appwriteController.logout();
  }

  void gotoPinverifyDev(String userId) {
    Get.offNamed(
      // RouteName.pin,
      RouteName.pinVerify,
      arguments: {
        "userId": userId,
        "enableForgetPasscode": true,
        "whenForgetPasscode": () async {
          Get.rawSnackbar(message: "verify otp");
          Get.toNamed(
            RouteName.otp,
            arguments: OTPArgument(
              action: OTPAction.changePasscode,
              phoneNumber: phoneNumber,
              onInit: () async {
                return "devacc";
              },
              whenConfirmOTP: (otp) async {
                // final session =
                //     await AppWriteController.to.createSession(userId, secret);
                final session = await AppWriteController.to.login(
                  "+8562055265064@ckmail.com",
                  "+8562055265064",
                );
                if (session == null) {
                  Get.snackbar(
                    "Something went wrong login:65",
                    "session is null Please try again later or plaese contact admin",
                  );
                  navigator?.pop();
                  return;
                }
                final availableBiometrics =
                    await CommonFn.availableBiometrics();
                if (availableBiometrics) {
                  Get.toNamed(RouteName.enableBiometrics, arguments: {
                    "whenSuccess": () async {
                      LayoutController.to.intialApp();
                      Get.offAllNamed(RouteName.layout);
                      return;
                    }
                  });
                  return;
                }
                LayoutController.to.intialApp();
                Get.offAllNamed(RouteName.layout);
              },
            ),
          );
        },
        "whenSuccess": () async {
          // final session = await AppWriteController.to
          //     .createSession(responseUser['data']["userId"], secret);
          final session = await AppWriteController.to.login(
            "+8562055265064@ckmail.com",
            "+8562055265064",
          );
          if (session == null) {
            Get.snackbar(
              "Something went wrong login:65",
              "session is null Please try again later or plaese contact admin",
            );
            // navigator?.pop();
            return;
          }
          final availableBiometrics = await CommonFn.availableBiometrics();
          if (availableBiometrics) {
            Get.toNamed(RouteName.enableBiometrics, arguments: {
              "whenSuccess": () async {
                LayoutController.to.intialApp();
                Get.offAllNamed(RouteName.layout);
                return;
              }
            });
            return;
          }
          LayoutController.to.intialApp();
          Get.offAllNamed(RouteName.layout);
        }
      },
    );
  }

  void checkDevice() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        // logger.f('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
        final allInfo = await deviceInfo.deviceInfo;
        // logger.f("serialNumber: ${allInfo.data["serialNumber"]}");
        // logger.f("isPhysicalDevice: ${allInfo.data["isPhysicalDevice"]}");
        // logger.f(allInfo.data);
        final identifier = await UniqueIdentifier.serial;
        // logger.f("identifier: $identifier");
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        // logger.f('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
        final allInfo = await deviceInfo.deviceInfo;
        // logger.f(allInfo.data);
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        "Not allow this platform",
        "please contact admin",
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }
  }

  void setDisableButton() {
    logger.d("boom!");
    disableLogin.value = false;
  }

  @override
  void onInit() {
    Get.put<AppWriteController>(AppWriteController());
    final cloudflareController = CloudFlareController.to;
    cloudflareController.setCallback(setDisableButton);
    webviewController = cloudflareController.controllerWebview;
    // checkDevice();
    super.onInit();
  }
}
