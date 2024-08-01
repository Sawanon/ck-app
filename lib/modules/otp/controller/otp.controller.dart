import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/utils.dart';

class OtpController extends GetxController {
  final argrument = Get.arguments;
  String verificationId = '';
  int count = 0;
  StreamSubscription<User?>? _authStateChanges;

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
          logger.d("codeSent $verificationId");
          logger.d("codeSent $forceResendingToken");
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          logger.d("codeAutoRetrievalTimeout $verificationId");
        },
      );
    } catch (e) {
      Get.snackbar(
        "Something went wrong",
        e.toString(),
      );
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
      Get.snackbar(
        "confirmOTP failed",
        e.toString(),
      );
    }
  }
}
