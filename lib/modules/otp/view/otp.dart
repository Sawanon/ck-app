import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/otp/controller/otp.controller.dart';
import 'package:lottery_ck/utils.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({super.key});
  static final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    // textStyle: GoogleFonts.poppins(
    //   fontSize: 22,
    //   color: const Color.fromRGBO(30, 60, 87, 1),
    // ),
    decoration: BoxDecoration(
      color: Colors.amber,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.transparent),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                child: ElevatedButton(
                    onPressed: () {
                      controller.signOut();
                    },
                    child: Text("Sign out")),
              ),
              Pinput(
                // onChanged: (value) {
                //   logger.d('value: $value');
                // },
                // validator: (value) {
                //   if (value != '555555') {
                //     return  'error na';
                //   }
                //   return null;
                // },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                length: 6,
                // controller: controller,
                // focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                onCompleted: (pin) {
                  controller.confirmOTP(pin);
                },
                focusedPinTheme: defaultPinTheme.copyWith(
                  height: 68,
                  width: 64,
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.blue),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
