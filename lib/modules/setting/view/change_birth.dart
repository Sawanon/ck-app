import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class ChangeBirthPage extends StatefulWidget {
  const ChangeBirthPage({super.key});

  @override
  State<ChangeBirthPage> createState() => _ChangeBirthPageState();
}

class _ChangeBirthPageState extends State<ChangeBirthPage> {
  DateTime? birthDate;
  TimeOfDay? birthTime;

  void changeBirthDate(DateTime date) {
    setState(() {
      birthDate = date;
    });
  }

  void changeBirthTime(TimeOfDay time) {
    setState(() {
      birthTime = time;
    });
  }

  @override
  void initState() {
    birthDate = UserController.to.user.value?.birthDate;
    final initBirthTime = UserController.to.user.value?.birthTime;
    logger.d(initBirthTime);
    logger.d(initBirthTime != null);
    logger.d(initBirthTime == "");
    if (initBirthTime != null && initBirthTime != "") {
      birthTime = TimeOfDay(
        hour: int.parse(initBirthTime.split(":").first),
        minute: int.parse(initBirthTime.split(":").last),
      );
    }
    // setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: AppLocale.birthDate.getString(context),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocale.birthDate.getString(context),
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
                      final datetime = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1970),
                        lastDate: DateTime.now(),
                        initialDate: birthDate ?? DateTime.now(),
                      );
                      logger.d("datetime: $datetime");
                      birthDate = datetime;
                      // controller.changeBirthDate(datetime);
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
                        ),
                      ),
                      child: Text(
                        // "-"
                        birthDate == null
                            ? "--/--/----"
                            : CommonFn.parseDMY(birthDate!),
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
                      birthTime = time;
                      // controller.changeBirthTime(time);
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
                  const SizedBox(height: 32),
                  LongButton(
                    onPressed: () {
                      if (birthDate == null && birthTime == null) {
                        return;
                      }
                      SettingController.to.changeBirth(birthDate!, birthTime!);
                    },
                    child: Text(
                      AppLocale.confirm.getString(context),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
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
