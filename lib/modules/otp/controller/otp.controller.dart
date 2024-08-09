import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/utils.dart';

class OtpController extends GetxController {
  RxBool enableOTP = false.obs;
  RxBool disabledReOTP = true.obs;
  RxBool loadingSendOTP = false.obs;
  final argrument = Get.arguments;
  final String phoneNumber = Get.arguments['phoneNumber'];
  String verificationId = '';
  int count = 0;
  StreamSubscription<User?>? _authStateChanges;

  Timer? _timer;
  Rx<Duration> remainingTime = Duration.zero.obs;

  void startTimer() {
    disabledReOTP.value = true;
    _timer?.cancel();
    final now = DateTime.now();
    DateTime targetTime = DateTime.now().add(const Duration(seconds: 60));
    final difference = targetTime.difference(now);
    logger.d(difference);
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

  Future<void> sendVerifyOTP() async {
    try {
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: argrument["phoneNumber"],
        verificationCompleted: (phoneAuthCredential) {
          logger.d("verificationCompleted $phoneAuthCredential");
        },
        verificationFailed: (error) {
          logger.d("verificationFailed $error");
        },
        codeSent: (verificationId, forceResendingToken) {
          enableOTP.value = true;
          loadingSendOTP.value = false;
          startTimer();
          logger.d("codeSent $verificationId");
          logger.d("codeSent $forceResendingToken");
          this.verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (verificationId) {
          logger.d("codeAutoRetrievalTimeout $verificationId");
        },
      );
    } catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        "Something went wrong",
        e.toString(),
      );
      navigator?.pop();
    }
  }

  void subscribeAuthStateChange() {
    _authStateChanges = FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          logger.d('User is currently signed out!');
        } else {
          logger.d('User is signed in!');
          ++count;
          logger.d(count);
          unsubscribeAuthStateChange();
          runWhenSuccess();
        }
      },
    );
  }

  void unsubscribeAuthStateChange() async {
    await _authStateChanges?.cancel();
  }

  Future<void> signOut() async {
    logger.d("signOut");
    await FirebaseAuth.instance.signOut();
  }

  void setup() async {
    await signOut();
    await sendVerifyOTP();
    subscribeAuthStateChange();
  }

  @override
  void onInit() {
    setup();
    super.onInit();
  }

  void runWhenSuccess() {
    if (argrument["whenSuccess"] is Function) {
      argrument["whenSuccess"]();
    }
  }

  Future<void> confirmOTP(String pin) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: pin,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      logger.d(userCredential.user?.phoneNumber);
    } catch (e) {
      logger.e(e.toString());
      Get.snackbar(
        "confirmOTP failed",
        e.toString(),
      );
    }
  }

  void resendOTP() {
    // disabledReOTP.value = true;
    loadingSendOTP.value = true;
    enableOTP.value = false;
    sendVerifyOTP();
  }
}
