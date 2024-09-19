import 'package:flutter/material.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/logo.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class BillComponent extends StatelessWidget {
  final Bill bill;
  const BillComponent({
    super.key,
    required this.bill,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Colors.red.shade100,
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: AppColors.secodaryBorder,
                ),
              ),
            ),
            child: Text(
              'ກະຊວງການເງິນ ຫວຍພັດທະນາ ຈັດຈໍາໜ່າຍໂດຍ CK GROUP',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.secodaryText,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Image.asset(
            Logo.lotto,
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.width / 4,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              logger.d("message");
            },
            child: Image.asset(
              Logo.ck,
              height: 40,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "ຊື່ຜູ້ຊື້",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${bill.firstName} ${bill.lastName}",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "ວັນທີ ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        CommonFn.parseDMY(bill.dateTime.toLocal()),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "ໂທລະສັບ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        bill.phoneNumber,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "ວັນທີ ",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        CommonFn.parseHMS(bill.dateTime.toLocal()),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "ງວດວັນທີี่ ${bill.lotteryDateStr}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1,
                  color: AppColors.yellowGradient,
                ),
                bottom: BorderSide(
                  width: 1,
                  color: AppColors.yellowGradient,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ເລກທີຊື້',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'ຈໍານວນເງິນ',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: bill.lotteryList.map(
              (lottery) {
                return Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(lottery.lottery),
                      Text(CommonFn.parseMoney(lottery.price)),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 5,
                  color: AppColors.yellowGradient,
                ),
                bottom: BorderSide(
                  width: 5,
                  color: AppColors.yellowGradient,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ລວມເງິນ"),
                Text(
                  CommonFn.parseMoney(int.parse(bill.totalAmount)),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "ເລກທີບິນຫວຍ: ${bill.invoiceId}",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "ຊໍາລະໂດຍ: LDB Trust",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "ຕິດຕໍ່ CK GROUP: 0865446524",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
