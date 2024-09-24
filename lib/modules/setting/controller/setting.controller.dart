import 'dart:io';

import 'package:flutter/material.dart';
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
  bool isLogin = false;
  bool loading = true;
  RxBool enabledBiometrics = false.obs;
  File? profileImaeg;

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

  @override
  void onInit() {
    initSettings();
    super.onInit();
  }
}
