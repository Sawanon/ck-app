import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class FriendConfirm extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final Uint8List? profileByte;
  final void Function()? onConfirm;
  final void Function()? onCancel;
  final void Function()? onBack;
  // final profile
  const FriendConfirm({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.onConfirm,
    this.onCancel,
    this.onBack,
    this.profileByte,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Header(
                title: '',
                onBack: onBack,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocale.youAreBecomingFriendsWith.getString(context),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: 100,
                      height: 100,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: profileByte != null
                          ? Image.memory(
                              profileByte!,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.person,
                              size: 42,
                            ),
                    ),
                    const SizedBox(height: 16),
                    Text("$firstName $lastName"),
                    const SizedBox(height: 8),
                    Text(CommonFn.hidePhoneNumber(phone)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LongButton(
                      onPressed: onConfirm,
                      child: Text(
                        AppLocale.confirm.getString(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    LongButton(
                      borderSide: BorderSide(
                        width: 1,
                        color: AppColors.primary,
                      ),
                      backgroundColor: Colors.white,
                      onPressed: onCancel,
                      child: Text(
                        AppLocale.cancel.getString(context),
                        style: TextStyle(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
