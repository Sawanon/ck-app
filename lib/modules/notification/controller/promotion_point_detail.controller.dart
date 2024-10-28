import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class PromotionPointDetailController extends GetxController {
  static PromotionPointDetailController get to => Get.find();
  final argument = Get.arguments;
  Map? promotionPoint;
  Future<void> getPromotion() async {
    try {
      final promotionId = argument['promotionId'];
      final promotion =
          await AppWriteController.to.getPromotionPoint(promotionId);
      promotionPoint = promotion;
      update();
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  @override
  void onInit() {
    getPromotion();
    super.onInit();
  }
}
