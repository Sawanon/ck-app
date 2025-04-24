import 'dart:typed_data';
import 'dart:io' as io;

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottery_ck/components/dev/dialog_otp.dart';
import 'package:lottery_ck/model/get_argument/otp.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/pin/view/pin_verify.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image/image.dart' as img;

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
  RxBool isLoadingProfile = false.obs;
  List<Map> userGroups = [];
  RxInt point = 0.obs;

  Future<void> logout() async {
    await AppWriteController.to.logout();
    user = null;
    update();
    HomeController.to.updateController();
    profileByte.value = null;
    // Get.offAllNamed(RouteName.login);
    // LayoutController.to.changeTab(TabApp.home);
  }

  Future<void> getKYC() async {
    if (user == null) return;
    final kycData = await AppWriteController.to.getKYC(user!.userId);
    this.kycData = kycData;
    update();
  }

  Future<void> getPoint() async {
    final user = this.user;
    if (user == null) {
      return;
    }
    final responsePoint = await AppWriteController.to.getPoint(user.userId);
    if (responsePoint.isSuccess == false) {
      Get.rawSnackbar(message: responsePoint.message);
      return;
    }
    logger.w("new point: ${responsePoint.data ?? 0}");
    this.user?.point = responsePoint.data ?? 0;
    point.value = responsePoint.data ?? 0;
  }

  Future<void> getUser([bool forceReloadProfile = false]) async {
    final user = await AppWriteController.to.getUserApp();
    if (user == null) return;
    this.user = user;
    getPoint();
    await listGroup(user.userId);
    AppWriteController.to.subscribeTopic(user.userId);
    update();
    getProfileImage(user, forceReloadProfile);
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

  Future<void> listGroup(String userId) async {
    final response = await AppWriteController.to.listMyGroup(userId);
    if (response == null) {
      logger.e("can't list user groups: listGroup SettingController");
      return;
    }
    userGroups = response;
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
          "disabledBioMetrics": true,
          "userId": user!.userId,
          "whenSuccess": () {
            logger.d("pin verify successful");
            String? otpRef;
            Get.offNamed(
              RouteName.otp,
              arguments: OTPArgument(
                action: OTPAction.changePasscode,
                phoneNumber: user!.phoneNumber,
                onInit: () async {
                  final response =
                      await AppWriteController.to.getOTPUser(user!.phoneNumber);
                  if (response.isSuccess == false || response.data == null) {
                    return null;
                  }
                  final data = response.data!;
                  // Get.dialog(
                  //   DialogOtpComponent(otp: data.otp),
                  // );
                  otpRef = data.otpRef;
                  return data.otpRef;
                },
                whenConfirmOTP: (otp) async {
                  final response = await AppWriteController.to
                      .confirmOTPUser(user!.userId, otp, otpRef!);
                  if (response == null) {
                    Get.rawSnackbar(message: "resposne is empty");
                    return;
                  }
                  if (response['status'] == 200) {
                    Get.offNamed(RouteName.pin, arguments: {
                      "userId": user!.userId,
                      "whenSuccess": () {
                        Get.back();
                        logger.d("change passcode successful");
                        Get.snackbar(
                          AppLocale.passcodeChangedSuccessfully
                              .getString(Get.context!),
                          "",
                          backgroundColor: Colors.green.shade700,
                          colorText: Colors.white,
                        );
                      }
                    });
                  }
                },
              ),
            );
          }
        },
      );
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  Future<io.File> resizeImage(io.File imageFile, int newWidth) async {
    imageFile.readAsBytes();
    final image = img.decodeImage(imageFile.readAsBytesSync());
    final resizedImage = img.copyResize(image!, width: newWidth);
    final resizedFile = io.File(imageFile.path)
      ..writeAsBytesSync(img.encodeJpg(resizedImage));
    return resizedFile;
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    await Future.delayed(
      const Duration(seconds: 1),
      () async {
        if (pickedFile != null) {
          isLoadingProfile.value = true;
          final originImage =
              await FlutterExifRotation.rotateImage(path: pickedFile.path);
          final resizeImaged = await resizeImage(originImage, 400);

          final ogLength = originImage.lengthSync();
          final resizeLength = resizeImaged.lengthSync();
          logger.d("ogLength: $ogLength");
          logger.d("resizeLength: $resizeLength");

          final bucketAndId =
              await AppWriteController.to.changeProfileImage(resizeImaged.path);
          logger.d(bucketAndId);
          Get.snackbar(
            AppLocale.profilePictureChangedSuccessfully.getString(Get.context!),
            "",
            backgroundColor: Colors.green.shade700,
            colorText: Colors.white,
          );
          getLostData();
          getUser(true);
          isLoadingProfile.value = false;
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
              String? otpRef;
              Get.toNamed(
                RouteName.otp,
                arguments: OTPArgument(
                  action: OTPAction.changePhone,
                  phoneNumber: newPhoneNumber!,
                  onInit: () async {
                    // final responseOTPRef =
                    //     await AppWriteController.to.getOTPUser(newPhoneNumber!);
                    // otpRef = responseOTPRef;
                    // return responseOTPRef;
                    final result =
                        await AppWriteController.to.getOTP(newPhoneNumber!);
                    logger.d("otp: ${result?.otp}");
                    logger.d("otpRef: ${result?.otpRef}");
                    if (result == null) {
                      return null;
                    }
                    // Get.dialog(
                    //   DialogOtpComponent(otp: result.otp),
                    // );
                    otpRef = result.otpRef;
                    return result.otpRef;
                  },
                  whenConfirmOTP: (otp) async {
                    // final response = await AppWriteController.to
                    //     .confirmOTPUser(user!.userId, otp, otpRef!);
                    // if (response == null) {
                    //   Get.rawSnackbar(message: "response is empty");
                    //   return;
                    // }
                    final result = await AppWriteController.to
                        .confirmOTP(newPhoneNumber!, otp, otpRef!);
                    if (result) {
                      final response = await AppWriteController.to
                          .updateUserPhone(newPhoneNumber!, user!.userId);
                      if (response == null) {
                        Get.back();
                        Get.back();
                        await Future.delayed(const Duration(milliseconds: 350),
                            () {
                          // Get.snackbar(
                          //   "Update phone number failed",
                          //   AppLocale.pleaseContactUserService
                          //       .getString(Get.context!),
                          //   margin: const EdgeInsets.all(8),
                          //   backgroundColor: Colors.red,
                          //   colorText: Colors.white,
                          // );
                        });
                        return;
                      }
                      Get.back();
                      Get.back();
                      Get.snackbar(
                        AppLocale.successfullyChangedPhoneNumber
                            .getString(Get.context!),
                        "",
                        margin: const EdgeInsets.all(8),
                        backgroundColor: Colors.green.shade700,
                        colorText: Colors.white,
                      );
                      getUser();
                    }
                  },
                ),
                // arguments: {
                //   "phoneNumber": newPhoneNumber,
                //   "whenSuccess": () async {
                //     logger.d("message: otp");
                //     final response = await AppWriteController.to
                //         .updateUserPhone(newPhoneNumber!);
                //     if (response == null) {
                //       Get.snackbar(
                //         "Update phone number failed",
                //         "please try again later",
                //         margin: const EdgeInsets.all(8),
                //         backgroundColor: Colors.red,
                //         colorText: Colors.white,
                //       );
                //       Get.back();
                //       Get.back();
                //       return;
                //     }
                //     Get.back();
                //     Get.back();
                //     Get.snackbar(
                //       "Change phone number success",
                //       "message",
                //       margin: const EdgeInsets.all(8),
                //       backgroundColor: Colors.green.shade700,
                //       colorText: Colors.white,
                //     );
                //     getUser();
                //   }
                // },
              );
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
      // do not thing
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
