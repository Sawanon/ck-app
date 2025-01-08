import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';

class BuylotteryComponent extends StatelessWidget {
  const BuylotteryComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyLotteryController>(builder: (controller) {
      return Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          maxLength: 6,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: "",
                            hintText:
                                AppLocale.purchaseNumber.getString(context),
                            errorStyle: TextStyle(height: 0),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.borderGray,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.borderGray,
                                width: 1,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.errorBorder,
                                width: 2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.errorBorder,
                                width: 2,
                              ),
                            ),
                          ),
                          focusNode: controller.lotteryNode,
                          controller: controller.lotteryTextController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            logger.d("validator: $value");
                            if (value == null || value == "") {
                              controller.alertLotteryEmpty();
                              return "";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            controller.lottery = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: AppLocale.price.getString(context),
                            errorStyle: TextStyle(height: 0),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.borderGray,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.borderGray,
                                width: 1,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.errorBorder,
                                width: 2,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.errorBorder,
                                width: 2,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          focusNode: controller.priceNode,
                          controller: controller.priceTextController,
                          validator: (value) {
                            if (value == null || value == "") {
                              controller.alertPrice();
                              return "";
                            }
                            return null;
                          },
                          onChanged: controller.onChangePrice,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Obx(() {
                        return GestureDetector(
                          onTap: () {
                            if (controller.disabledBuy.value) {
                              return;
                            }
                            controller.submitAddLottery(
                              controller.lottery,
                              controller.price,
                              true,
                            );
                          },
                          child: Container(
                            height: 48,
                            width: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: controller.disabledBuy.value
                                  ? AppColors.disable
                                  : AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SvgPicture.asset(
                              AppIcon.add,
                              colorFilter: ColorFilter.mode(
                                controller.disabledBuy.value
                                    ? Colors.black.withOpacity(0.6)
                                    : Colors.white,
                                BlendMode.srcIn,
                              ),
                              width: 36,
                              height: 36,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LongButton(
                    onPressed: () {
                      controller.confirmLottery(context); // lottery confirm
                    },
                    disabled: controller.disabledBuy.value,
                    child: Text(
                      AppLocale.pay.getString(context),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
