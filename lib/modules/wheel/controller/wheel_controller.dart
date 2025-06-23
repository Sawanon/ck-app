import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/model/response/get_my_reward.dart';
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
    UserController.to.reLoadUser("wheel con 71");
    final amount = result['reward']['amount'];
    if (amount is num == false) {
      logger.e("amount is num: ${amount is num}");
      return null;
    }
    disabledSpin.value = true;
    return response.data;
  }

  Future<GetMyReward?> checkReward(
    String wheelId, [
    List<String> queries = const [],
  ]) async {
    final user = UserController.to.user.value;
    if (user == null) {
      LayoutController.to.showDialogLogin();
      return null;
    }
    final response = await AppWriteController.to.getMyReward(
      user.userId,
      wheelId,
      queries,
    );
    return response.data;
  }

  Future<GetMyReward?> checkMyReward(String wheelId) async {
    final user = UserController.to.user.value;
    if (user == null) {
      LayoutController.to.showDialogLogin();
      return null;
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
      return null;
    }
    final rewardIndex = wheelRewards.value
        .indexWhere((reward) => reward.$id == result?.rewardId);
    logger.w("index: $rewardIndex");
    if (rewardIndex == -1) {
      return null;
    }
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
    return result;
  }

  void setup() async {
    try {
      isLoading.value = true;
      final response = await AppWriteController.to.getWheelActive();
      final data = response.data;
      if (data == null) {
        return;
      }
      final wheelsRegisterType =
          data.where((wheel) => wheel.type == "register").toList();
      final wheelsCheckInType =
          data.where((wheel) => wheel.type == "check-in").toList();
      // ดึงเวลา server มาเช็ค
      final responseCurrentTime = await AppWriteController.to.getCurrentTime();
      final serverDateTime = responseCurrentTime.data;
      if (responseCurrentTime.isSuccess == false || serverDateTime == null) {
        Get.dialog(
          DialogApp(
            title: Text(
              AppLocale.somethingWentWrong.getString(Get.context!),
            ),
            details: Text(
              responseCurrentTime.message,
            ),
            disableConfirm: true,
          ),
        );
        return;
      }
      // มี wheel register
      GetMyReward? registerReward;
      GetMyReward? checkInReward;
      bool allowRegister = false;
      bool dontCheckCheckIn = false;
      bool allowCheckIn = false;
      bool checkInSameDate = false;
      if (wheelsRegisterType.isNotEmpty) {
        final wheelRegisterType = wheelsRegisterType.first;
        final userRewardsRegister = await checkReward(
          wheelRegisterType.$id,
          [
            Query.equal('type', 'register'),
          ],
        );
        logger.w("userRewardsRegister:144");
        logger.d(userRewardsRegister?.toJson());
        registerReward = userRewardsRegister;
        wheelRewards.value = wheelRegisterType.wheelRewards;
        if (userRewardsRegister == null) {
          // disabledSpin.value = false;
          allowRegister = true;
          logger.w("register allow");
          wheelId.value = wheelRegisterType.$id;
        } else {
          final rewardCreatedAt =
              DateTime.parse(userRewardsRegister.$createdAt).toLocal();
          final serverToLocale = serverDateTime.dateTime.toLocal();
          final isSame = isSameDate(serverToLocale, rewardCreatedAt);
          logger.w("isSame register: $isSame");
          if (isSame) {
            allowRegister = false;
            dontCheckCheckIn = true;
          }
        }
      }
      logger.w("208: start check-in");
      if (dontCheckCheckIn == false && wheelsCheckInType.isNotEmpty) {
        final wheelCheckInType = wheelsCheckInType.first;
        if (wheelId.value == "" || allowRegister == false) {
          wheelId.value = wheelCheckInType.$id;
          wheelRewards.value = wheelCheckInType.wheelRewards;
        }
        final userRewardsCheckin = await checkReward(
          wheelCheckInType.$id,
          [
            Query.orderDesc("\$createdAt"),
            Query.limit(1),
          ],
        );
        checkInReward = userRewardsCheckin;
        logger.w("userRewardsCheckin: 167");
        logger.d(userRewardsCheckin);
        if (userRewardsCheckin == null) {
          allowCheckIn = true;
          // disabledSpin.value = false;
        } else {
          // check same day check in

          // userRewardsCheckin;
          final serverToLocale = serverDateTime.dateTime.toLocal();
          final rewardCreatedAt =
              DateTime.parse(userRewardsCheckin.$createdAt).toLocal();
          final isScame = isSameDate(serverToLocale, rewardCreatedAt);
          logger.d("isScame: 211");
          logger.w(isScame);
          checkInSameDate = isScame;
          if (isScame == false) {
            allowCheckIn = true;
            // disabledSpin.value = false;
          }
        }
        // if(userRewardsCheckin)
      }

      if (allowRegister || allowCheckIn) {
        disabledSpin.value = false;
      }

      // ถ้าไม่มี check-in และ มี register
      if (checkInReward == null && registerReward != null) {
        final rewardIndex = wheelRewards
            .indexWhere((reward) => reward.$id == registerReward?.rewardId);
        if (rewardIndex == -1) {
          logger.e("can't find reward");
          return;
        }

        final reward = wheelRewards[rewardIndex];
        Get.dialog(
          DialogReward(
            reward: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  CommonFn.parseMoney(reward.amount ?? 0),
                  style: const TextStyle(
                    color: AppColors.wheelText,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppLocale.point.getString(Get.context!),
                  style: const TextStyle(
                    color: AppColors.wheelText,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );
        return;
      }
      // ถ้ามี check-in
      if (checkInReward != null && checkInSameDate) {
        final rewardIndex = wheelRewards
            .indexWhere((reward) => reward.$id == checkInReward?.rewardId);
        if (rewardIndex == -1) {
          logger.e("can't find reward");
          return;
        }

        final reward = wheelRewards[rewardIndex];
        Get.dialog(
          DialogReward(
            reward: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  CommonFn.parseMoney(reward.amount ?? 0),
                  style: const TextStyle(
                    color: AppColors.wheelText,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppLocale.point.getString(Get.context!),
                  style: const TextStyle(
                    color: AppColors.wheelText,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          barrierDismissible: false,
        );
      }

      // if (data.length > 1) {}
      // wheelRewards.value = data.wheelRewards;
      // wheelId.value = data.$id;
    } catch (e) {
      Get.rawSnackbar(
        message: "$e",
        snackPosition: SnackPosition.BOTTOM,
      );
      logger.e(e);
    } finally {
      isLoading.value = false;
    }
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
