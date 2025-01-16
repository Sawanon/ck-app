import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/model/coupon.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/utils.dart';

class PromotionController extends GetxController {
  static PromotionController get to => Get.find();
  final argument = Get.arguments;
  final List<Coupon> couponsList = [];

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
    logger.d(response.data);
    if (response.isSuccess) {
      Get.rawSnackbar(
        message:
            AppLocale.collectedTheCouponSuccessfully.getString(Get.context!),
      );
    }
  }

  bool disabledCoupon(String? promotionId) {
    try {
      if (couponsList.isEmpty) {
        return false;
      }
      final resultWhereCoupon = couponsList.where(
        (coupon) {
          return coupon.promotionId == promotionId;
        },
      ).toList();
      if (resultWhereCoupon.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e) {
      logger.e('disabledCoupon: $e');
      return false;
    }
  }

  void listMyCoupons() async {
    logger.d("listMyCoupons");
    final user = SettingController.to.user;
    if (user == null) {
      return;
    }
    final response = await AppWriteController.to.listMyCoupons(user.userId);
    if (response.isSuccess == false) {
      Get.dialog(DialogApp(
        title: Text(
          AppLocale.somethingWentWrong.getString(Get.context!),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        details: Text(
          response.message,
        ),
      ));
      return;
    }
    final coupons = response.data;
    if (coupons == null || coupons.isEmpty) {
      logger.e("coupon is empty");
      return;
    }
    logger.d(coupons);
    couponsList.clear();
    couponsList.addAll(coupons);
  }

  @override
  void onInit() {
    getPromotion();
    listMyCoupons();
    super.onInit();
  }
}
