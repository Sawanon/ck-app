import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/otp/controller/otp.controller.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            child: ElevatedButton(
                onPressed: () {
                  controller.showArgrument();
                },
                child: Text("OTP")),
          ),
        ),
      );
    });
  }
}
