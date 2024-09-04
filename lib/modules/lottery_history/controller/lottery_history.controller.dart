import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class LotteryHistoryController extends GetxController {
  RxList lotteryHistoryList = [].obs;
  void listLotteryHistory() async {
    this.lotteryHistoryList.clear();
    final lotteryHistoryList = await AppWriteController.to.listLotteryHistory();
    logger.d("lotteryHistoryList: $lotteryHistoryList");
    if (lotteryHistoryList != null) {
      this.lotteryHistoryList.value = lotteryHistoryList;
    }
  }

  @override
  void onInit() {
    listLotteryHistory();
    super.onInit();
  }
}
