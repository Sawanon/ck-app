import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/utils.dart';

class LayoutController extends GetxController with WidgetsBindingObserver {
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

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logger.d(state);
    // TODO: priority high - sawanon:20240814
    switch (state) {
      case AppLifecycleState.inactive:
        // change background to other image
        break;
      case AppLifecycleState.paused:
        // stop something
        break;
      case AppLifecycleState.resumed:
        // do something when back to app
        break;
      default:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }
}
