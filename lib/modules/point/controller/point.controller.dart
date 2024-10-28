import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/model/user_point.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/utils.dart';

class PointController extends GetxController {
  RxList<UserPoint> userPointList = <UserPoint>[].obs;
  RxInt totalPoint = 0.obs;
  RxBool isLoadingPoint = true.obs;
  UserApp? userApp;

  void listPoints() async {
    final userPointList = await AppWriteController.to.listUserPoint();
    if (userPointList == null) {
      return;
    }
    this.userPointList.value = userPointList;
    totalPoint.value = userPointList.fold(
        0, (previousValue, element) => previousValue + element.point);
    isLoadingPoint.value = false;
  }

  String renderType(String type, BuildContext context) {
    switch (type.toLowerCase()) {
      case "buylottery":
        return AppLocale.buyLottery.getString(context);
      case "daily":
        return AppLocale.horoscope.getString(context);
      default:
        if (type.contains("daily")) {
          return type.split("|").last;
        }
        return type;
    }
  }

  @override
  void onInit() {
    userApp = LayoutController.to.userApp;
    listPoints();
    super.onInit();
  }
}
