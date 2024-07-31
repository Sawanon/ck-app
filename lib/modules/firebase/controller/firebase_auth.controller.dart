import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthController extends GetxController {
  static FirebaseAuthController get to => Get.find();

  void verifyPhonenumber(String phoneNumber) {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) {},
      verificationFailed: (error) {},
      codeSent: (verificationId, forceResendingToken) {},
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }
}
