import 'package:flutter/material.dart';
import 'package:lottery_ck/res/color.dart';

class LongButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  final Size? minimumSize;
  final Size? maximumSize;
  final Color? backgroundColor;
  final BorderSide borderSide;
  final bool disabled;
  const LongButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.minimumSize,
    this.maximumSize,
    this.backgroundColor = AppColors.primary,
    this.borderSide = BorderSide.none,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: minimumSize,
        maximumSize: maximumSize,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: borderSide,
        ),
        fixedSize: Size(MediaQuery.of(context).size.width, 48),
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
      onPressed: disabled ? null : onPressed,
      child: child,
    );
  }
}
