import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/model/response/list_my_friends_user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/utils.dart';

class FriendsController extends GetxController {
  List<ListMyFriendsUser> listMyFriends = [];

  Future<void> listMyFriendsUser() async {
    final user = SettingController.to.user;
    if (user == null) {
      return;
    }
    if (user.refCode == null) {
      logger.e("refCode is ${user.refCode}");
      return;
    }
    final response =
        await AppWriteController.to.listMyFriendsUser(user.refCode!);
    if (response.isSuccess) {
      listMyFriends.clear();
      listMyFriends.addAll(response.data!);
      update();
    } else {
      Get.dialog(
        DialogApp(
          title: Text(AppLocale.somethingWentWrong.getString(Get.context!)),
          details: Text(response.message),
          disableConfirm: true,
        ),
      );
    }
  }

  void setup() async {
    await listMyFriendsUser();
  }

  @override
  void onInit() {
    super.onInit();
    setup();
  }
}
