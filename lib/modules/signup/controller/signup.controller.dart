import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/gender_radio.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/model/response/find_influencer.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/signup/view/influencer_card.dart';
import 'package:lottery_ck/repository/user_repository/user.repository.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class SignupController extends GetxController {
  String firstName = '';
  String lastName = '';
  String address = '';
  DateTime? birthDate;
  TimeOfDay? birthTime;
  Gender? gender;
  bool unknowBirthTime = false;
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final argument = Get.arguments;
  RxBool isLoading = false.obs;
  String inviteCode = "";
  RxInt process = 10.obs;
  RxInt currentIndex = 0.obs;
  final List<IconData> icons = [
    Icons.document_scanner_rounded,
    Icons.person_rounded,
  ];
  Timer? iconTimer;

  Future<void> register(BuildContext context) async {
    if (keyForm.currentState != null && keyForm.currentState!.validate()) {
      if (inviteCode != "" && inviteCode.length >= 5) {
        isLoading.value = true;
        final responseVerifyInfluencer = await getInfluencerData(inviteCode);
        isLoading.value = false;
        // Get.rawSnackbar(
        //   message: "response is $responseVerifyInfluencer",
        // );
        // if (responseVerifyInfluencer == false) {
        //   return;
        // }
        logger.w(responseVerifyInfluencer?.toJson());
        if (responseVerifyInfluencer == null) {
          return;
        }
        Get.dialog(
          InfluencerCard(
            influencerData: responseVerifyInfluencer,
            onConfirm: () async {
              await createUserAppwrite();
            },
          ),
          barrierDismissible: false,
        );
        return;
      }
      submitting(true);
      await createUserAppwrite();
      submitting(false);
    }
  }

  void submitting(bool value) {
    if (value) {
      isLoading.value = true;
      iconTimer = Timer.periodic(
        const Duration(seconds: 2),
        (timer) {
          if (currentIndex.value >= (icons.length - 1)) {
            currentIndex.value = 0;
            return;
          }
          currentIndex.value++;
        },
      );
    } else {
      Future.delayed(
        1500.ms,
        () {
          isLoading.value = value;
          setProcess(0);
        },
      );
      iconTimer?.cancel();
      logger.w("cancel timer");
    }
  }

  void setProcess(int value) {
    process.value = value;
  }

  Future<void> createUserAppwrite() async {
    // go to OTP when sucecess run function - sawanon:20240806
    try {
      setProcess(20);
      // return;
      if (birthDate == null) {
        Get.rawSnackbar(
          message: AppLocale.pleaseEnterBirthDate.getString(Get.context!),
        );
        return;
      }
      if (gender == null) {
        Get.rawSnackbar(
            message: AppLocale.pleaseChooseGender.getString(Get.context!));
        return;
      }
      if (inviteCode != "" && inviteCode.length >= 5) {
        final responseVerifyInfluencer = await verifyInfluWithCode(inviteCode);
        // Get.rawSnackbar(
        //   message: "response is $responseVerifyInfluencer",
        // );
        setProcess(40);
        if (responseVerifyInfluencer == false) {
          return;
        }
        await StorageController.to.setInfluencerCode(inviteCode);
        setProcess(50);
      }
      // return;
      await StorageController.to.clear();
      final phoneNumber = argument["phoneNumber"] as String;
      final appwriteController = AppWriteController.to;
      final email = '$phoneNumber@ckmail.com';
      final fcm = await FirebaseMessagingController.to.getToken();
      final response = await appwriteController.signUp(
        email,
        firstName,
        lastName,
        email,
        phoneNumber,
        address,
        birthDate!,
        birthTime,
        gender!,
        fcm,
      );
      logger.d("response: $response");
      if (response == null) {
        Get.rawSnackbar(message: "sign up failed");
        return;
      }
      setProcess(60);
      // final session = await appwriteController.createSession(
      //     response.user.$id, response.secret);
      final session = await UserController.to.login(
        userId: response.user.$id,
        secret: response.secret,
      );
      if (session == null) {
        Get.rawSnackbar(message: "create session failed");
        return;
      }
      setProcess(70);
      final token = await appwriteController.getToken(phoneNumber);
      logger.d("token: $token");
      if (token == null) {
        Get.rawSnackbar(message: "get token failed");
        return;
      }
      setProcess(80);
      await connectInfluencerWithCode(inviteCode);
      setProcess(100);
      // if (user != null) {
      // Get.delete<UserStore>();
      Get.toNamed(
        RouteName.pin,
        arguments: {
          'userId': response.user.$id,
          'whenSuccess': () async {
            // await CommonFn.requestBiometrics();
            final availableBiometrics = await CommonFn.availableBiometrics();
            logger.d("availableBiometrics: $availableBiometrics");
            if (availableBiometrics) {
              Get.toNamed(RouteName.enableBiometrics, arguments: {
                "whenSuccess": () async {
                  Get.delete<UserStore>();
                  LayoutController.to.intialApp();
                  Get.offAllNamed(RouteName.layout);
                }
              });
              return;
            }
            // Get.delete<BuyLotteryController>();
            // Get.delete<UserStore>();
            LayoutController.to.intialApp();
            Get.offAllNamed(RouteName.layout);
          }
        },
      );
      return;
      // }
    } catch (e) {
      logger.e(e);
    }
  }

  Future<FindInfluencer?> getInfluencerData(String inviteCode) async {
    final responseFindInfuencer =
        await AppWriteController.to.findInfluencer(inviteCode);
    if (responseFindInfuencer.isSuccess == false) {
      Get.dialog(
        DialogApp(
          title: Text(AppLocale.somethingWentWrong.getString(Get.context!)),
          details: Text(
            responseFindInfuencer.message,
          ),
          disableConfirm: true,
        ),
      );
      return null;
    }
    return responseFindInfuencer.data;
  }

  Future<bool> verifyInfluWithCode(String inviteCode) async {
    final responseFindInfuencer =
        await AppWriteController.to.findInfluencer(inviteCode);
    if (responseFindInfuencer.isSuccess == false) {
      Get.dialog(
        DialogApp(
          title: Text(AppLocale.somethingWentWrong.getString(Get.context!)),
          details: Text(
            responseFindInfuencer.message,
          ),
          disableConfirm: true,
        ),
      );
      return false;
    }
    return true;
  }

  Future<bool> connectInfluencerWithCode(String inviteCode) async {
    int attempt = 0;
    const int maxRetry = 3;
    String? myRefCode;
    while (attempt < maxRetry) {
      try {
        final user = await AppWriteController.to.getUserApp();
        logger.d("refCode");
        logger.w(user?.refCode);
        myRefCode = user?.refCode;
        break;
      } catch (e) {
        attempt++;
        logger.w('Attempt $attempt failed: $e');
        if (attempt >= maxRetry) {
          break; // ❌ ครบแล้ว ยัง fail → โยน error ต่อ
        }
        await Future.delayed(500.ms); // ⏱ รอแป๊บนึงก่อน retry
      }
    }
    if (myRefCode == null) {
      logger.e("myRefCode is $myRefCode");
      return false;
    }
    final influencerRefCode =
        await AppWriteController.to.findInfluencer(inviteCode);
    influencerRefCode.data?.refCode;
    if (influencerRefCode.data == null) {
      return false;
    }
    final responseConnectInfluencer = await AppWriteController.to.connectFriend(
      influencerRefCode.data!.refCode,
      myRefCode,
    );
    final responseAcceptInfluencer = await AppWriteController.to.acceptFriend(
      influencerRefCode.data!.refCode,
      myRefCode,
    );
    logger.d("response connect");
    logger.w(responseConnectInfluencer.isSuccess);
    logger.w(responseConnectInfluencer.message);
    logger.d("response accept");
    logger.w(responseAcceptInfluencer.isSuccess);
    logger.w(responseAcceptInfluencer.message);
    return true;
  }

  void changeBirthDate(DateTime? datetime) {
    if (datetime == null) return;
    birthDate = datetime;
    update();
  }

  void changeBirthTime(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return;
    birthTime = timeOfDay;
    update();
  }

  void changeUnknownBirthTime(bool unknown) {
    logger.d('unknown: $unknown');
    unknowBirthTime = unknown;
    update();
  }

  void changeGender(Gender gender) {
    this.gender = gender;
  }

  @override
  void onInit() {
    logger.d(argument["phoneNumber"]);
    super.onInit();
  }

  @override
  void onClose() {
    iconTimer?.cancel();
    logger.w("cancel timer");
    super.onClose();
  }
}
