import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottery_ck/res/color.dart';

class InputText extends StatelessWidget {
  final void Function(String value)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? errorText;
  final bool disabled;
  final bool isError;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const InputText({
    super.key,
    this.onChanged,
    this.validator,
    this.disabled = false,
    this.controller,
    this.isError = false,
    this.errorText,
    this.maxLength,
    this.inputFormatters,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: disabled,
      keyboardType: keyboardType,
      inputFormatters: [
        ...inputFormatters ?? [],
        FilteringTextInputFormatter.allow(
          RegExp(r'[ກ-ໝໜໞໟ໠-໽, 0-9]'), // ชุดตัวอักษรภาษาลาว
        ),
      ],
      maxLength: maxLength,
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
