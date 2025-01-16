import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class VideoController extends GetxController {
  List<Map> categoriesList = [];
  Future<void> listCategories() async {
    final response = await AppWriteController.to.listCategories();
    logger.w(response.data);
  }

  void setup() async {
    listCategories();
  }

  void onClickCategory(String value) {
    logger.d(value);
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
