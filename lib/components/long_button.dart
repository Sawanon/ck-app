import 'package:flutter/material.dart';
import 'package:lottery_ck/res/color.dart';

class LongButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget child;
  const LongButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: Size(MediaQuery.of(context).size.width, 48),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
