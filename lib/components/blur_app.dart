import 'package:flutter/material.dart';
import 'package:lottery_ck/res/logo.dart';

class BlurApp extends StatelessWidget {
  final String identifier;

  const BlurApp({super.key, required this.identifier});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Container(
          width: 150,
          height: 150,
          margin: const EdgeInsets.only(top: 8),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            Logo.app,
            fit: BoxFit.none,
            width: 200,
            height: 200,
            scale: 2.2,
          ),
        ),
      ),
    );
  }
}
