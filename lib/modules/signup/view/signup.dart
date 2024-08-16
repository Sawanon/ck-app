import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lottery_ck/modules/signup/controller/signup.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/res/logo.dart';
import 'package:lottery_ck/utils.dart';

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
                  Header(
                    onTap: () {
                      navigator?.pop();
                    },
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      physics: BouncingScrollPhysics(),
                      children: [
                        const Text(
                          'ສ້າງບັນຊີໃໝ່',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Text(
                          'ກະລຸນາຕື່ມຂໍ້ມູນເພື່ອສ້າງບັນຊີ',
                          style: TextStyle(
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
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'ຊື່',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
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
                                    controller.firstName = value;
                                  },
                                ),
                                const SizedBox(height: 16),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'ນາມສະກຸນ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  decoration: InputDecoration(
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
                                    controller.lastName = value;
                                  },
                                ),
                                // const SizedBox(height: 16),
                                // const Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(
                                //     'ເບີໂທລະສັບ',
                                //     style: TextStyle(
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w700,
                                //       color: AppColors.textPrimary,
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(height: 8),
                                // InternationalPhoneNumberInput(
                                //   // initialValue: PhoneNumber(
                                //   //   isoCode: 'LA',
                                //   // ),
                                //   countries: ['LA', 'TH'],
                                //   inputDecoration: InputDecoration(
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
                                //     focusedErrorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.redGradient,
                                //         width: 2,
                                //       ),
                                //     ),
                                //     errorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.redGradient,
                                //       ),
                                //     ),
                                //   ),
                                //   selectorConfig: SelectorConfig(
                                //     selectorType: PhoneInputSelectorType.DIALOG,
                                //   ),
                                //   onInputChanged: (value) {
                                //     logger.d('value 107 $value');
                                //     if (value.phoneNumber != null) {
                                //       controller.phone = value.phoneNumber!;
                                //     }
                                //   },
                                //   formatInput: false,
                                //   validator: (value) {
                                //     if (value!.length < 7) {
                                //       return "minimum length is 7 digits";
                                //     }
                                //     if (value == "") {
                                //       return "Plaese fill phone number";
                                //     }
                                //     if (!GetUtils.isPhoneNumber(value)) {
                                //       return "Invalid phone number";
                                //     }
                                //     return null;
                                //   },
                                // ),
                                // TextFormField(
                                //   keyboardType: TextInputType.phone,
                                //   validator: (value) {
                                //     if (value != null &&
                                //         GetUtils.isPhoneNumber(value)) {
                                //       return null;
                                //     }
                                //     return "Please enter phone number";
                                //   },
                                //   decoration: InputDecoration(
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
                                //     focusedErrorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.redGradient,
                                //         width: 2,
                                //       ),
                                //     ),
                                //     errorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.redGradient,
                                //       ),
                                //     ),
                                //   ),
                                //   onChanged: (value) {
                                //     controller.phone = value;
                                //   },
                                // ),
                                // const SizedBox(height: 16),
                                // const Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(
                                //     'ລະຫັດຜ່ານ',
                                //     style: TextStyle(
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w700,
                                //       color: AppColors.textPrimary,
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(height: 8),
                                // TextFormField(
                                //   validator: (value) {
                                //     if (controller.confirmPassword == value) {
                                //       return null;
                                //     }
                                //     return "Password not match";
                                //   },
                                //   decoration: InputDecoration(
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
                                //     focusedErrorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.redGradient,
                                //         width: 2,
                                //       ),
                                //     ),
                                //     errorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.redGradient,
                                //       ),
                                //     ),
                                //   ),
                                //   onChanged: (value) {
                                //     controller.password = value;
                                //   },
                                // ),
                                // const SizedBox(height: 16),
                                // const Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(
                                //     'ຢືນຢັນລະຫັດ',
                                //     style: TextStyle(
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w700,
                                //       color: AppColors.textPrimary,
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(height: 8),
                                // TextFormField(
                                //   // autovalidateMode: AutovalidateMode.always,
                                //   validator: (value) {
                                //     if (controller.password == value) {
                                //       return null;
                                //     }
                                //     return "Password not match";
                                //   },
                                //   decoration: InputDecoration(
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
                                //     focusedErrorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.redGradient,
                                //         width: 2,
                                //       ),
                                //     ),
                                //     errorBorder: OutlineInputBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //       borderSide: const BorderSide(
                                //         color: AppColors.redGradient,
                                //       ),
                                //     ),
                                //   ),
                                //   onChanged: (value) {
                                //     controller.confirmPassword = value;
                                //   },
                                // ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width, 48),
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    controller.register();
                                  },
                                  child: Text(
                                    'ລົງທະບຽນ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
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

class Header extends StatelessWidget {
  final void Function()? onTap;
  final bool? disabledBackButton;
  const Header({
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
        children: [
          Opacity(
            opacity: enable ? 1 : 0,
            child: Material(
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
