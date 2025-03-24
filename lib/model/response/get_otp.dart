class ResponseGetOTP {
  String otpRef;
  String? otp;

  ResponseGetOTP({
    required this.otpRef,
    required this.otp,
  });

  @override
  String toString() {
    return "${{
      "otpRef": otpRef,
      "otp": otp,
    }}";
  }
}
