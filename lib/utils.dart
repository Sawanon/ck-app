import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:lottery_ck/components/dialog_change_birthtime.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/storage.dart';
import 'package:lottery_ck/utils/common_fn.dart';

var logger = Logger();

Future<String?> createZZUrl(String url, [bool? isUnknowBirthTime]) async {
  final userApp = await AppWriteController.to.getUserApp();
  if (userApp == null) {
    LayoutController.to.showDialogLogin();
    return null;
  }
  if (isUnknowBirthTime != true) {
    if (userApp.birthTime == null || userApp.birthTime == "") {
      final isUnknowBirthTime = await StorageController.to.getUnknowBirthTime();
      logger.d(isUnknowBirthTime);
      if (isUnknowBirthTime == null) {
        // Get.dialog(
        //   const DialogChangeBirthtimeComponent(),
        // );
        return "unknowBirthTime";
      }
    }
  }
  logger.d("${DateTime.now()}");
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final exp =
      DateTime.now().add(const Duration(minutes: 10)).millisecondsSinceEpoch ~/
          1000;
  final payload2 = {
    "birthTime": userApp.birthTime,
    "birthday": CommonFn.parseYMD(userApp.birthDate),
    "iat": now,
    "exp": exp,
    "points": userApp.point.toString(),
    "userId": userApp.userId,
  };
  logger.d(payload2);
  final jwt = JWT(payload2);
  final payload = jwt.sign(
    SecretKey(AppConst.secretZZ),
    algorithm: JWTAlgorithm.HS384,
  );
  // return "https://staging.daily-ce2.pages.dev/?payload=$payload";
  return "$url$payload";
}
