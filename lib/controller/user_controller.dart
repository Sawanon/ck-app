import 'dart:typed_data';

import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/firebase/controller/firebase_messaging.controller.dart';
import 'package:lottery_ck/storage.dart';
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
      final userApp = await AppWriteController.to.getUserApp();
      if (userApp == null) {
        return null;
      }
      return userApp;
    } catch (e) {
      logger.e(e);
      return null;
    } finally {
      isLoadingUser.value = false;
    }
  }

  Future<void> reLoadUser(String line) async {
    try {
      logger.w("line use: reLoadUser $line");
      final userApp = await getUser();
      user.value = userApp;
      if (userApp == null) {
        return;
      }
      final profile = await getProfileImage(userApp);
      if (profile == null) return;
      profileByte.value = profile;
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> reloadUserProfile() async {
    try {
      final userApp = user.value;
      if (userApp == null) {
        logger.e("reloadUserProfile: userApp is empty");
        return;
      }
      final profile = await getProfileImage(userApp);
      logger.w("profile:57");
      logger.d(profile);
      if (profile == null) return;
      profileByte.value = profile;
    } catch (e) {
      logger.e(e);
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

  Future<Uint8List?> getProfileImage(UserApp user) async {
    if (user.profile == null || user.profile == "") {
      return null;
    }
    // if (forseReload == false) return null;
    final fileId = user.profile!.split(":").last;
    final fileByte = await AppWriteController.to.getProfileImage(fileId);
    profileByte.value = fileByte;
    return fileByte;
  }

  void clearUser() {
    user.value = null;
    profileByte.value = null;
  }

  Future<Session?> login({
    required String userId,
    required String secret,
  }) async {
    try {
      await StorageController.to.clear();
      final session = await AppWriteController.to.createSession(userId, secret);
      return session;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  Future<void> logout() async {
    await AppWriteController.to.logout();
    clearUser();
  }

  Future<void> listGroupUser(String userId) async {
    try {
      final listGroupMap = await AppWriteController.to.listMyGroup(userId);
      logger.w("listGroupMap");
      if (listGroupMap == null) {
        logger.e("group user is empty");
        return;
      }
      final checkDev = listGroupMap.where((group) => group.name == "Dev test");
      logger.w("checkDev.isNotEmpty: ${checkDev.isNotEmpty}");
      if (checkDev.isNotEmpty) {
        FirebaseMessagingController.to.subscribeToTopic("devtest");
      }
      // return listGroupMap;
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> setup(String line) async {
    logger.w("line use: $line");
    final userApp = await getUser();
    user.value = userApp;
    logger.w("userApp:113");
    logger.d(userApp?.fullName);
    if (userApp == null) {
      return;
    }
    final profile = await getProfileImage(userApp);
    // logger.w("profile:119 is null: ${profile == null}");
    profileByte.value = profile;
    await listGroupUser(userApp.userId);
  }

  @override
  void onInit() {
    setup("user con 151");
    super.onInit();
  }

  @override
  void onClose() {
    user.value = null;
    super.onClose();
  }
}
