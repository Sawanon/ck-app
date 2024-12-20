import 'package:get/get.dart';
import 'package:lottery_ck/model/news.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  RxList<News> newsList = <News>[].obs;
  RxList<Map> promotionList = <Map>[].obs;

  Future<void> listNews() async {
    final newsList = await AppWriteController.to.listNews();
    if (newsList != null) {
      this.newsList.value = newsList;
    }
  }

  Future<void> listPromotions() async {
    final promotionListData = await AppWriteController.to.listPromotions();
    List<Map> allPromotionList = [];
    if (promotionListData != null) {
      allPromotionList = promotionListData
          .map((promotion) => {...promotion, "promotionType": "promotions"})
          .toList();
    }
    // if (promotionListData != null) {
    //   promotionList.value = promotionListData;
    // }
    final promotionsPointsList =
        await AppWriteController.to.listPromotionsPoints();
    if (promotionsPointsList != null) {
      for (var promotionsPoints in promotionsPointsList) {
        allPromotionList.add({...promotionsPoints, "promotionType": "points"});
      }
    }
    // logger.d(allPromotionList);
    allPromotionList.sort(
      (a, b) {
        return DateTime.parse(b['start_date'])
            .compareTo(DateTime.parse(a['start_date']));
      },
    );
    // logger.d(allPromotionList);
    promotionList.value = allPromotionList;
  }

  void openNewsDetail(String newsId) {
    Get.toNamed(
      RouteName.news,
      arguments: {
        "newsId": newsId,
      },
    );
  }

  void openPromotionDetail(String promotionId) {
    Get.toNamed(
      RouteName.promotion,
      arguments: {
        "promotionId": promotionId,
      },
    );
  }

  void openPromotionPointsDetail(String promotionPointsId) {
    Get.toNamed(
      RouteName.promotionPoint,
      arguments: {
        "promotionId": promotionPointsId,
      },
    );
  }

  @override
  void onInit() {
    listNews();
    listPromotions();
    super.onInit();
  }
}
