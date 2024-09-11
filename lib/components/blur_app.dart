import 'package:flutter/material.dart';
import 'package:lottery_ck/res/logo.dart';

class BlurApp extends StatelessWidget {
  final String identifier;

  const BlurApp({super.key, required this.identifier});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Image.asset(Logo.lotto),
    );
  }
}
