import 'dart:async';

import 'package:get/get.dart';
import 'package:lottery_ck/model/get_argument/otp.dart';
import 'package:lottery_ck/utils.dart';

class OtpController extends GetxController {
  RxBool enableOTP = false.obs;
  RxBool disabledReOTP = true.obs;
  RxBool loadingSendOTP = false.obs;
  final OTPArgument argrument = Get.arguments;
  // final String phoneNumber = Get.arguments['phoneNumber'];
  String verificationId = '';
  int count = 0;
  RxString otpRef = ''.obs;
  String userId = '';

  Timer? _timer;
  Rx<Duration> remainingTime = Duration.zero.obs;

  void startTimer() {
    disabledReOTP.value = true;
    _timer?.cancel();
    final now = DateTime.now();
    DateTime targetTime = DateTime.now().add(const Duration(seconds: 60));
    final difference = targetTime.difference(now);
    remainingTime.value = difference;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!targetTime.isAtSameMomentAs(targetTime)) {
        targetTime = targetTime;
        remainingTime.value = targetTime.difference(now);
      }

      if (remainingTime.value.inSeconds > 0) {
        remainingTime.value -= const Duration(seconds: 1);
        // print('_remainingTime 168 $_remainingTime');
      } else {
        logger.d("finish !");
        disabledReOTP.value = false;
        _timer?.cancel();
      }
    });
  }

  // Future<void> signOut() async {
  //   logger.d("signOut");
  //   await FirebaseAuth.instance.signOut();
  // }

  // void setup() async {
  //   await signOut();
  //   await sendVerifyOTP();
  //   subscribeAuthStateChange();
  // }

  // Future<void> getOTPSignup(String phoneNumber) async {
  //   try {
  //     final dio = Dio();
  //     logger.d("phoneNumber: $phoneNumber");
  //     final response = await dio.post("${AppConst.apiUrl}/user/otp", data: {
  //       "phoneNumber": phoneNumber,
  //     });
  //     logger.d(response.data);
  //     final data = response.data['data'];
  //     otpRef.value = data['otpRef'];
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       logger.e(e.response?.statusCode);
  //       logger.e(e.response?.statusMessage);
  //       logger.e(e.response?.data);
  //       logger.e(e.response?.headers);
  //       logger.e(e.response?.requestOptions);
  //     } else {
  //       // Something happened in setting up or sending the request that triggered an Error
  //       logger.e(e.requestOptions);
  //       logger.e(e.message);
  //     }
  //   }
  // }

  // Future<void> getOtp(String phoneNumber) async {
  //   final action = argrument['action'];
  //   if (action == "signup") {
  //     getOTPSignup(phoneNumber);
  //     return;
  //   }
  //   final dio = Dio();
  //   final response = await dio.post(
  //     "${AppConst.apiUrl}/otp",
  //     data: {
  //       'phone': phoneNumber,
  //     },
  //   );
  //   logger.w(response.data);
  //   final result = response.data;
  //   otpRef.value = result['data']['otpRef'];
  //   userId = result['data']['userId'];
  //   startTimer();
  //   enableOTP.value = true;
  // }

  Future<void> confirmOTPAppwrite(String pin) async {
    await argrument.whenConfirmOTP(pin);
    // logger.d(pin);
    // final dio = Dio();
    // final response = await dio.post(
    //   "${AppConst.apiUrl}/otp/verify",
    //   data: {
    //     "userId": userId,
    //     "otp": pin,
    //     "otpRef": otpRef.value,
    //   },
    // );
    // final result = response.data;
    // final secret = result['data']['secret'];
    // runWhenSuccess(userId, secret);
  }

  void setup() async {
    try {
      final otpRef = await argrument.onInit();
      if (otpRef == null) throw "otpRef is empty";

      this.otpRef.value = otpRef;
      enableOTP.value = true;
      startTimer();
    } catch (e) {
      logger.e("$e");
    } finally {
      loadingSendOTP.value = false;
    }
    // try {
    // final phoneNumber = argrument["phoneNumber"];
    // if (phoneNumber == null) {
    //   throw 'Phone number is empty';
    // }
    // await getOtp(phoneNumber);
    // } on DioException catch (e) {
    //   if (e.response != null) {
    //     logger.e(e.response?.statusCode);
    //     logger.e(e.response?.statusMessage);
    //     logger.e(e.response?.data);
    //     logger.e(e.response?.headers);
    //     logger.e(e.response?.requestOptions);
    //     Get.dialog(
    //       DialogApp(
    //         title: Text("Network error"),
    //         details: Text(
    //             'code:${e.response?.statusCode ?? '-'} message:${e.response?.statusMessage ?? '-'}'),
    //         disableConfirm: true,
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   Get.dialog(
    //     DialogApp(
    //       title: Text('something went wrong'),
    //       details: Text('$e'),
    //       disableConfirm: true,
    //     ),
    //   );
    // }
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }

  // void runWhenSuccess(String userId, String secret) {
  //   if (argrument["whenSuccess"] is Function) {
  //     argrument["whenSuccess"](userId, secret);
  //   }
  // }

  // Future<void> confirmOTP(String pin) async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: pin,
  //     );
  //     final userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     logger.d(userCredential.user?.phoneNumber);
  //   } catch (e) {
  //     logger.e(e.toString());
  //     Get.snackbar(
  //       "confirmOTP failed",
  //       e.toString(),
  //     );
  //   }
  // }

  void resendOTP() {
    // disabledReOTP.value = true;
    loadingSendOTP.value = true;
    enableOTP.value = false;
    setup();
  }
}
