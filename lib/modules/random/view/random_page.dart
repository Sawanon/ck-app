import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/random/random.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class RandomPage extends StatelessWidget {
  const RandomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RandomController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(title: AppLocale.randomNumber),
              Text("${controller.maxNumberLottery}"),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppLocale.selectDigit.getString(context),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => controller.onChangeDigit(2),
                        child: Container(
                          width: 48,
                          alignment: Alignment.center,
                          height: 48,
                          decoration: BoxDecoration(
                            color: controller.digit.value == 2
                                ? AppColors.primary
                                : Colors.white,
                            border: Border.all(
                              width: 1,
                              color: controller.digit.value == 2
                                  ? Colors.transparent
                                  : AppColors.primary,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "2",
                            style: TextStyle(
                              color: controller.digit.value == 2
                                  ? Colors.white
                                  : AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => controller.onChangeDigit(3),
                        child: Container(
                          width: 48,
                          alignment: Alignment.center,
                          height: 48,
                          decoration: BoxDecoration(
                            color: controller.digit.value == 3
                                ? AppColors.primary
                                : Colors.white,
                            border: Border.all(
                              width: 1,
                              color: controller.digit.value == 3
                                  ? Colors.transparent
                                  : AppColors.primary,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "3",
                            style: TextStyle(
                              color: controller.digit.value == 3
                                  ? Colors.white
                                  : AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => controller.onChangeDigit(4),
                        child: Container(
                          width: 48,
                          alignment: Alignment.center,
                          height: 48,
                          decoration: BoxDecoration(
                            color: controller.digit.value == 4
                                ? AppColors.primary
                                : Colors.white,
                            border: Border.all(
                              width: 1,
                              color: controller.digit.value == 4
                                  ? Colors.transparent
                                  : AppColors.primary,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "4",
                            style: TextStyle(
                              color: controller.digit.value == 4
                                  ? Colors.white
                                  : AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => controller.onChangeDigit(5),
                        child: Container(
                          width: 48,
                          alignment: Alignment.center,
                          height: 48,
                          decoration: BoxDecoration(
                            color: controller.digit.value == 5
                                ? AppColors.primary
                                : Colors.white,
                            border: Border.all(
                              width: 1,
                              color: controller.digit.value == 5
                                  ? Colors.transparent
                                  : AppColors.primary,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "5",
                            style: TextStyle(
                              color: controller.digit.value == 5
                                  ? Colors.white
                                  : AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => controller.onChangeDigit(6),
                        child: Container(
                          width: 48,
                          alignment: Alignment.center,
                          height: 48,
                          decoration: BoxDecoration(
                            color: controller.digit.value == 6
                                ? AppColors.primary
                                : Colors.white,
                            border: Border.all(
                              width: 1,
                              color: controller.digit.value == 6
                                  ? Colors.transparent
                                  : AppColors.primary,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "6",
                            style: TextStyle(
                              color: controller.digit.value == 6
                                  ? Colors.white
                                  : AppColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text(
                  "${AppLocale.enterLotteryNumber.getString(context)} (${AppLocale.optional.getString(context)})",
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: InputText(
                          keyboardType: TextInputType.number,
                          focusNode: controller.focus1,
                          controller: controller.controller1,
                          disabled: controller.digit.value < 6,
                          hintText: "?",
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          disableMaxlengthText: true,
                          onChanged: (value) {
                            if (value != "") {
                              controller.focus2.requestFocus();
                            }
                            controller.onChangeDigitValue(value, 1);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InputText(
                          keyboardType: TextInputType.number,
                          focusNode: controller.focus2,
                          controller: controller.controller2,
                          disabled: controller.digit.value < 5,
                          hintText: "?",
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          disableMaxlengthText: true,
                          onChanged: (value) {
                            logger.w(value);
                            if (value == "") {
                              controller.focus1.requestFocus();
                            } else {
                              controller.focus3.requestFocus();
                            }
                            controller.onChangeDigitValue(value, 2);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InputText(
                          keyboardType: TextInputType.number,
                          focusNode: controller.focus3,
                          controller: controller.controller3,
                          disabled: controller.digit.value < 4,
                          hintText: "?",
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          disableMaxlengthText: true,
                          onChanged: (value) {
                            if (value == "") {
                              controller.focus2.requestFocus();
                            } else {
                              controller.focus4.requestFocus();
                            }
                            controller.onChangeDigitValue(value, 3);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InputText(
                          keyboardType: TextInputType.number,
                          focusNode: controller.focus4,
                          controller: controller.controller4,
                          disabled: controller.digit.value < 3,
                          hintText: "?",
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          disableMaxlengthText: true,
                          onChanged: (value) {
                            if (value == "") {
                              controller.focus3.requestFocus();
                            } else {
                              controller.focus5.requestFocus();
                            }
                            controller.onChangeDigitValue(value, 4);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InputText(
                          keyboardType: TextInputType.number,
                          focusNode: controller.focus5,
                          controller: controller.controller5,
                          hintText: "?",
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          disableMaxlengthText: true,
                          onChanged: (value) {
                            if (value == "") {
                              controller.focus4.requestFocus();
                            } else {
                              controller.focus6.requestFocus();
                            }
                            controller.onChangeDigitValue(value, 5);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InputText(
                          keyboardType: TextInputType.number,
                          focusNode: controller.focus6,
                          controller: controller.controller6,
                          hintText: "?",
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          disableMaxlengthText: true,
                          onChanged: (value) {
                            if (value == "") {
                              controller.focus5.requestFocus();
                            }
                            controller.onChangeDigitValue(value, 6);
                          },
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocale.numberOfLottery.getString(context),
                          ),
                          const SizedBox(height: 8),
                          InputText(
                            controller: controller.numberLotteryController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxValue: controller.maxNumberLottery,
                            onChanged: (value) =>
                                controller.onChangeNumberLottery(value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocale.valueOfMoney.getString(context),
                          ),
                          const SizedBox(height: 8),
                          InputText(
                            keyboardType: TextInputType.number,
                            controller: controller.priceTextController,
                            maxValue: 1000000,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              logger.w("value widget: $value");
                              controller.onChangePrice(value);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LongButton(
                  disabled: controller.disabledConfirm,
                  onPressed: () => controller.submitRandom(),
                  child: Text(
                    AppLocale.randomNumber.getString(context),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
