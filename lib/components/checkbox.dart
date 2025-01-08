import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';

class CheckboxComponent extends StatefulWidget {
  final bool value;
  final void Function(bool value) onChange;
  const CheckboxComponent({
    super.key,
    required this.value,
    required this.onChange,
  });

  @override
  State<CheckboxComponent> createState() => _CheckboxComponentState();
}

class _CheckboxComponentState extends State<CheckboxComponent> {
  bool value = false;

  void setup() {
    setState(() {
      value = widget.value;
    });
  }

  void onChange(bool value) {
    // logger.d("value: in $value");
    widget.onChange(value);
  }

  @override
  void initState() {
    setup();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CheckboxComponent oldWidget) {
    setup();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange(!value);
      },
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : Colors.white,
          border: Border.all(
            width: 1,
            color: value ? Colors.transparent : AppColors.primary,
          ),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.check_rounded,
          size: 20,
          color: value ? Colors.white : Colors.transparent,
        ),
      ),
    );
  }
}
