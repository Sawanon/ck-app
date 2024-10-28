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
