import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/utils.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (controller) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            child: ElevatedButton(
              onPressed: () {
                logger.d("log out");
                controller.logout();
              },
              child: Text("Log out"),
            ),
          ),
        ),
      );
    });
  }
}
