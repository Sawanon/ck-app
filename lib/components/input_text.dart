import 'package:flutter/material.dart';
import 'package:lottery_ck/res/color.dart';

class InputText extends StatelessWidget {
  final void Function(String value)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? errorText;
  final bool disabled;
  final bool isError;
  const InputText({
    super.key,
    this.onChanged,
    this.validator,
    this.disabled = false,
    this.controller,
    this.isError = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: disabled,
      decoration: InputDecoration(
        errorText: errorText,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: isError ? AppColors.errorBorder : AppColors.inputBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: isError ? AppColors.errorBorder : AppColors.inputBorder,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: AppColors.errorBorder,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: AppColors.errorBorder,
            width: 2,
          ),
        ),
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
