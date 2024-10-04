import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/pin/controller/pin_verify.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class PinVerifyPage extends StatelessWidget {
  final bool? disabledBackButton;
  const PinVerifyPage({
    super.key,
    this.disabledBackButton,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PinVerifyController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              HeaderCK(
                disabledBackButton: disabledBackButton,
                onTap: () {
                  Get.back();
                },
              ),
              Expanded(
                child: ScreenLock(
                  // correctString: controller.passcode!,
                  correctString: "123456",
                  onUnlocked: () {
                    logger.d("success fake");
                  },
                  onValidate: controller.verifyPasscode,
                  useBlur: false,
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "ຢືນຢັນ Passcode ຂອງທ່ານ",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Obx(() {
                          if (controller.pendingVerify.value) {
                            return CircularProgressIndicator(
                              color: AppColors.primary,
                            );
                          }
                          return SizedBox.shrink();
                        }),
                      )
                    ],
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
                ),
              ),
              if (controller.enableForgetPasscode)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: GestureDetector(
                    onTap: () {
                      logger.d("message received");
                      controller.forgetPasscode();
                    },
                    child: Text(
                      "forget passcode?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2,
                        decorationColor: AppColors.textPrimary,
                      ),
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
