import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/bill/controller/bill.controller.dart';
import 'package:lottery_ck/modules/bill/view/bill_component.dart';
import 'package:lottery_ck/res/color.dart';

class BillPage extends StatelessWidget {
  const BillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BillController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: controller.bill != null
                    ? BillComponent(bill: controller.bill!)
                    : const SizedBox.shrink(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(MediaQuery.of(context).size.width, 48),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    controller.backToHome();
                  },
                  child: Text(
                    "ກັບໄປທີ່ຫນ້າທໍາອິດ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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
