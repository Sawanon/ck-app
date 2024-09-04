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

  void setup() async {
    await getUser();
  }

  void onShare(BuildContext context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final box = context.findRenderObject() as RenderBox?;

    // if (uri.isNotEmpty) {
    //   await Share.shareUri(Uri.parse(uri));
    // } else if (imagePaths.isNotEmpty) {
    //   final files = <XFile>[];
    //   for (var i = 0; i < imagePaths.length; i++) {
    //     files.add(XFile(imagePaths[i], name: imageNames[i]));
    //   }
    //   await Share.shareXFiles(files,
    //       text: text,
    //       subject: subject,
    //       sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    // } else {
    // await Share.share('test na');
    await Share.share(
      "test",
      subject: "test sub",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
    // }
  }

  Future<bool> checkPermission() async {
    try {
      await AppWriteController.to.user;
      isLogin = true;
      setup();
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
    final isLogin = await checkPermission();
    logger.w("isLogin: $isLogin");
    if (isLogin) {
      await requestBioMetrics();
    }
    loading = false;
    update();
  }

  @override
  void onInit() async {
    beforeSetup();
    super.onInit();
  }
}
