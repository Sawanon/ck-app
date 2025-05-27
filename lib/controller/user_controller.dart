import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();
  Rx<UserApp?> user = Rx<UserApp?>(null);
  RxBool isLoadingUser = true.obs;
  Rx<Uint8List?> profileByte = Rx<Uint8List?>(null);

  bool get isLoggedIn => user.value != null;

  Future<UserApp?> getUser() async {
    try {
      isLoadingUser.value = true;
      await Future.delayed(const Duration(seconds: 10), () {});
      final userApp = await AppWriteController.to.getUserApp();
      if (userApp == null) {
        return null;
      }
      return userApp;
    } catch (e) {
      return null;
    } finally {
      isLoadingUser.value = false;
    }
  }

  Future<void> getPoint() async {
    final user = this.user.value;
    if (user == null) {
      return;
    }
    final responsePoint = await AppWriteController.to.getPoint(user.userId);
    if (responsePoint.isSuccess == false) {
      Get.rawSnackbar(message: responsePoint.message);
      return;
    }
    this.user.value?.point = responsePoint.data ?? 0;
  }

  Future<Uint8List?> getProfileImage(UserApp user,
      [bool forseReload = false]) async {
    if (user.profile == null || user.profile == "") {
      // profileByte.value = null;
      return null;
    }
    if (profileByte.value != null && forseReload == false) return null;
    final fileId = user.profile!.split(":").last;
    final fileByte = await AppWriteController.to.getProfileImage(fileId);
    profileByte.value = fileByte;
    return fileByte;
  }

  void setup() async {
    final userApp = await getUser();
    user.value = userApp;
    if (userApp == null) {
      return;
    }
    final profile = await getProfileImage(userApp);
    profileByte.value = profile;
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }

  @override
  void onClose() {
    user.value = null;
    super.onClose();
  }
}
