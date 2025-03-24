import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class DialogChangeBirthtimeComponentV2 extends StatefulWidget {
  final Future<void> Function() onSuccess;
  final Future<void> Function() onUnknowBirthDate;
  const DialogChangeBirthtimeComponentV2({
    super.key,
    required this.onSuccess,
    required this.onUnknowBirthDate,
  });

  @override
  State<DialogChangeBirthtimeComponentV2> createState() =>
      _DialogChangeBirthtimeComponentV2State();
}

class _DialogChangeBirthtimeComponentV2State
    extends State<DialogChangeBirthtimeComponentV2> {
  TimeOfDay? birthTime;
  bool isLoading = false;

  void setLoading(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  void changeBirthTime(TimeOfDay birthTime) {
    setState(() {
      this.birthTime = birthTime;
    });
  }

  void confirmDateTime() async {
    setLoading(true);
    final userDocument = await SettingController.to.changeBirthTime(birthTime!);
    setLoading(false);
    if (userDocument == null) {
      Get.snackbar("Something went wrong",
          "please try again dialog_change_birthtime:43");
      return;
    }
    Get.back();
    await Future.delayed(
      const Duration(
        milliseconds: 300,
      ),
      () {
        widget.onSuccess();
        // HomeController.to.gotoHoroScope();
      },
    );
  }

  void onUnknowBirthDate() async {
    Get.back();
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        widget.onUnknowBirthDate();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: AppLocale.birthTime.getString(context),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocale.birthTimeHoroscope.getString(context),
                      style: TextStyle(
                        fontSize: 20,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocale.birthTime.getString(context),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: birthTime ?? TimeOfDay.now(),
                        initialEntryMode: TimePickerEntryMode.input,
                      );
                      logger.d(time);
                      if (time == null) return;
                      changeBirthTime(time);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: AppColors.primary,
                          // color: controller.unknowBirthTime
                          //     ? AppColors.disable
                          //     : AppColors.primary,
                        ),
                      ),
                      child: Text(
                        birthTime == null
                            ? "--:--"
                            : CommonFn.parseTimeOfDayToHMS(birthTime!),
                        // "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}",
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  LongButton(
                    disabled: isLoading || birthTime == null,
                    onPressed: () {
                      if (birthTime == null) return;
                      confirmDateTime();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocale.confirm.getString(context),
                        ),
                        if (isLoading) ...[
                          SizedBox(width: 8),
                          SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          )
                        ]
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  LongButton(
                    disabled: isLoading,
                    onPressed: () => onUnknowBirthDate(),
                    borderSide: BorderSide(
                      width: 1,
                      color: AppColors.primary,
                    ),
                    backgroundColor: Colors.white,
                    child: Text(
                      AppLocale.unknownTimeOfBirth.getString(context),
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
    );
  }
}
