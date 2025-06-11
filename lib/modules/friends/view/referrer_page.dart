import 'package:flutter/material.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferrerPage extends StatelessWidget {
  const ReferrerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(
              title: 'Referrer',
            ),
            Expanded(
              child: ListView(
                children: [
                  // referrer card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        // profile image & full name
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 32,
                            ),
                            Text(
                              "firstName lastName",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        // expire date
                        Row(
                          children: [
                            Text(
                              "Expire date",
                              style: TextStyle(
                                color: AppColors.disableText,
                              ),
                            ),
                            Text(
                              "2025-08-20",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            LongButton(
              onPressed: () {
                // TODO: change page to edit referrer form
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  Text(
                    "Edit Referrer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
