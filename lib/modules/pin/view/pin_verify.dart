import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/modules/pin/controller/pin_verify.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

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
              Container(
                child: Column(
                  children: [
                    Obx(() {
                      if (SettingController.to.profileByte.value != null) {
                        return Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.memory(
                            SettingController.to.profileByte.value!,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    const SizedBox(height: 8),
                    Text(
                      SettingController.to.user?.fullName ?? "",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      CommonFn.hidePhoneNumber(
                          SettingController.to.user?.phoneNumber),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textPrimary.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: controller.disable
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.blockMessage ?? "-",
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: 100,
                              height: 100,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                AppIcon.lock,
                                width: 36,
                                height: 36,
                                colorFilter: const ColorFilter.mode(
                                    Colors.white, BlendMode.srcIn),
                              ),
                            ),
                            const SizedBox(height: 96),
                          ],
                        ),
                      )
                    : ScreenLock(
                        // correctString: controller.passcode!,
                        correctString: "123456",
                        maxRetries: controller.maxRetry,
                        delayBuilder: (context, delay) {
                          return Text(
                            controller.delayMessage ?? "-",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.errorBorder,
                            ),
                          );
                        },
                        retryDelay: controller.retryDelay,
                        // retryDelay: Duration.zero,
                        onOpened: () {
                          logger.d("message");
                        },
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
                            if (controller.errorMessage != null) ...[
                              Text(
                                controller.errorMessage!,
                                style: const TextStyle(
                                  color: AppColors.errorBorder,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
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
                        customizedButtonChild: SizedBox(
                          width: 60,
                          height: 60,
                          child: SvgPicture.asset(
                            AppIcon.fingerScan,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        customizedButtonTap: () {
                          controller.useBiometrics();
                        },
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
                      "${AppLocale.forgetPasscode.getString(context)}?",
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
