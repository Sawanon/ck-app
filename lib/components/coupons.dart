import 'package:flutter/material.dart';
import 'package:lottery_ck/components/header.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: "Coupons",
            ),
            Expanded(
              child: ListView(
                children: [
                  Text("Coupons"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
