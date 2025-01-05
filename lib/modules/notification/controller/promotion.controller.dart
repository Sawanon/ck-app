import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/utils.dart';

class PromotionController extends GetxController {
  static PromotionController get to => Get.find();
  final argument = Get.arguments;
  Map? promotion;
  Future<void> getPromotion() async {
    try {
      final promotionId = argument['promotionId'];
      final promotion = await AppWriteController.to.getPromotion(promotionId);
      this.promotion = promotion;
      update();
    } catch (e) {
      logger.e("$e");
      Get.rawSnackbar(message: "$e");
    }
  }

  Future<void> collectCoupons() async {
    final promotionId = argument['promotionId'];
    logger.d("promotionId: $promotionId");
    final user = SettingController.to.user;
    if (user?.userId == null) {
      LayoutController.to.showDialogLogin();
    }
    final response = await AppWriteController.to.collectCoupons(
      promotionId,
      user!.userId,
    );
  }

  @override
  void onInit() {
    getPromotion();
    super.onInit();
  }
}
