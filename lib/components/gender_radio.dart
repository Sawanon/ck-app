import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:google_fonts/google_fonts.dart';

enum Gender { female, male }

class GenderRadio extends StatefulWidget {
  final void Function(Gender gender) onChange;
  final bool disabled;
  final String? defaultValue;
  final String? errorText;
  const GenderRadio({
    super.key,
    required this.onChange,
    this.disabled = false,
    this.defaultValue,
    this.errorText,
  });

  @override
  State<GenderRadio> createState() => _GenderRadioState();
}

class _GenderRadioState extends State<GenderRadio> {
  Gender? valueGender;

  void onChange(Gender gender) {
    widget.onChange(gender);
    setState(() {
      valueGender = gender;
    });
  }

  @override
  void initState() {
    if (widget.defaultValue == null) return;
    if (widget.defaultValue == "male") {
      onChange(Gender.male);
    } else if (widget.defaultValue == "male") {
      onChange(Gender.female);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              width: 1,
              color: widget.errorText != null
                  ? AppColors.errorBorder
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => widget.disabled ? () {} : onChange(Gender.male),
                  child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: AppColors.inputBorder,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: valueGender == Gender.male
                                  ? Colors.red
                                  : Colors.white,
                              border: Border.all(
                                width: 1,
                                color: AppColors.inputBorder,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          AppLocale.mr.getString(context),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      widget.disabled ? () {} : onChange(Gender.female),
                  child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: AppColors.inputBorder,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          left: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: valueGender == Gender.female
                                  ? Colors.red
                                  : Colors.white,
                              border: Border.all(
                                width: 1,
                                color: AppColors.inputBorder,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          AppLocale.mrs.getString(context),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: TextStyle(
              color: AppColors.errorBorder,
              fontSize: 12,
            ),
          ),
        ]
      ],
    );
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            onChange(Gender.female);
          },
          child: Chip(
            avatar: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 4,
                  color: valueGender == Gender.female
                      ? AppColors.primary
                      : Colors.grey,
                ),
              ),
            ),
            label: Text(
              AppLocale.female.getString(context),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: valueGender == Gender.female
                ? AppColors.primary.withOpacity(0.2)
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 1,
                color: valueGender == Gender.female ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            onChange(Gender.male);
          },
          child: Chip(
            avatar: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 4,
                  color: valueGender == Gender.male
                      ? AppColors.primary
                      : Colors.grey,
                ),
              ),
            ),
            label: Text(
              AppLocale.male.getString(context),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: valueGender == Gender.male
                ? AppColors.primary.withOpacity(0.2)
                : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 1,
                color: valueGender == Gender.male ? Colors.red : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
