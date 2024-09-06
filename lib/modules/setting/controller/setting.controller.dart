import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
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

  Future<void> logout() async {
    await AppWriteController.to.logout();
    Get.offAllNamed(RouteName.login);
  }

  Future<void> getUser() async {
    final user = await AppWriteController.to.getUserApp();
    if (user == null) return;
    this.user = user;
    update();
  }

  Future<void> setup() async {
    await getUser();
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

  Future<bool> requestBioMetrics() async {
    if (LayoutController.to.isUsedBiometrics) {
      return true;
    }
    final isEnable = await CommonFn.requestBiometrics();
    LayoutController.to.isUsedBiometrics = isEnable;
    return isEnable;
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
    await AppWriteController.to.feedBackApp(rating, comment);
    Get.back();
  }

  @override
  void onInit() async {
    // beforeSetup();
    super.onInit();
  }
}
