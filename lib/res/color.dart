import 'package:flutter/material.dart';

class AppColors {
  // static const Color primary = Color.fromRGBO(0, 209, 255, 1);
  static const Color background = Color.fromRGBO(245, 245, 245, 1);
  static const Color primary = Color.fromRGBO(242, 49, 55, 1);
  // static const Color primary = Color.fromRGBO(54, 70, 116, 1);
  static const Color primary20 = Color.fromRGBO(252, 214, 215, 1);
  // static const Color primary20 = Color.fromRGBO(210, 213, 223, 1);
  static const Color primaryBackground = Color.fromRGBO(238, 239, 239, 1);
  static const Color primaryOpacity = Color.fromRGBO(253, 233, 228, 1);
  static const Color primaryEnd = Color.fromRGBO(253, 150, 153, 1);
  static const Color backgroundGradientEnd = Color.fromRGBO(232, 242, 255, 1);
  static const Color backgroundGradientStart = Color.fromRGBO(255, 255, 255, 1);
  static const Color textPrimary = Color.fromRGBO(70, 76, 89, 1);
  static const Color backButton = Color.fromRGBO(237, 237, 237, 1);
  static const Color backButtonHover = Color.fromRGBO(203, 203, 203, 1);
  static const Color inputBorder = Color.fromRGBO(199, 199, 199, 1);
  static const Color containerBorder = Color.fromRGBO(241, 241, 241, 1);
  static const Color kycBackground = Color.fromRGBO(255, 249, 247, 1);
  static const Color documentBackground = Color.fromRGBO(233, 233, 233, 1);
  static const Color menuIcon = Color.fromRGBO(197, 64, 50, 1);
  static const Color menuIconDisabled = Color.fromRGBO(204, 204, 204, 1);
  static const Color menuBackgroundDisabled = Color.fromRGBO(235, 235, 235, 1);
  static const Color menuTextDisabled = Color.fromRGBO(137, 136, 136, 1);

  static const Color shadow = Color.fromRGBO(174, 174, 192, 0.4);
  static const Color yellowGradient = Color.fromRGBO(255, 194, 36, 1);
  static const Color redGradient = Color.fromRGBO(242, 49, 49, 1);

  static const Color winContainer = Color.fromRGBO(132, 255, 144, 1);

  static const Color borderGray = Color.fromRGBO(219, 219, 219, 1);
  static const Color errorBorder = Color.fromRGBO(242, 49, 55, 1);
  static const Color disable = Color.fromRGBO(229, 229, 229, 1);
  static const Color disableText = Color.fromRGBO(172, 172, 172, 1);
  static const Color secodaryText = Color.fromRGBO(135, 135, 135, 1);
  static const Color secodaryBorder = Color.fromRGBO(217, 217, 217, 1);
  static const Color secondary = Color.fromRGBO(0, 117, 255, 1);
  static const Color secondaryColor = Color.fromRGBO(216, 170, 76, 1);

  static const Color foreground = Color.fromRGBO(243, 243, 243, 1);
  static const Color foregroundBorder = Color.fromRGBO(241, 240, 240, 1);

  static const Color zinZaeBackground = Color.fromRGBO(36, 36, 68, 1);
  static const Color redTone = Color.fromRGBO(239, 45, 41, 1);
  static const Color kycBanner = Color.fromRGBO(255, 93, 93, 1);

  static const Color wheelOdd = Color.fromRGBO(153, 28, 10, 1);
  static const Color wheelEven = Color.fromRGBO(119, 19, 8, 1);
  static const Color wheelItemBorder = Color.fromRGBO(185, 38, 14, 1);
  static const Color wheelText = Color.fromRGBO(249, 211, 124, 1);
  static const Color wheelBackground = Color.fromRGBO(142, 24, 9, 1);
  static const Color wheelBorderStart = Color.fromRGBO(250, 186, 65, 1);
  static const Color wheelBorderEnd = Color.fromRGBO(174, 87, 17, 1);
  static const Color wheelBorder = Color.fromRGBO(255, 213, 77, 1);
  static const Color wheelInnerBackgroundStart = Color.fromRGBO(153, 31, 11, 1);
  static const Color wheelInnerBackgroundEnd = Color.fromRGBO(126, 23, 8, 1);

  static LinearGradient primayBtn = LinearGradient(
    colors: [
      primary.withOpacity(0.4),
      primary,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
