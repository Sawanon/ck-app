import 'package:get/get.dart';

class LayoutController extends GetxController {
  var tabIndex = 0;
  void onChangeTabIndex(int index) {
    tabIndex = index;
    update();
  }
}
