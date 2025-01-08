import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class UsePointComponent extends StatefulWidget {
  final int myPoint;
  final void Function(int usePoint) onSubmit;
  const UsePointComponent({
    super.key,
    required this.myPoint,
    required this.onSubmit,
  });

  @override
  State<UsePointComponent> createState() => _UsePointComponentState();
}

class _UsePointComponentState extends State<UsePointComponent> {
  int pointUse = 0;

  void setPoint(int point) {
    if (point > widget.myPoint) {
      return;
    }
    setState(() {
      pointUse = point;
    });
  }

  void submitUsePoint() async {
    widget.onSubmit(pointUse);
  }

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
            children: [
              Expanded(
                child: Text(
                  AppLocale.theMaximumPointsYouCanUse.getString(context),
                ),
              ),
              Text(
                CommonFn.parseMoney(widget.myPoint),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InputText(
            label: Text(
              AppLocale.enterThePointsYouWantToUse.getString(context),
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            maxValue: widget.myPoint,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final point = value == "" ? "0" : value;
              setPoint(int.parse(point));
            },
          ),
          const SizedBox(height: 8),
          LongButton(
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
