import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/model/response/list_my_friends_user.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/utils.dart';

class FriendsController extends GetxController {
  List<ListMyFriendsUser> listMyFriends = [];
  List<ListMyFriendsUser> listMyFriendsFiltered = [];
  RxString filter = "".obs;

  Future<void> listMyFriendsUser() async {
    final user = UserController.to.user.value;
    if (user == null) {
      return;
    }
    if (user.refCode == null) {
      logger.e("refCode is ${user.refCode}");
      return;
    }
    final response =
        await AppWriteController.to.listMyFriendsUser(user.refCode!);
    logger.w(response.data);
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

  void onClickFilter(String value) async {
    filter.value = value;
    listMyFriendsFiltered = listMyFriends.where(
      (friend) {
        if (value == "accepted") {
          return friend.isAccept;
        }
        return true;
      },
    ).toList();
    update();
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
