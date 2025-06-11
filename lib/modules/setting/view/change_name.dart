import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:google_fonts/google_fonts.dart';

class ChangeNamePage extends StatefulWidget {
  const ChangeNamePage({super.key});

  @override
  State<ChangeNamePage> createState() => _ChangeNamePageState();
}

class _ChangeNamePageState extends State<ChangeNamePage> {
  String? firstName;
  String? lastName;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void handleChangeFirstName(String firstName) {
    setState(() {
      this.firstName = firstName;
    });
  }

  void handleChangeLastName(String lastName) {
    setState(() {
      this.lastName = lastName;
    });
  }

  @override
  void initState() {
    firstName = UserController.to.user.value?.firstName;
    lastName = UserController.to.user.value?.lastName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: AppLocale.changeName.getString(context),
            ),
            Expanded(
              child: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocale.firstName.getString(context),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: UserController.to.user.value?.firstName,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.errorBorder,
                            width: 4,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.errorBorder,
                            width: 4,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value == "") {
                          return AppLocale.pleaseEnterYourFirstName
                              .getString(context);
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // controller.firstName = value;
                        handleChangeFirstName(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocale.lastName.getString(context),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: UserController.to.user.value?.lastName,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.errorBorder,
                            width: 4,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: AppColors.errorBorder,
                            width: 4,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value == "") {
                          return AppLocale.pleaseEnterYourLasttName
                              .getString(context);
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // controller.lastName = value;
                        handleChangeLastName(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    LongButton(
                      onPressed: () {
                        if (formKey.currentState != null &&
                            formKey.currentState!.validate()) {
                          if (firstName != null && lastName != null) {
                            SettingController.to
                                .changeName(firstName!, lastName!);
                            return;
                          }
                        }
                        Get.rawSnackbar(
                            message: AppLocale
                                .pleaseEnterYourFirstNameAndLastName
                                .getString(context));
                      },
                      child: Text(AppLocale.confirm.getString(context)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
