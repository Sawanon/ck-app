import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';

enum Gender { female, male }

class GenderRadio extends StatefulWidget {
  final void Function(Gender gender) onChange;
  const GenderRadio({
    super.key,
    required this.onChange,
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
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onChange(Gender.male),
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
                    "ผู้ชาย",
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
            onTap: () => onChange(Gender.female),
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
                    "ผู้หญิง",
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
              style: const TextStyle(
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
              style: const TextStyle(
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
