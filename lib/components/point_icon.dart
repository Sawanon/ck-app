import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:google_fonts/google_fonts.dart';

class PointIcon extends StatelessWidget {
  const PointIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Color.fromRGBO(33, 165, 81, 1),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Container(
        width: 29,
        height: 29,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Text(
          "P",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(33, 165, 81, 1),
          ),
        ),
      ),
    );
  }
}
