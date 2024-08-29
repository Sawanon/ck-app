import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';
import 'package:lottery_ck/utils.dart';

class Pin {
  static Future<void> verifyPin(
      BuildContext context, void Function() onUnlocked) async {
    final passcode = await AppWriteController.to.getPasscode();
    InputController inputController = InputController();
    if (passcode == null) return;
    if (context.mounted) {
      await screenLock(
        context: context,
        inputController: inputController,
        correctString: passcode,
        // canCancel: false,
        maxRetries: 3,
        retryDelay: const Duration(seconds: 30),
        onUnlocked: onUnlocked,
        onMaxRetries: (value) {
          navigator?.pop();
        },
      );
    }
  }
}
