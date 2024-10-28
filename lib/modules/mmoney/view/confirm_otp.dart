import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/mmoney/controller/confirm_otp.controller.dart';
import 'package:lottery_ck/modules/payment/controller/payment.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:pinput/pinput.dart';

class MonneyConfirmOTP extends StatelessWidget {
  const MonneyConfirmOTP({super.key});

  static final defaultPinTheme = PinTheme(
    width: 56,
    height: 60,
    // textStyle: GoogleFonts.poppins(
    //   fontSize: 22,
    //   color: const Color.fromRGBO(30, 60, 87, 1),
    // ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.borderGray),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MonneyConfirmOTPController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeaderCK(
                onTap: () {
                  navigator?.pop();
                },
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const Text(
                      'ຢືນຢັນລະຫັດ',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'ກະລຸນາຕື່ມລະຫັດ 6 ຫຼັກ ທີ່ໄດ້ຮັບຈາກ SMS ທີ່ສົ່ງໄປຍັງເບີ ${controller.phoneNumber}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "OTP REF: ${controller.otpRefCode ?? "-"}",
                        style: TextStyle(
                          color: AppColors.secodaryText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => (Pinput(
                        // onChanged: (value) {
                        //   logger.d('value: $value');
                        // },
                        // validator: (value) {
                        //   if (value != '555555') {
                        //     return  'error na';
                        //   }
                        //   return null;
                        // },
                        enabled: controller.enableOTP.value,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        length: 6,
                        // controller: controller,
                        // focusNode: focusNode,
                        defaultPinTheme: defaultPinTheme,
                        onCompleted: (pin) {
                          controller.confirmOTP(pin);
                        },
                        disabledPinTheme: defaultPinTheme.copyWith(
                          decoration: BoxDecoration(
                            color: AppColors.disable,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
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
                      )),
                    ),
                    const SizedBox(height: 24),
                    Obx(() {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width, 48),
                          backgroundColor: controller.disabledReOTP.value
                              ? AppColors.disable
                              : AppColors.primary,
                          foregroundColor: controller.disabledReOTP.value
                              ? AppColors.disableText
                              : Colors.white,
                        ),
                        onPressed: () {
                          if (controller.disabledReOTP.value ||
                              controller.loadingSendOTP.value) {
                            return;
                          }
                          // controller.startTimer();
                          controller.resendOTP();
                        },
                        child: controller.loadingSendOTP.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "ສົ່ງ OTP ອີກຄັ້ງ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (BuyLotteryController
                              .to.invoiceRemainExpire.value.inSeconds <=
                          0) {
                        controller.enableResendOTP();
                      }
                      return Align(
                        alignment: Alignment.center,
                        child: Text(
                          "${AppLocale.pleaseWait.getString(context)} ${BuyLotteryController.to.invoiceRemainExpire.value.inMinutes.remainder(60).toString().padLeft(2, "0")} ${AppLocale.minute.getString(context)} ${BuyLotteryController.to.invoiceRemainExpire.value.inSeconds.remainder(60).toString().padLeft(2, "0")} ${AppLocale.second.getString(context)}",
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
