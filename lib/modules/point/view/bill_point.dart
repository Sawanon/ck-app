import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/color.dart';

class BillPoint extends StatelessWidget {
  final void Function() onBackHome;
  final void Function() onBuyAgain;
  const BillPoint({
    super.key,
    required this.onBackHome,
    required this.onBuyAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 52,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "การซื้อสำเร็จ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("จำนวน point ที่ได้รับ"),
                        Text(
                          "+5000",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ยอดเงินที่ชำระ"),
                        Text("5000"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("วันที่เวลาที่ซื้อ"),
                        Text("21/04/2025 11:23"),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LongButton(
                  borderSide: BorderSide(
                    width: 1,
                    color: AppColors.primary,
                  ),
                  backgroundColor: Colors.white,
                  onPressed: onBuyAgain,
                  child: Text(
                    "ซื้อคะแนนเพิ่ม",
                    style: TextStyle(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: LongButton(
                  onPressed: onBackHome,
                  child: Text("กลับหน้าหลัก"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
