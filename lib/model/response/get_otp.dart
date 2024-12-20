class ResponseGetOTP {
  String otpRef;

  ResponseGetOTP({
    required this.otpRef,
  });

  @override
  String toString() {
    return "${{
      "otpRef": otpRef,
    }}";
  }
}
