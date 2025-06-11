import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/model/response/get_wheel_active.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/wheel/view/dialog_reward.dart';
import 'package:lottery_ck/modules/wheel/view/dialog_win.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:google_fonts/google_fonts.dart';

class WheelController extends GetxController {
  RxList<WheelReward> wheelRewards = [
    WheelReward(
      $id: '0',
      type: 'point',
      order: 1,
      isBigReward: false,
      amount: 10000,
    ),
    WheelReward(
      $id: '1',
      type: 'point',
      order: 2,
      isBigReward: false,
      amount: 1000,
    ),
    WheelReward(
      $id: '1',
      type: 'point',
      order: 3,
      isBigReward: false,
      amount: 5000,
    ),
    WheelReward(
      $id: '1',
      type: 'point',
      order: 4,
      isBigReward: false,
      amount: 10000,
    ),
  ].obs;
  RxBool isLoading = true.obs;
  RxBool disabledSpin = true.obs;
  RxString wheelId = "".obs;

  Future<Map?> requestReward(String wheelId) async {
    disabledSpin.value = true;
    final user = UserController.to.user.value;
    if (user == null) {
      LayoutController.to.showDialogLogin();
      return null;
    }
    final response = await AppWriteController.to.requestReward(
      user.userId,
      wheelId,
    );
    logger.w(response.data);
    final result = response.data;
    if (result == null) {
      return null;
    }
    final amount = result['reward']['amount'];
    if (amount is num == false) {
      logger.e("amount is num: ${amount is num}");
      return null;
    }
    disabledSpin.value = true;
    return response.data;
  }

  Future<void> checkMyReward(String wheelId) async {
    final user = UserController.to.user.value;
    if (user == null) {
      LayoutController.to.showDialogLogin();
      return;
    }
    logger.w(user.userId);
    logger.w(wheelId);
    final response =
        await AppWriteController.to.getMyReward(user.userId, wheelId);
    logger.w("my reward");
    logger.d(response.data);
    final result = response.data;
    if (response.isSuccess && result == null) {
      disabledSpin.value = false;
      return;
    }
    final rewardIndex = wheelRewards.value
        .indexWhere((reward) => reward.$id == result!['rewardId']);
    if (rewardIndex == -1) {
      return;
    }
    logger.w("index: $rewardIndex");
    Get.dialog(
      DialogReward(
        reward: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              CommonFn.parseMoney(wheelRewards[rewardIndex].amount!),
              style: TextStyle(
                color: AppColors.wheelText,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppLocale.point.getString(Get.context!),
              style: TextStyle(
                color: AppColors.wheelText,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void setup() async {
    isLoading.value = true;
    final response = await AppWriteController.to.getWheelActive();
    final data = response.data;
    if (data == null) {
      return;
    }
    wheelRewards.value = data.wheelRewards;
    wheelId.value = data.$id;
    await checkMyReward(data.$id);
    isLoading.value = false;
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
