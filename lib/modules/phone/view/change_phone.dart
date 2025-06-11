import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangePhonePage extends StatelessWidget {
  ChangePhonePage({super.key});
  final argument = Get.arguments;
  @override
  Widget build(BuildContext context) {
    logger.d("argument: $argument");
    return GetBuilder<SettingController>(
      initState: (state) {
        SettingController.to.newPhoneNumber = "";
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Header(
                  title: AppLocale.changePhoneNumber.getString(context),
                ),
                // HeaderCK(
                //   onTap: () => Get.back(),
                // ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Text(
                        AppLocale.changePhoneNumber.getString(context),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocale.changePhoneTitle.getString(context),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Form(
                        key: controller.keyFormPhone,
                        child: InternationalPhoneNumberInput(
                          // initialValue: PhoneNumber(
                          //   isoCode: 'LA',
                          // ),
                          countries: ['LA', 'TH'],
                          inputDecoration: InputDecoration(
                            errorStyle: TextStyle(height: 0),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.borderGray,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: AppColors.borderGray,
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
                              controller.newPhoneNumber = value.phoneNumber;
                            }
                          },
                          formatInput: false,
                          validator: (value) {
                            if (value!.length < 7) {
                              return "minimum length is 7 digits";
                            }
                            if (value == "") {
                              return "Plaese fill phone number";
                            }
                            if (!GetUtils.isPhoneNumber(value)) {
                              return "Invalid phone number";
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LongButton(
                    onPressed: () {
                      logger.d("message");
                      argument["whenSuccess"]();
                    },
                    child: Text(AppLocale.confirm.getString(context)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
