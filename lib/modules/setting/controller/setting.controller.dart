import 'dart:typed_data';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/pin/view/pin_verify.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:share_plus/share_plus.dart';

class SettingController extends GetxController {
  static SettingController get to => Get.find();
  UserApp? user;
  // bool isLogin = true;
  bool loading = false;
  RxBool enabledBiometrics = false.obs;
  File? profileImaeg;
  GlobalKey<FormState> keyFormPhone = GlobalKey();
  GlobalKey<FormState> keyFormAddress = GlobalKey();
  String? newPhoneNumber;
  String? newAddress;
  Rx<Uint8List?> profileByte = Rx<Uint8List?>(null);
  Map? kycData;

  Future<void> logout() async {
    await AppWriteController.to.logout();
    // Get.offAllNamed(RouteName.login);
    LayoutController.to.changeTab(TabApp.home);
  }

  Future<void> getKYC() async {
    if (user == null) return;
    final kycData = await AppWriteController.to.getKYC(user!.userId);
    logger.w(kycData);
    this.kycData = kycData;
    update();
  }

  Future<void> getUser([bool forceReloadProfile = false]) async {
    final user = await AppWriteController.to.getUserApp();
    if (user == null) return;
    this.user = user;
    update();
    getProfileImage(user, forceReloadProfile);
    logger.w(user.isKYC);
    if (user.isKYC != true) {
      await getKYC();
    } else {
      kycData = null;
      update();
    }
  }

  void getProfileImage(UserApp user, [bool forseReload = false]) async {
    if (user.profile == null || user.profile == "") {
      profileByte.value = null;
      return;
    }
    if (profileByte.value != null && forseReload == false) return;
    final fileId = user.profile!.split(":").last;
    final fileByte = await AppWriteController.to.getProfileImage(fileId);
    profileByte.value = fileByte;
  }

  Future<void> setup() async {
    try {
      await getUser();
      enabledBiometrics.value = await StorageController.to.getEnableBio();
    } catch (e) {
      logger.e("$e");
      try {
        Get.rawSnackbar(message: "$e");
      } catch (e) {
        logger.e("$e");
      }
    } finally {
      // loading = false;
      // update();
    }
  }

  void onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      "test",
      subject: "test sub",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  void submitRating(double rating, String? comment) async {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(),
      ),
    );
    final feedbackDocument =
        await AppWriteController.to.feedBackApp(rating, comment);
    Get.back();
    if (feedbackDocument != null) {
      Get.back();
      Get.snackbar(
        "",
        "",
        titleText: Text(
          "ຂອບໃຈຫຼາຍ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          "ຂອບໃຈສໍາລັບຄໍາແນະນໍາຂອງທ່ານ",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      );
      return;
    }
    Get.snackbar("ມີບາງຢ່າງຜິດພາດ", "ກະລຸນາລອງໃໝ່ໃນພາຍຫຼັງ");
  }

  void enableBioMetrics(bool enableBioMetrics) async {
    final deviceIsSupport = await CommonFn.canAuthenticate();
    if (deviceIsSupport == false) {
      Get.rawSnackbar(message: "Your device is not supported");
      return;
    }
    final availableBiosMetrics = await CommonFn.availableBiometrics();
    if (availableBiosMetrics == false) {
      Get.rawSnackbar(
          message: "Please enable BioMetrics in Your device Settings");
      return;
    }
    if (enableBioMetrics) {
      final userApp = LayoutController.to.userApp;
      Get.to(
        PinVerifyPage(disabledBackButton: false),
        arguments: {
          "userId": userApp!.userId,
          "whenSuccess": () async {
            final result = await CommonFn.enableBiometrics();
            logger.d("result: $result");
            await StorageController.to.setEnableBio();
            enabledBiometrics.value = true;
            Get.back();
          }
        },
      );
      return;
    }
    await StorageController.to.setDisableBio();
    enabledBiometrics.value = false;
  }

  void initSettings() async {
    final setting = await AppWriteController.to.listSettings();
    logger.d("setting: $setting");
  }

  void changePasscode() async {
    try {
      Get.to(
        PinVerifyPage(disabledBackButton: false),
        arguments: {
          "userId": user!.userId,
          "whenSuccess": () {
            logger.d("pin verify successful");
            Get.offNamed(RouteName.otp, arguments: {
              "phoneNumber": user!.phoneNumber,
              "whenSuccess": () {
                logger.d("otp verify successful");
                Get.offNamed(RouteName.pin, arguments: {
                  "whenSuccess": () {
                    Get.back();
                    logger.d("change passcode successful");
                    Get.snackbar(
                      "Change passcode success",
                      "message",
                      backgroundColor: Colors.green.shade700,
                      colorText: Colors.white,
                    );
                  }
                });
              }
            });
          }
        },
      );
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    await Future.delayed(
      const Duration(seconds: 1),
      () async {
        if (pickedFile != null) {
          final originImage =
              await FlutterExifRotation.rotateImage(path: pickedFile.path);
          final bucketAndId =
              await AppWriteController.to.changeProfileImage(originImage.path);
          logger.d(bucketAndId);
          Get.snackbar(
            "Change profile image success",
            "",
            backgroundColor: Colors.green.shade700,
            colorText: Colors.white,
          );
          getLostData();
          getUser(true);
          // getProfileImage(user!, true);
        }
      },
    );
  }

  Future<void> getLostData() async {
    final ImagePicker picker = ImagePicker();
    final LostDataResponse response = await picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    final List<XFile>? files = response.files;
    if (files != null) {
      profileImaeg = null;
      // _handleLostFiles(files);
    } else {
      // _handleError(response.exception);
    }
  }

  void changePhoneNumber() async {
    Get.toNamed(
      RouteName.pinVerify,
      arguments: {
        "userId": user!.userId,
        "whenSuccess": () {
          logger.d("success");
          Get.offNamed(RouteName.changePhone, arguments: {
            "whenSuccess": () {
              logger.d("message: changePhone");
              logger
                  .d("keyFormPhone.currentState: ${keyFormPhone.currentState}");
              if (keyFormPhone.currentState != null) {
                if (keyFormPhone.currentState!.validate() == false ||
                    newPhoneNumber == null) {
                  return;
                }
              }
              Get.toNamed(RouteName.otp, arguments: {
                "phoneNumber": newPhoneNumber,
                "whenSuccess": () async {
                  logger.d("message: otp");
                  final response = await AppWriteController.to
                      .updateUserPhone(newPhoneNumber!);
                  if (response == null) {
                    Get.snackbar(
                      "Update phone number failed",
                      "please try again later",
                      margin: const EdgeInsets.all(8),
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    Get.back();
                    Get.back();
                    return;
                  }
                  Get.back();
                  Get.back();
                  Get.snackbar(
                    "Change phone number success",
                    "message",
                    margin: const EdgeInsets.all(8),
                    backgroundColor: Colors.green.shade700,
                    colorText: Colors.white,
                  );
                  getUser();
                }
              });
            }
          });
        }
      },
    );
    return;
  }

  void onChangeNewAddress(String newAddress) {
    if (this.newAddress == null || this.newAddress == "") {
      logger.w("update !");
      update();
    }
    this.newAddress = newAddress;
  }

  void _loading(bool isLoading) {
    loading = isLoading;
    update();
  }

  void updateUserAddress() async {
    try {
      if (keyFormAddress.currentState?.validate() == false ||
          newAddress == null ||
          newAddress == "") {
        return;
      }
      _loading(true);
      final response =
          await AppWriteController.to.updateUserAddress(newAddress!);
      if (response == null) {
        Get.rawSnackbar(message: "something went wrong");
        return;
      }
      Get.back();
      Get.snackbar(
        "Update address success",
        "",
        margin: const EdgeInsets.all(8),
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
      );
      getUser();
    } catch (e) {
      logger.d("$e");
    } finally {
      _loading(false);
    }
  }

  void gotoChangeName() {
    Get.toNamed(
      RouteName.changeName,
    );
  }

  void changeName(String firstName, String lastName) async {
    logger.d("message");
    logger.d(firstName);
    logger.d(lastName);
    final userDocument =
        await AppWriteController.to.changeName(firstName, lastName);
    if (userDocument == null) {
      return;
    }
    getUser();
    Get.back();
  }

  void gotoChangeBirth() {
    Get.toNamed(
      RouteName.changeBirth,
    );
  }

  void changeBirth(DateTime birthDate, TimeOfDay birthTime) async {
    logger.d("message");
    logger.d(birthDate);
    logger.d(birthTime);
    final birthTimeStr =
        "${birthTime.hour.toString().padLeft(2, "0")}:${birthTime.minute.toString().padLeft(2, "0")}";
    final userDocument =
        await AppWriteController.to.changeBirth(birthDate, birthTimeStr);
    if (userDocument == null) {
      return;
    }
    getUser();
    Get.back();
  }

  Future<Document?> changeBirthTime(TimeOfDay birthTime) async {
    final birthTimeStr =
        "${birthTime.hour.toString().padLeft(2, "0")}:${birthTime.minute.toString().padLeft(2, "0")}";
    final userDocument =
        await AppWriteController.to.changeBirth(user!.birthDate, birthTimeStr);
    if (userDocument == null) {
      return null;
    }
    return userDocument;
  }

  void viewKYCDetail() {
    if (kycData == null) return;
    if (kycData!['status'] == "pending") {
      // TODO: goto detail process
      return;
    }
    gotoKYC();
  }

  void gotoKYC() {
    Get.toNamed(RouteName.kyc);
  }

  @override
  void onInit() {
    // initSettings();
    getUser();
    super.onInit();
  }
}
