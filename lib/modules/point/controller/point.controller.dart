import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/controller/user_controller.dart';
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

  // void test() {
  //   final test = {
  //     "random": {
  //       "lo": "ບັດໂຊກ",
  //       "th": "ไพ่นำโชค",
  //       "en": "Lucky Cards",
  //     },
  //     "buypromotion": {
  //       "lo": "ໄດ້ຄະແນນກັບຄືນ",
  //       "th": "รับคะแนนคืน",
  //       "en": "Get points back",
  //     },
  //     "daily": {
  //       "lo": "ດູດວງ",
  //       "th": "ดูดวง",
  //       "en": "Horoscope",
  //     },
  //     "buylottery": {
  //       "lo": "ຊື້ຫວຍ",
  //       "th": "ซื้อหวย",
  //       "en": "Lottery",
  //     },
  //     "friendbuy": {
  //       "lo": "ຄະແນນຈາກການຊື້ຂອງຫມູ່ເພື່ອນ",
  //       "th": "คะแนนจากยอดซื้อของเพื่อน",
  //       "en": "Points from friends' purchases",
  //     },
  //     "kyc": {
  //       "lo": "ການລະບຸຕົວຕົນ",
  //       "th": "การยืนยันตัวตน",
  //       "en": "Identity verification",
  //     },
  //   };
  // }

  String renderType(String type, BuildContext context) {
    if (type.toLowerCase().contains("wheelreward")) {
      return AppLocale.wheelOfFortuneBonus.getString(context);
    }
    if (type.toLowerCase().contains("random")) {
      // return "ไพ่มงคล";
      return AppLocale.randomCard.getString(context);
    }
    if (type.toLowerCase().contains("bankpromotion")) {
      final result = type.split(":");
      String bank = "";
      if (result.length > 1) {
        bank = result[1];
      }
      return "${AppLocale.pointsFromPayment.getString(context)} $bank";
    }
    switch (type.toLowerCase()) {
      case "buypromotion":
        return AppLocale.getPointsBack.getString(context);
      case "daily":
        return AppLocale.horoscope.getString(context);
      case "buylottery":
        return AppLocale.buyLottery.getString(context);
      // case "register":
      //   return "สมัครใหม่";
      case "friendbuy":
        return AppLocale.pointsFromFriendsPurchases.getString(context);
      case "kyc":
        return AppLocale.identityVerificationBonus.getString(context);
      case "register":
        return AppLocale.registerBonus.getString(context);
      case "topup":
        return AppLocale.topupPoints.getString(context);
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
    totalPoint.value = UserController.to.user.value?.point ?? 0;
    // totalPoint.value = userPointList.fold(
    //     0, (previousValue, element) => previousValue + element.point);
  }

  @override
  void onInit() {
    userApp = UserController.to.user.value;
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

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
