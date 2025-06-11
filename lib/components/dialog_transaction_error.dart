import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class DialogTransactionError extends StatelessWidget {
  final List<Map> transactionError;
  final Future<void> Function(List<Map> transactionCanSell) onConfirmBuy;
  final void Function() onConfirmNotBuy;
  const DialogTransactionError({
    super.key,
    required this.transactionError,
    required this.onConfirmBuy,
    required this.onConfirmNotBuy,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map> canSellGroup = [];
    final List<Map> cantSellGroup = transactionError.where((transaction) {
      if (transaction['type'] == 'quotaExceed' &&
          transaction['data']['quotaRemain'] == 0) {
        return true;
      }
      if (transaction['type'] == 'notSell') {
        return true;
      }
      canSellGroup.add(transaction);
      return false;
    }).toList();
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (cantSellGroup.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocale.lotteryCantSellTitle.getString(context),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: cantSellGroup.map((transaction) {
                  // if (transaction['type'] == "notSell") {
                  final lottery = transaction['data']['lottery'];
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocale.number.getString(context)} $lottery",
                      ),
                      const SizedBox(width: 8),
                      Text(
                        transaction['type'] == "notSell"
                            ? AppLocale.thisNumberNotSale.getString(context)
                            : AppLocale.thisNumberExceededQuota
                                .getString(context),
                        style: TextStyle(
                          color: Colors.red,
                          // fontSize: 16,
                        ),
                      ),
                    ],
                  );
                  // } else {
                  // final error = {
                  //   "status": false,
                  //   "data": {"lottery": "44", "quotaRemain": 2000},
                  //   "type": "quotaExceed",
                  //   "message": "ເກີນໂຄຕ້າ"
                  // };
                  // }
                  // return Text(transaction['type']);
                }).toList(),
              ),
              const SizedBox(height: 16),
              // TODO: create colum in build for can sell transaction
              // Builder(builder: builder)
              if (canSellGroup.isNotEmpty)
                Row(
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      AppLocale.stilldBePurchasedTitle.getString(context),
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: canSellGroup.map((transaction) {
                  final lottery = transaction['data']['lottery'];
                  final quotaRemain = transaction['data']['quotaRemain'];
                  final quotaRequest = transaction['data']['quotaRequest'];
                  final message = transaction['message'];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${AppLocale.number} $lottery",
                        // style: TextStyle(
                        //     // fontSize: 16,
                        //     ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Text("${AppLocale.order.getString(context)} "),
                          Text(
                            CommonFn.parseMoney(quotaRequest ?? 0),
                            style: TextStyle(
                              color: Colors.amber.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(" ${AppLocale.lak.getString(context)} | "),
                          Text("${AppLocale.youCanBut.getString(context)} "),
                          Text(
                            CommonFn.parseMoney(quotaRemain ?? 0),
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(" ${AppLocale.lak.getString(context)}"),
                        ],
                      ),
                      // Text(
                      //   "สั่งซื้อ 1,000,000 กีบ | ซื้อได้ $quotaRemain กีบ",
                      //   // "สามารถซื้อได้ $quotaRemain กีบ",
                      //   style: TextStyle(
                      //     // fontSize: 16,
                      //     color: Colors.amber.shade800,
                      //     // fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 16,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       "ท่านต้องการซื้อหรือไม่",
              //       style: TextStyle(
              //         fontSize: 16,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 8),
              Row(
                children: [
                  // Expanded(
                  //   child: LongButton(
                  //     borderSide: BorderSide(
                  //       width: 1,
                  //       color: AppColors.primary,
                  //     ),
                  //     backgroundColor: Colors.white,
                  //     onPressed: () {
                  //       // onConfirmBuy(cantSellGroup);
                  //       onConfirmNotBuy();
                  //     },
                  //     child: Text(
                  //       "ไม่ซื้อ",
                  //       style: TextStyle(
                  //         color: AppColors.primary,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 8),
                  Expanded(
                    child: LongButton(
                      onPressed: () {
                        onConfirmBuy(canSellGroup);
                      },
                      child: Text(
                        "ຮັບ​ຮູ້",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
