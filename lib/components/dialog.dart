import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/color.dart';

class DialogApp extends StatelessWidget {
  final void Function()? onConfirm;
  final void Function()? onCancel;
  final Widget confirmText;
  final Widget cancelText;
  final Widget title;
  final bool disableConfirm;
  const DialogApp({
    super.key,
    this.onConfirm,
    this.onCancel,
    this.confirmText = const Text("Confirm"),
    this.cancelText = const Text(
      "Cancel",
      style: TextStyle(
        color: AppColors.primary,
      ),
    ),
    this.title = const Text("Title"),
    this.disableConfirm = false,
  });

  void onClose() {
    Get.back();
    if (onCancel != null) {
      onCancel!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              title,
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: LongButton(
                      backgroundColor: Colors.white,
                      borderSide: const BorderSide(
                        width: 1,
                        color: AppColors.primary,
                      ),
                      onPressed: onClose,
                      child: cancelText,
                    ),
                  ),
                  if (!disableConfirm) const SizedBox(width: 8),
                  if (!disableConfirm)
                    Expanded(
                      child: LongButton(
                        onPressed: onConfirm,
                        child: confirmText,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
