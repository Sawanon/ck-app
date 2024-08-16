import 'package:get/get.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class BillController extends GetxController {
  Bill? bill;

  void setup() {
    setupBill();
  }

  void setupBill() {
    final argument = Get.arguments;
    bill = argument['bill'];
    update();
  }

  void test() async {
    final appwriteController = AppWriteController.to;

    final account = appwriteController.account;
    final sessionList = await account.listSessions();
    for (var session in sessionList.sessions) {
      logger.d(session);
      logger.f(session.$id);
    }
  }

  @override
  void onInit() {
    super.onInit();
    setup();
  }
}
