import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/model/user_point.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/utils.dart';

class PointController extends GetxController {
  RxList<UserPoint> userPointList = <UserPoint>[].obs;
  RxInt totalPoint = 0.obs;
  RxBool isLoadingPoint = true.obs;
  UserApp? userApp;
  ScrollController scrollController = ScrollController();
  bool loadingPoint = false;

  void listPoints([int offset = 0]) async {
    final userPointList = await AppWriteController.to.listUserPoint(offset);
    if (userPointList == null) {
      return;
    }
    this.userPointList.value = userPointList;
    isLoadingPoint.value = false;
  }

  String renderType(String type, BuildContext context) {
    if (type.toLowerCase().contains("random")) {
      // return "ไพ่มงคล";
      return AppLocale.randomCard.getString(context);
    }
    switch (type.toLowerCase()) {
      case "buyPromotion":
        return AppLocale.buyLottery.getString(context);
      case "daily":
        return AppLocale.horoscope.getString(context);
      case "buyLottery":
        return AppLocale.buyLottery.getString(context);
      // case "register":
      //   return "สมัครใหม่";
      case "friendBuy":
        return AppLocale.pointsFromFriendsPurchases.getString(context);
      case "kyc":
        return AppLocale.identityVerification.getString(context);
      default:
        if (type.contains("daily")) {
          return type.split("|").last;
        }
        return type;
    }
  }

  void loadMore() async {
    logger.d("load more");
    loadingPoint = true;
    update();
    final offset = this.userPointList.value.length;
    logger.d("offset: $offset");
    final userPointList = await AppWriteController.to.listUserPoint(offset);
    logger.d(userPointList);
    this.userPointList.value.addAllIf(userPointList != null, userPointList!);
    loadingPoint = false;
    update();
  }

  void setupTotalPoint() {
    totalPoint.value = SettingController.to.user?.point ?? 0;
    // totalPoint.value = userPointList.fold(
    //     0, (previousValue, element) => previousValue + element.point);
  }

  @override
  void onInit() {
    userApp = LayoutController.to.userApp;
    scrollController.addListener(
      () {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !loadingPoint) {
          loadMore();
        }
      },
    );
    listPoints();
    setupTotalPoint();
    super.onInit();
  }
}
