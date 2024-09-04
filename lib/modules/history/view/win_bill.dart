import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/bill/view/bill_component.dart';
import 'package:lottery_ck/modules/history/controller/win_bill.contoller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class WinBillPage extends StatelessWidget {
  const WinBillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WinBillContoller>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              if (controller.invoice != null)
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "ເຈົ້າເປັນຜູ້ໂຊກດີ ແລະໄດ້ຮັບລາງວັນ",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        CommonFn.parseMoney(controller.invoice!["totalWin"]),
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              if (controller.bill != null)
                Expanded(
                  child: BillComponent(bill: controller.bill!),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: LongButton(
                  onPressed: () {
                    navigator?.pop();
                  },
                  child: const Text(
                    "ປິດ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
