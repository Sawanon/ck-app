import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/payment/controller/confirm_payment.controller.dart';

class ConfirmPaymentOtpPage extends StatelessWidget {
  const ConfirmPaymentOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConfirmPaymentOTPController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Container(
              child: Text("data"),
            ),
          ),
        );
      },
    );
  }
}
