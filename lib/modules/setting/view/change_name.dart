import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';

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
    firstName = SettingController.to.user?.firstName;
    lastName = SettingController.to.user?.lastName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Header(title: "Change Name"),
            Expanded(
              child: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ຊື່',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: SettingController.to.user?.firstName,
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
                          return "Please enter your first name";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        // controller.firstName = value;
                        handleChangeFirstName(value);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ນາມສະກຸນ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      initialValue: SettingController.to.user?.lastName,
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
                          return "Please enter your last name";
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
                            message:
                                "Please enter your first name and last name");
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