import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class LotteryHistoryController extends GetxController {
  static LotteryHistoryController get to => Get.find();
  RxList lotteryHistoryList = [].obs;
  RxBool isLoading = true.obs;
  void listLotteryHistory() async {
    isLoading.value = true;
    this.lotteryHistoryList.clear();
    final lotteryHistoryList = await AppWriteController.to.listLotteryHistory();
    logger.d("lotteryHistoryList: $lotteryHistoryList");
    if (lotteryHistoryList != null) {
      this.lotteryHistoryList.value = lotteryHistoryList;
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    listLotteryHistory();
    super.onInit();
  }
}
