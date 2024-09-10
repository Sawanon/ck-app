import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/pin/controller/pin_verify.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/color.dart';

class PinVerifyPage extends StatelessWidget {
  const PinVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PinVerifyController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Header(
                disabledBackButton: true,
                onTap: () {},
              ),
              Expanded(
                child: controller.passcode != null
                    ? ScreenLock(
                        correctString: controller.passcode!,
                        onUnlocked: () {
                          controller.whenSuccess();
                        },
                        useBlur: false,
                        title: Text(
                          "ຢືນຢັນ Passcode ຂອງທ່ານ",
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
                              overlayColor:
                                  WidgetStateProperty.all(Colors.white),
                              foregroundColor: WidgetStateProperty.all(
                                  AppColors.textPrimary),
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
                        ))
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
