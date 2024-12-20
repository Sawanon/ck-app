enum OTPAction { signUp, signIn, changePasscode, changePhone }

class OTPArgument {
  OTPAction action;
  String phoneNumber;
  Future<String?> Function() onInit;
  Future<void> Function(String otp) whenConfirmOTP;

  OTPArgument({
    required this.action,
    required this.phoneNumber,
    required this.onInit,
    required this.whenConfirmOTP,
  });
}
