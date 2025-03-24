import 'package:get/get.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class BillController extends GetxController {
  Bill? bill;
  final arguments = Get.arguments;

  void setup() {
    setupBill();
  }

  void setupBill() {
    final argument = Get.arguments;
    bill = argument['bill'];
    update();
  }

  void backToHome() {
    // navigator?.pop();
    // BuyLotteryController.to.clearLottery();
    if (arguments['onClose'] is Function) {
      arguments['onClose']();
    }
  }

  @override
  void onInit() {
    super.onInit();
    setup();
  }
}
