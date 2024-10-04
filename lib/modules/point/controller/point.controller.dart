import 'package:get/get.dart';
import 'package:lottery_ck/model/user.dart';
import 'package:lottery_ck/model/user_point.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class PointController extends GetxController {
  RxList<UserPoint> userPointList = <UserPoint>[].obs;
  RxInt totalPoint = 0.obs;
  RxBool isLoadingPoint = true.obs;
  UserApp? userApp;

  void listPoints() async {
    final userPointList = await AppWriteController.to.listUserPoint();
    if (userPointList == null) {
      return;
    }
    this.userPointList.value = userPointList;
    totalPoint.value = userPointList.fold(
        0, (previousValue, element) => previousValue + element.point);
    isLoadingPoint.value = false;
  }

  @override
  void onInit() {
    listPoints();
    super.onInit();
  }
}
