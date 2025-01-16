import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/constant.dart';
import 'package:lottery_ck/utils.dart';

class DialogChangeUrl extends StatefulWidget {
  const DialogChangeUrl({super.key});

  @override
  State<DialogChangeUrl> createState() => _DialogChangeUrlState();
}

class _DialogChangeUrlState extends State<DialogChangeUrl> {
  String url = "";

  void onChangeUrl(String value) {
    setState(() {
      url = value;
    });
  }

  void onSubmit() {
    logger.d(AppConst.apiUrl);
    AppConst.apiUrl = url;
    logger.d(AppConst.apiUrl);
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    onChangeUrl(AppConst.apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(url),
              const SizedBox(height: 8),
              InputText(
                onChanged: onChangeUrl,
                onlyLaos: false,
              ),
              const SizedBox(height: 8),
              LongButton(
                onPressed: onSubmit,
                child: Text(
                  "Save",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
