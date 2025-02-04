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
  final Widget? label;
  final int? maxValue;
  final String? initialValue;
  final String? counterText;
  final bool onlyLaos;
  final bool onlyText;
  final TextAlign textAlign;

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
    this.label,
    this.maxValue,
    this.initialValue,
    this.counterText,
    this.onlyLaos = true,
    this.onlyText = false,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      readOnly: disabled,
      keyboardType: keyboardType,
      inputFormatters: [
        ...inputFormatters ?? [],
        if (onlyLaos)
          FilteringTextInputFormatter.allow(
            RegExp(r'[ກ-ໝໜໞໟ໠-໽, 0-9, /]'), // ชุดตัวอักษรภาษาลาว
          ),
        if (onlyText)
          FilteringTextInputFormatter.allow(
            RegExp(r'[^\d]'), // อนุญาตเฉพาะตัวอักษรที่ไม่ใช่ตัวเลข
          ),
        if (keyboardType == TextInputType.number)
          CustomRangeTextInputFormatter(maxValue ?? 1000000),
        // CustomRangeTextInputFormatter(),
      ],
      maxLength: maxLength,
      textAlign: textAlign,
      decoration: InputDecoration(
        counterText: counterText,
        label: label,
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
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

class CustomRangeTextInputFormatter extends TextInputFormatter {
  final int maxValue;

  CustomRangeTextInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final int? value = int.tryParse(newValue.text);
    if (value != null && value <= maxValue) {
      return newValue;
    }
    return oldValue; // ย้อนกลับไปใช้ค่าก่อนหน้า
  }
}
