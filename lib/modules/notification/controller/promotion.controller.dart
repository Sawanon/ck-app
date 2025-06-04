import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/controller/user_controller.dart';
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
  bool alreadyCollectedCoupon = true;
  bool isLoading = false;

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

  void setIsLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> collectCoupons() async {
    final promotionId = argument['promotionId'];
    logger.d("promotionId: $promotionId");
    final user = UserController.to.user.value;
    if (user?.userId == null) {
      LayoutController.to.showDialogLogin();
    }
    setIsLoading(true);
    final response = await AppWriteController.to.collectCoupons(
      promotionId,
      user!.userId,
    );
    setIsLoading(false);
    logger.d(response.data);
    if (response.isSuccess) {
      Get.rawSnackbar(
        message:
            AppLocale.collectedTheCouponSuccessfully.getString(Get.context!),
      );
      alreadyCollectedCoupon = true;
      update();
    }
  }

  bool disabledCoupon(String? promotionId) {
    try {
      logger.w("promotionId: $promotionId");
      if (couponsList.isEmpty) {
        return false;
      }
      final resultWhereCoupon = couponsList.where(
        (coupon) {
          return coupon.promotionId == promotionId;
        },
      ).toList();
      if (resultWhereCoupon.isNotEmpty) {
        final isReUse = promotion?['is_reuse'] ?? false;
        logger.w("isReUse: $isReUse");
        if (isReUse) {
          final notUseCoupon = resultWhereCoupon
              .where((coupon) => coupon.isUse == false)
              .toList();
          if (notUseCoupon.isEmpty) {
            alreadyCollectedCoupon = false;
            update();
          }
        }
        return true;
      } else {
        alreadyCollectedCoupon = false;
        update();
      }
      return false;
    } catch (e) {
      logger.e('disabledCoupon: $e');
      return false;
    }
  }

  Future<void> listMyCoupons() async {
    logger.d("listMyCoupons");
    final user = UserController.to.user.value;
    if (user == null) {
      return;
    }
    final response = await AppWriteController.to.listAllMyCoupons(user.userId);
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
    logger.w(coupons);
    if (coupons == null || coupons.isEmpty) {
      logger.e("coupon is empty");
      alreadyCollectedCoupon = false;
      update();
      return;
    }
    logger.d(coupons);
    couponsList.clear();
    couponsList.addAll(coupons);
    final promotionId = argument['promotionId'];
    final result = disabledCoupon(promotionId);
    logger.w("result: $result");
  }

  void setup() async {
    // setIsLoading(true);
    await getPromotion();
    await listMyCoupons();
    // setIsLoading(false);
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
