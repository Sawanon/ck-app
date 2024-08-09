import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/pin/controller/pin.controller.dart';
import 'package:lottery_ck/modules/signup/view/signup.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final pinController = PinController.to;

  @override
  void dispose() {
    logger.d("nope !");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PinController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Header(
                  disabledBackButton: true,
                  onTap: () {
                    logger.d("message");
                  },
                ),
                Expanded(
                  child: ScreenLock.create(
                    onConfirmed: (value) {
                      logger.d("confirm: $value");
                      controller.createPasscode(value);
                    },
                    confirmTitle: Text(
                      "ຢືນຢັນ Passcode ຂອງທ່ານ",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    digits: 6,
                    useBlur: false,
                    title: Text(
                      "ສ້າງ Passcode ຂອງທ່ານ",
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
