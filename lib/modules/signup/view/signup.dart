import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lottery_ck/components/gender_radio.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/signup/controller/signup.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/res/logo.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(builder: (controller) {
      return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HeaderCK(
                    onTap: () {
                      navigator?.pop();
                    },
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      physics: BouncingScrollPhysics(),
                      children: [
                        Text(
                          AppLocale.createNewAccount.getString(context),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          AppLocale.pleaseFillInTheInformationToCreateAnAccount
                              .getString(context),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Form(
                            key: controller.keyForm,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      AppLocale.prefix.getString(context),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "*",
                                      style: TextStyle(
                                        color: AppColors.errorBorder,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                GenderRadio(
                                  onChange: (gender) {
                                    controller.changeGender(gender);
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      AppLocale.firstName.getString(context),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "*",
                                      style: TextStyle(
                                        color: AppColors.errorBorder,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                InputText(
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      return AppLocale.pleaseEnterYourFirstName
                                          .getString(context);
                                    }
                                    return null;
                                  },
                                  onlyLaos: true,
                                  onlyText: true,
                                  onChanged: (value) {
                                    controller.firstName = value;
                                  },
                                ),
                                // TextFormField(
                                //   decoration: InputDecoration(
                                //     contentPadding:
                                //         EdgeInsets.symmetric(horizontal: 8),
                                //     enabledBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.primary,
                                //       ),
                                //     ),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.primary,
                                //         width: 2,
                                //       ),
                                //     ),
                                //     errorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.errorBorder,
                                //         width: 4,
                                //       ),
                                //     ),
                                //     focusedErrorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.errorBorder,
                                //         width: 4,
                                //       ),
                                //     ),
                                //   ),
                                //   validator: (value) {
                                //     if (value == null || value == "") {
                                //       return AppLocale.pleaseEnterYourFirstName
                                //           .getString(context);
                                //     }
                                //     return null;
                                //   },
                                //   onChanged: (value) {
                                //     controller.firstName = value;
                                //   },
                                // ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      AppLocale.lastName.getString(context),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "*",
                                      style: TextStyle(
                                        color: AppColors.errorBorder,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                InputText(
                                  validator: (value) {
                                    if (value == null || value == "") {
                                      return AppLocale.pleaseEnterYourLasttName
                                          .getString(context);
                                    }
                                    return null;
                                  },
                                  onlyLaos: true,
                                  onlyText: true,
                                  onChanged: (value) {
                                    controller.lastName = value;
                                  },
                                ),
                                // TextFormField(
                                //   decoration: InputDecoration(
                                //     contentPadding:
                                //         EdgeInsets.symmetric(horizontal: 8),
                                //     enabledBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.primary,
                                //       ),
                                //     ),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.primary,
                                //         width: 2,
                                //       ),
                                //     ),
                                //     errorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.errorBorder,
                                //         width: 4,
                                //       ),
                                //     ),
                                //     focusedErrorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.errorBorder,
                                //         width: 4,
                                //       ),
                                //     ),
                                //   ),
                                //   validator: (value) {
                                //     if (value == null || value == "") {
                                //       return AppLocale.pleaseEnterYourLasttName
                                //           .getString(context);
                                //     }
                                //     return null;
                                //   },
                                //   onChanged: (value) {
                                //     controller.lastName = value;
                                //   },
                                // ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      AppLocale.birthDate.getString(context),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "*",
                                      style: TextStyle(
                                        color: AppColors.errorBorder,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () async {
                                    final datetime = await showDatePicker(
                                      context: context,
                                      firstDate: DateTime(1970),
                                      lastDate: DateTime.now(),
                                      initialDate: controller.birthDate,
                                    );
                                    logger.d("datetime: $datetime");
                                    controller.changeBirthDate(datetime);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 48,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        width: 1,
                                        color: AppColors.inputBorder,
                                      ),
                                    ),
                                    child: Text(
                                      controller.birthDate == null
                                          ? "--/--/----"
                                          : CommonFn.parseDMY(
                                              controller.birthDate!),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    AppLocale.birthTime.getString(context),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () async {
                                    if (controller.unknowBirthTime) {
                                      return;
                                    }
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      initialEntryMode:
                                          TimePickerEntryMode.input,
                                    );
                                    controller.changeBirthTime(time);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 48,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        width: 1,
                                        color: controller.unknowBirthTime
                                            ? AppColors.disable
                                            : AppColors.inputBorder,
                                      ),
                                    ),
                                    child: Text(
                                      controller.birthTime == null
                                          ? "--:--"
                                          : CommonFn.parseTimeOfDayToHMS(
                                              controller.birthTime!),
                                      // "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Row(
                                //   children: [
                                //     Text(
                                //       AppLocale.address.getString(context),
                                //       style: const TextStyle(
                                //         fontSize: 14,
                                //         fontWeight: FontWeight.w700,
                                //         color: AppColors.textPrimary,
                                //       ),
                                //     ),
                                //     const SizedBox(width: 4),
                                //     const Text(
                                //       "*",
                                //       style: TextStyle(
                                //         color: AppColors.errorBorder,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // const SizedBox(height: 4),
                                // TextFormField(
                                //   minLines: 4,
                                //   maxLines: 6,
                                //   decoration: InputDecoration(
                                //     contentPadding: EdgeInsets.all(8),
                                //     enabledBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.primary,
                                //       ),
                                //     ),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.primary,
                                //         width: 2,
                                //       ),
                                //     ),
                                //     errorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.errorBorder,
                                //         width: 4,
                                //       ),
                                //     ),
                                //     focusedErrorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.errorBorder,
                                //         width: 4,
                                //       ),
                                //     ),
                                //   ),
                                //   validator: (value) {
                                //     if (value == null || value == "") {
                                //       return AppLocale.pleaseCorrectYourAddress;
                                //     }
                                //     return null;
                                //   },
                                //   onChanged: (value) {
                                //     controller.address = value;
                                //   },
                                // ),
                                // const SizedBox(height: 24),
                                Obx(() {
                                  return LongButton(
                                    isLoading: controller.isLoading.value,
                                    onPressed: () {
                                      controller.register(context);
                                    },
                                    child: Text(
                                      AppLocale.signup.getString(context),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class HeaderCK extends StatelessWidget {
  final void Function()? onTap;
  final bool? disabledBackButton;
  const HeaderCK({
    super.key,
    this.onTap,
    this.disabledBackButton,
  });

  @override
  Widget build(BuildContext context) {
    final enable = (disabledBackButton == null || disabledBackButton == false);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (enable)
            Material(
              color: AppColors.backButton,
              borderRadius: BorderRadius.circular(10),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                overlayColor:
                    WidgetStateProperty.all<Color>(AppColors.backButtonHover),
                onTap: enable ? onTap : null,
                child: Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(AppIcon.arrowLeft),
                ),
              ),
            ),
          const SizedBox(width: 16),
          Image.asset(
            Logo.ck,
            height: 40,
          ),
        ],
      ),
    );
  }
}
