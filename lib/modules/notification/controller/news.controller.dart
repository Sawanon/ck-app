import 'package:get/get.dart';
import 'package:lottery_ck/model/news.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class NewsController extends GetxController {
  static NewsController get to => Get.find();
  final argument = Get.arguments;
  News? news;
  Future<void> getNews() async {
    try {
      final newsId = argument['newsId'];
      final news = await AppWriteController.to.getNews(newsId);
      this.news = news;
      update();
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  @override
  void onInit() {
    getNews();
    super.onInit();
  }
}
