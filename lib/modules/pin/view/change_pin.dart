import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/pin/controller/change_passcode.controller.dart';
import 'package:lottery_ck/modules/pin/controller/pin.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class ChangePasscode extends StatelessWidget {
  const ChangePasscode({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChangePasscodeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                HeaderCK(
                  disabledBackButton: true,
                  onTap: () {
                    logger.d("message");
                  },
                ),
                Expanded(
                  child: ScreenLock.create(
                    onConfirmed: (value) {
                      controller.changePasscode(value);
                    },
                    confirmTitle: Text(
                      AppLocale.confirmYourPasscode.getString(context),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    digits: 6,
                    useBlur: false,
                    title: Text(
                      AppLocale.createYourPasscode.getString(context),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    secretsConfig: SecretsConfig(
                      padding: EdgeInsets.all(24),
                      spacing: 16,
                      secretConfig: SecretConfig(
                        builder: (context, config, enabled) {
                          return Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: enabled
                                  ? AppColors.primary
                                  : Colors.transparent,
                              border: Border.all(
                                width: 1,
                                color: enabled
                                    ? Colors.transparent
                                    : AppColors.disableText,
                              ),
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                    ),
                    keyPadConfig: KeyPadConfig(
                      actionButtonConfig: KeyPadButtonConfig(
                          buttonStyle: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(Colors.white),
                        foregroundColor:
                            WidgetStateProperty.all(AppColors.textPrimary),
                      )),
                      buttonConfig: KeyPadButtonConfig(
                        // backgroundColor: Colors.white,
                        buttonStyle: ButtonStyle(
                          overlayColor: WidgetStateProperty.all(Colors.white),
                          foregroundColor:
                              WidgetStateProperty.all(AppColors.textPrimary),
                        ),
                      ),
                    ),
                    config: ScreenLockConfig(
                      backgroundColor: Colors.white,
                      // titleTextStyle: TextStyle(
                      //   fontSize: 32,
                      //   fontWeight: FontWeight.w700,
                      // ),
                      // textStyle: TextStyle(
                      //   color: Colors.red,
                      // ),
                      // buttonStyle: ButtonStyle(
                      //   backgroundColor: WidgetStateProperty.all(
                      //     Colors.amber,
                      //   ),
                      // ),
                    ),
                    // correctString: '123456',
                    onOpened: () {
                      logger.d("open !");
                    },
                    // onUnlocked: () {
                    //   logger.d("boom!");
                    // },
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
