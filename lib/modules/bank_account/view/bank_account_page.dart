import 'package:flutter/material.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/long_button.dart';

class BankAccountPage extends StatelessWidget {
  const BankAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool alreadyData = false;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(
              title: "Bank account",
            ),
            Expanded(
              child: ListView(
                children: [
                  // bank list select box
                  // dropBox disable when already data
                  // input enter account number
                  Text(
                    "Account number",
                  ),
                  InputText(
                    disabled: alreadyData,
                  ),
                  // Name account ?
                  Text(
                    "Account name",
                  ),
                  InputText(
                    disabled: alreadyData,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 16,
                left: 16,
                right: 16,
              ),
              child: LongButton(
                onPressed: () {
                  // add or edit bank account
                  if (alreadyData) {
                    // editBankAccount();
                    return;
                  }
                  // addBankAccount();
                },
                child: Text(
                  alreadyData
                      ? 'Edit bank account'
                      : 'Add or Edit bank account',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
