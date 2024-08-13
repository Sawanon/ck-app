import 'package:get/get.dart';
import 'package:lottery_ck/utils.dart';

class LayoutController extends GetxController {
  static LayoutController get to => Get.find();
  var tabIndex = 0;
  double bottomPadding = 74;
  void onChangeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  void removePaddingBottom() {
    logger.d("removePaddingBottom");
    bottomPadding = 0;
    update();
  }

  void resetPaddingBottom() {
    logger.d("resetPaddingBottom");
    bottomPadding = 74;
    update();
  }
}
