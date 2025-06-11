import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:google_fonts/google_fonts.dart';

enum Prefix { mr, mrs }

class PrefixRadio extends StatefulWidget {
  final void Function(Prefix prefix) onChange;
  final bool disabled;
  // final String? defaultValue;
  final String value;
  final String? errorText;
  const PrefixRadio({
    super.key,
    required this.onChange,
    this.disabled = false,
    // this.defaultValue,
    required this.value,
    this.errorText,
  });

  @override
  State<PrefixRadio> createState() => PrefixRadioState();
}

class PrefixRadioState extends State<PrefixRadio> {
  Prefix? valueGender;

  void onChange(Prefix gender) {
    widget.onChange(gender);
    setState(() {
      valueGender = gender;
    });
  }

  // @override
  // void initState() {
  //   // if (widget.defaultValue == null) return;
  //   // if (widget.defaultValue == "mr") {
  //   //   onChange(Prefix.mr);
  //   // } else if (widget.defaultValue == "mrs") {
  //   //   onChange(Prefix.mrs);
  //   // }
  //   super.initState();
  // }

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
                  onTap: () {
                    if (widget.disabled) {
                      return;
                    }
                    onChange(Prefix.mr);
                  },
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
                              color: widget.value == Prefix.mr.name
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
                  onTap: () {
                    if (widget.disabled) {
                      return;
                    }
                    onChange(Prefix.mrs);
                  },
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
                              color: widget.value == Prefix.mrs.name
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
  }
}
