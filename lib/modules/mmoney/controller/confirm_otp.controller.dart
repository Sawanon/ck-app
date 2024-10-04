import 'package:get/get.dart';
import 'package:lottery_ck/utils.dart';

class MonneyConfirmOTPController extends GetxController {
  final argrument = Get.arguments;
  final String phoneNumber = Get.arguments['phoneNumber'];
  RxBool enableOTP = true.obs;
  final Future<void> Function() _onInit = Get.arguments['onInit'];
  final Future<void> Function(String otp) onConfirm =
      Get.arguments['onConfirm'];

  RxBool disabledReOTP = true.obs;
  RxBool loadingSendOTP = false.obs;
  Rx<Duration> remainingTime = Duration.zero.obs;
  String? otp = '';

  void confirmOTP(String otp) async {
    final result = {
      "payment": {
        "transData": [
          {"transCashOutID": "1"}
        ]
      }
    };
    final payload = {
      "transCashOutID":
          (result["payment"]!["transData"] as List).first["transCashOutID"],
      "otpRefNo": result["payment"]!["otpRefNo"],
      "otpRefCode": result["payment"]!["otpRefCode"],
      "lotteryDateStr": "",
      "opt": otp,
    };
    logger.d("payload: $payload");
    onConfirm(otp);
  }

  void resendOTP() async {}

  void setup() async {
    await _onInit();
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }
}
