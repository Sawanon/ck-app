import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/couldflare/view/cloudflare.dart';
import 'package:lottery_ck/modules/login/controller/login.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      AppColors.primary.withOpacity(0.2),
                    ],
                    begin: Alignment(0.0, -0.6),
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Image.asset("assets/ck-w1.png"),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          AppLocale.login.getString(context),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          AppLocale.pleaseEnterYourPhoneNumberToLogin
                              .getString(context),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow.withOpacity(0.2),
                              offset: Offset(4, 4),
                              blurRadius: 30,
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocale.phoneNumber.getString(context),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Form(
                              key: controller.keyForm,
                              child: InternationalPhoneNumberInput(
                                // initialValue: PhoneNumber(
                                //   isoCode: 'LA',
                                // ),
                                countries: ['LA', 'TH'],
                                inputDecoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColors.redGradient,
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: AppColors.redGradient,
                                    ),
                                  ),
                                ),
                                selectorConfig: const SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                ),
                                onInputChanged: (value) {
                                  if (value.phoneNumber != null) {
                                    controller.phoneNumber = value.phoneNumber!;
                                  }
                                },
                                formatInput: false,
                                validator: (value) {
                                  if (value!.length < 7) {
                                    String minimumText = AppLocale
                                        .minimumLengthDigits
                                        .getString(context)
                                        .replaceAll("{digits}", "7");
                                    return minimumText;
                                  }
                                  if (value == "") {
                                    return AppLocale.pleaseFillPhoneNumber
                                        .getString(context);
                                  }
                                  if (!GetUtils.isPhoneNumber(value)) {
                                    return AppLocale.invalidPhoneNumber
                                        .getString(context);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                              child: CloudFlarePage(),
                            ),
                            const SizedBox(height: 24),
                            Obx(
                              () => (ElevatedButton(
                                style: controller.disableLogin.value
                                    ? ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width,
                                            48),
                                        backgroundColor: AppColors.disable,
                                        foregroundColor: AppColors.disableText,
                                      )
                                    : ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width,
                                            48),
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                      ),
                                onPressed: () {
                                  // TODO: comment for dev
                                  if (controller.disableLogin.value) {
                                    return;
                                  }
                                  controller.login();
                                },
                                child: Text(
                                  AppLocale.login.getString(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )),
                            ),
                            const SizedBox(height: 8),
                            LongButton(
                              backgroundColor: Colors.white,
                              borderSide: BorderSide(
                                width: 1,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                AppLocale.cancel.getString(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
