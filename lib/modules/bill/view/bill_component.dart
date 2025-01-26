import 'package:barcode/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
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
                fontSize: 13,
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
                        "${AppLocale.date.getString(context)} ",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        CommonFn.parseDMY(bill.dateTime.toLocal()),
                        style: const TextStyle(
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
                        style: const TextStyle(
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
                        "${AppLocale.time.getString(context)} ",
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      Text(
                        CommonFn.parseHMS(bill.dateTime.toLocal()),
                        style: const TextStyle(
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
                "${AppLocale.lotteryDate.getString(context)}: ${bill.lotteryDateStr}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${AppLocale.dateOfIssue.getString(context)} ${CommonFn.parseCollectionToDate(bill.lotteryDateStr)}",
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
                  AppLocale.billPurchaseNumber.getString(context),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  AppLocale.amount.getString(context),
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
                      Text(
                        "${CommonFn.parseMoney(lottery.quota)} ${AppLocale.lak.getString(context)}",
                      ),
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
                Text(AppLocale.pointDiscount.getString(context)),
                Text("-${bill.pointMoney?.toString() ?? '-'}"),
              ],
            ),
          ],
          const SizedBox(height: 8),
          if (bill.lotteryList.fold(0,
                  (prev, transaction) => prev + (transaction.discount ?? 0)) !=
              0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocale.discount.getString(context)),
                Text(
                    "${CommonFn.parseMoney(bill.lotteryList.fold(0, (prev, transaction) => prev + (transaction.discount ?? 0)))} ${AppLocale.lak.getString(context)}"),
              ],
            ),
            const SizedBox(height: 8),
          ],
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
                Text(AppLocale.totalAmount.getString(context)),
                Builder(builder: (context) {
                  final pointMonney = bill.pointMoney ?? 0;
                  return Text(
                    "${CommonFn.parseMoney(bill.amount - pointMonney)} ${AppLocale.lak.getString(context)}",
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
            "${AppLocale.billId.getString(context)}: ${bill.billId}",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${AppLocale.paidBy.getString(context)}: ${bill.bankName}",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${AppLocale.contact.getString(context)} CK GROUP: 0865446524",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Builder(
            builder: (context) {
              return SvgPicture.string(
                CommonFn.generateBarcodeImage(
                  Barcode.code128(),
                  bill.billId,
                  MediaQuery.of(context).size.width,
                  100,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
