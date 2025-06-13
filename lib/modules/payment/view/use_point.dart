import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/controller/user_controller.dart';
import 'package:lottery_ck/modules/setting/controller/setting.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:google_fonts/google_fonts.dart';

class UsePointComponent extends StatefulWidget {
  final double myPoint;
  final Future<void> Function(int usePoint) onSubmit;
  const UsePointComponent({
    super.key,
    required this.myPoint,
    required this.onSubmit,
  });

  @override
  State<UsePointComponent> createState() => _UsePointComponentState();
}

class _UsePointComponentState extends State<UsePointComponent> {
  TextEditingController inputPointController = TextEditingController();
  int pointUse = 0;
  bool isLoading = false;

  void setPoint(int point) {
    logger.d(point);
    if (point > widget.myPoint) {
      return;
    }
    inputPointController.text = CommonFn.parseMoney(point);
    setState(() {
      pointUse = point;
    });
  }

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  // void setup() async {
  //   inputPointController.text = "${widget.myPoint}";
  //   setPoint(widget.myPoint);
  // }

  void submitUsePoint() async {
    try {
      setLoading(true);
      await widget.onSubmit(pointUse);
    } finally {
      setLoading(false);
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   setup();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        left: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocale.point.getString(context),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocale.yourScoreIs.getString(context),
              ),
              Obx(() {
                return Text(
                  "${CommonFn.parseMoney(UserController.to.user.value?.point ?? 0)} ${AppLocale.point.getString(context)}",
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocale.theMaximumPointsYouCanUse.getString(context),
                ),
              ),
              Text(
                "${CommonFn.parseMoney(widget.myPoint)} ${AppLocale.point.getString(context)}",
              ),
            ],
          ),
          Text(
            "(${AppLocale.notIncludedWithOtherPromotions.getString(context)})",
            style: TextStyle(
              fontSize: 12,
              color: Colors.red.shade300,
            ),
          ),
          const SizedBox(height: 24),
          InputText(
            controller: inputPointController,
            label: Text(
              AppLocale.enterThePointsYouWantToUse.getString(context),
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            maxValue: widget.myPoint.toInt(),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              logger.d(value);
              final point = value == "" ? "0" : value;
              final pointString = point.replaceAll(",", "");
              setPoint(int.parse(pointString));
            },
          ),
          const SizedBox(height: 8),
          LongButton(
            isLoading: isLoading,
            onPressed: () {
              submitUsePoint();
            },
            child: Text(
              AppLocale.confirm.getString(context),
            ),
          ),
        ],
      ),
    );
  }
}
