import 'package:get/get.dart';
import 'package:lottery_ck/model/response/get_wheel_active.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class WheelController extends GetxController {
  RxList<WheelReward> wheelRewards = [
    WheelReward(
      type: 'point',
      order: 1,
      isBigReward: false,
      amount: 10000,
    ),
    WheelReward(
      type: 'point',
      order: 2,
      isBigReward: false,
      amount: 1000,
    ),
  ].obs;
  RxBool isLoading = true.obs;
  void setup() async {
    isLoading.value = true;
    final response = await AppWriteController.to.getWheelActive();
    logger.w(response.data?.toJson());
    logger.w(response.isSuccess);
    logger.w(response.message);
    final data = response.data;
    if (data == null) {
      return;
    }
    wheelRewards.value = data.wheelRewards;
    isLoading.value = false;
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
