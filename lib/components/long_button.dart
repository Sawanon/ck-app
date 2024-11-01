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
  final BorderRadiusGeometry? borderRadius;
  final bool isLoading;
  const LongButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.minimumSize,
    this.maximumSize,
    this.backgroundColor = AppColors.primary,
    this.borderSide = BorderSide.none,
    this.disabled = false,
    this.borderRadius,
    this.isLoading = false,
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
          borderRadius:
              borderRadius == null ? BorderRadius.circular(10) : borderRadius!,
          side: borderSide,
        ),
        fixedSize: Size(MediaQuery.of(context).size.width, 48),
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
      ),
      onPressed: disabled
          ? null
          : isLoading
              ? () {}
              : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading) ...[
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
          ],
          child,
        ],
      ),
    );
  }
}
