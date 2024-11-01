import 'package:flutter/material.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class PayByPointComponent extends StatefulWidget {
  final void Function(int value) onChange;
  final int? maxPoint;
  const PayByPointComponent({
    super.key,
    required this.onChange,
    required this.maxPoint,
  });

  @override
  State<PayByPointComponent> createState() => _PayByPointComponentState();
}

class _PayByPointComponentState extends State<PayByPointComponent> {
  int? value;

  void onChange(int value) {
    widget.onChange(value);

    setState(() {
      this.value = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => widget.maxPoint != null && widget.maxPoint! < 1000
                    ? null
                    : onChange(1000),
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.maxPoint != null && widget.maxPoint! < 1000
                        ? AppColors.disable
                        : Colors.white,
                    border: Border.all(
                      width: 1,
                      color: value == 1000
                          ? AppColors.primary
                          : AppColors.borderGray,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    CommonFn.parseMoney(1000),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => widget.maxPoint != null && widget.maxPoint! < 2000
                    ? null
                    : onChange(2000),
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.maxPoint != null && widget.maxPoint! < 2000
                        ? AppColors.disable
                        : Colors.white,
                    border: Border.all(
                      width: 1,
                      color: value == 2000
                          ? AppColors.primary
                          : AppColors.borderGray,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(CommonFn.parseMoney(2000)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => widget.maxPoint != null && widget.maxPoint! < 5000
                    ? null
                    : onChange(5000),
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.maxPoint != null && widget.maxPoint! < 5000
                        ? AppColors.disable
                        : Colors.white,
                    border: Border.all(
                      width: 1,
                      color: value == 5000
                          ? AppColors.primary
                          : AppColors.borderGray,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(CommonFn.parseMoney(5000)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => widget.maxPoint != null && widget.maxPoint! < 10000
                    ? null
                    : onChange(10000),
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.maxPoint != null && widget.maxPoint! < 10000
                        ? AppColors.disable
                        : Colors.white,
                    border: Border.all(
                      width: 1,
                      color: value == 10000
                          ? AppColors.primary
                          : AppColors.borderGray,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(CommonFn.parseMoney(10000)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
