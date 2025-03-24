import 'package:flutter/material.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class SwitchComponent extends StatefulWidget {
  final void Function(bool value) onChange;
  final bool value;
  const SwitchComponent({
    super.key,
    required this.onChange,
    required this.value,
  });

  @override
  State<SwitchComponent> createState() => _SwitchComponentState();
}

class _SwitchComponentState extends State<SwitchComponent> {
  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      activeColor: AppColors.primary,
      inactiveThumbColor: Colors.white,
      thumbIcon: WidgetStateProperty.all(
        const Icon(
          Icons.circle,
          color: Colors.transparent,
        ),
      ),
      inactiveTrackColor: AppColors.background,
      trackOutlineWidth: WidgetStateProperty.all(0),
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      // Don't use the ambient CupertinoThemeData to style this switch.
      applyCupertinoTheme: false,
      value: widget.value,
      onChanged: widget.onChange,
    );
  }
}
