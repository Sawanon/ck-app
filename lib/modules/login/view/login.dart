import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:lottery_ck/modules/login/controller/login.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

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
                          'ເຂົ້າສູ່ລະບົບ',
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
                          'ກະລຸນາຕື່ມເບີໂທລະສັບແລະລະຫັດຜ່ານເພື່ອເຂົ້າສູ່ລະບົບ',
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
                                'ເບີໂທລະສັບ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            InternationalPhoneNumberInput(
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
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.DIALOG,
                              ),
                              onInputChanged: (value) {
                                logger.d('value 107 $value');
                                if (value.phoneNumber != null) {
                                  controller.username = value.phoneNumber!;
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
                            // TextFormField(
                            //   decoration: InputDecoration(
                            //     enabledBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //       borderSide: BorderSide(
                            //         color: AppColors.primary,
                            //       ),
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //       borderSide: BorderSide(
                            //         color: AppColors.primary,
                            //         width: 2,
                            //       ),
                            //     ),
                            //   ),
                            //   onChanged: (value) {
                            //     controller.username = value;
                            //   },
                            // ),
                            // const SizedBox(height: 16),
                            // Align(
                            //   alignment: Alignment.centerLeft,
                            //   child: Text(
                            //     'ລະຫັດຜ່ານ',
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //       fontWeight: FontWeight.w400,
                            //     ),
                            //   ),
                            // ),
                            // TextFormField(
                            //   decoration: InputDecoration(
                            //     enabledBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //       borderSide: BorderSide(
                            //         color: AppColors.primary,
                            //       ),
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //       borderRadius: BorderRadius.circular(10),
                            //       borderSide: BorderSide(
                            //         color: AppColors.primary,
                            //         width: 2,
                            //       ),
                            //     ),
                            //   ),
                            //   onChanged: (value) {
                            //     controller.password = value;
                            //   },
                            // ),
                            const SizedBox(height: 36),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: false,
                                        onChanged: (value) {},
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'ບັນທຶກລະຫັດຜ່ານ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  'ລືມລະຫັດຜ່ານ',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                    decorationColor: AppColors.textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 42),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize:
                                    Size(MediaQuery.of(context).size.width, 48),
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                controller.login();
                              },
                              child: Text(
                                'ເຂົ້າສູ່ລະບົບ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                fixedSize:
                                    Size(MediaQuery.of(context).size.width, 48),
                                backgroundColor: Colors.transparent,
                                foregroundColor: AppColors.primary,
                              ),
                              onPressed: () {
                                Get.toNamed(RouteName.signup);
                              },
                              child: Text(
                                'ລົງທະບຽນ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
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
