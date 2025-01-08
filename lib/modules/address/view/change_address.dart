import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/loading.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class ChangeAddressPage extends StatelessWidget {
  const ChangeAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      initState: (state) {
        SettingController.to.newAddress = "";
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                child: Column(
                  children: [
                    // HeaderCK(
                    //   onTap: () => Get.back(),
                    // ),
                    Header(
                      title: AppLocale.updateAddress.getString(context),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(16),
                        children: [
                          Text(
                            AppLocale.updateYourAddress.getString(context),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppLocale.pleaseEnterTheAddressYouWantToUpdate
                                .getString(context),
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Form(
                            key: controller.keyFormAddress,
                            child: TextFormField(
                              // textAlign: TextAlign.center,
                              initialValue: controller.user?.address,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: '',
                                errorStyle: TextStyle(height: 0),
                                contentPadding: const EdgeInsets.all(8),
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
                              // focusNode: controller.lotteryNode,
                              // controller:
                              //     controller.lotteryTextController,
                              // keyboardType: TextInputType.number,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.digitsOnly
                              // ],
                              validator: (value) {
                                logger.d("validator: $value");
                                if (value == null || value == "") {
                                  // controller.alertLotteryEmpty();
                                  return "";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                controller.onChangeNewAddress(value);
                                // controller.lottery = value;
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: LongButton(
                        disabled: controller.newAddress == "" ||
                            controller.newAddress == null,
                        onPressed: () {
                          controller.updateUserAddress();
                        },
                        child: Text(AppLocale.confirm.getString(context)),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.loading) const LoadingPage(),
            ],
          ),
        );
      },
    );
  }
}
