import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/route_manager.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';

class DialogApp extends StatefulWidget {
  final Future<void> Function()? onConfirm;
  final void Function()? onCancel;
  final Widget? confirmText;
  final Widget? cancelText;
  final Widget title;
  final Widget? details;
  final bool disableConfirm;
  const DialogApp({
    super.key,
    this.onConfirm,
    this.onCancel,
    this.confirmText,
    this.cancelText,
    this.title = const Text("Title"),
    this.details,
    this.disableConfirm = false,
  });

  @override
  State<DialogApp> createState() => _DialogAppState();
}

class _DialogAppState extends State<DialogApp> {
  bool isLoading = false;

  void setLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  void onClose() {
    Get.back();
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
  }

  void onConfirm() async {
    if (widget.onConfirm == null) return;
    setLoading(true);
    await widget.onConfirm!();
    setLoading(false);
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
              widget.title,
              if (widget.details != null) ...[
                const SizedBox(height: 8),
                widget.details!
              ],
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
                      child: widget.disableConfirm == true
                          ? Text(
                              AppLocale.close.getString(context),
                              style: const TextStyle(
                                color: AppColors.primary,
                              ),
                            )
                          : widget.cancelText ??
                              Text(
                                AppLocale.cancel.getString(context),
                                style: const TextStyle(
                                  color: AppColors.primary,
                                ),
                              ),
                    ),
                  ),
                  if (!widget.disableConfirm) const SizedBox(width: 8),
                  if (!widget.disableConfirm)
                    Expanded(
                      child: LongButton(
                        isLoading: isLoading,
                        onPressed: onConfirm,
                        child: widget.confirmText ??
                            Text(AppLocale.confirm.getString(context)),
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
