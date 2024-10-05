import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/pin/view/pin_verify.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:share_plus/share_plus.dart';

class SettingController extends GetxController {
  static SettingController get to => Get.find();
  UserApp? user;
  bool isLogin = false;
  bool loading = true;
  RxBool enabledBiometrics = false.obs;
  File? profileImaeg;
  GlobalKey<FormState> keyFormPhone = GlobalKey();
  GlobalKey<FormState> keyFormAddress = GlobalKey();
  String? newPhoneNumber;
  String? newAddress;

  Future<void> logout() async {
    await AppWriteController.to.logout();
    // Get.offAllNamed(RouteName.login);
    LayoutController.to.changeTab(TabApp.home);
  }

  Future<void> getUser() async {
    final user = await AppWriteController.to.getUserApp();
    if (user == null) return;
    this.user = user;
    update();
  }

  Future<void> setup() async {
    await getUser();
    enabledBiometrics.value = await StorageController.to.getEnableBio();
  }

  void onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(
      "test",
      subject: "test sub",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  Future<bool> checkPermission() async {
    try {
      await AppWriteController.to.user;
      isLogin = true;
      return true;
    } catch (e) {
      logger.e("$e");
      return false;
    }
  }

  void beforeSetup() async {
    try {
      loading = true;
      update();
      final isLogin = await checkPermission();
      // logger.w("isLogin: $isLogin");
      // if (isLogin) {
      //   final isPassBio = await requestBioMetrics();
      //   if (!isPassBio) {
      //     return;
      //   }
      // }
      await setup();
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    } finally {
      loading = false;
      update();
    }
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
      Get.to(PinVerifyPage(disabledBackButton: false), arguments: {
        "whenSuccess": () async {
          final result = await CommonFn.enableBiometrics();
          logger.d("result: $result");
          await StorageController.to.setEnableBio();
          enabledBiometrics.value = true;
          Get.back();
        }
      });
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
      Get.to(PinVerifyPage(disabledBackButton: false), arguments: {
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
      });
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      logger.d("pickedFile: $pickedFile");
      profileImaeg = File(pickedFile.path);
//       setState(() {
//         _image
//  = File(pickedFile.path);
//       });
      update();
      getLostData();
    }
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
    Get.toNamed(RouteName.pinVerify, arguments: {
      "whenSuccess": () {
        logger.d("success");
        Get.offNamed(RouteName.changePhone, arguments: {
          "whenSuccess": () {
            logger.d("message: changePhone");
            logger.d("keyFormPhone.currentState: ${keyFormPhone.currentState}");
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
    });
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

  @override
  void onInit() {
    initSettings();
    super.onInit();
  }
}
