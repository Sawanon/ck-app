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
    logger.d(newsList);
    if (newsList != null) {
      this.newsList.value = newsList;
    }
  }

  Future<void> listPromotions() async {
    final promotionList = await AppWriteController.to.listPromotions();
    if (promotionList != null) {
      this.promotionList.value = promotionList;
    }
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

  @override
  void onInit() {
    logger.d("message_controller");
    listNews();
    listPromotions();
    super.onInit();
  }
}
