import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottery_ck/model/bill.dart';
import 'package:lottery_ck/res/app_locale.dart';
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
              '${AppLocale.titleBill.getString(context)} CK GROUP',
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
          Image.asset(
            Logo.ck,
            height: 40,
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
                        // AppLocale.buyerName.getString(context),
                        "${AppLocale.customerId.getString(context)}:",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      // Text(
                      //   AppLocale.buyerName.getString(context),
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: AppColors.secondary,
                      //   ),
                      // ),
                      // const SizedBox(width: 8),
                      // Text(
                      //   "${bill.firstName} ${bill.lastName}",
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: AppColors.secondary,
                      //   ),
                      // ),
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
                        bill.customerId.replaceAll("+", ""),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      // Text(
                      //   "ໂທລະສັບ",
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: AppColors.secondary,
                      //   ),
                      // ),
                      // const SizedBox(width: 8),
                      // Text(
                      //   bill.phoneNumber,
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: AppColors.secondary,
                      //   ),
                      // ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "ເວລາ ",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ງວດ: ${bill.lotteryDateStr}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "ອອກວັນທີี่ ${CommonFn.parseCollectionToDate(bill.lotteryDateStr)}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
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
                      Text(CommonFn.parseMoney(lottery.quota)),
                    ],
                  ),
                );
              },
            ).toList(),
          ),
          if (bill.pointMoney != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Point discount"),
                Text("-${bill.pointMoney?.toString() ?? '-'}"),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discount"),
              Text(CommonFn.parseMoney(bill.lotteryList.fold(0,
                  (prev, transaction) => prev + (transaction.discount ?? 0)))),
            ],
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
                Builder(builder: (context) {
                  final pointMonney = bill.pointMoney ?? 0;
                  return Text(
                    CommonFn.parseMoney(bill.amount - pointMonney),
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "ເລກທີບິນຫວຍ: ${bill.billId}",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "ຊໍາລະໂດຍ: ${bill.bankName}",
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
