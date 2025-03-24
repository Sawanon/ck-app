import 'package:flutter/material.dart';

class DialogTransactionError extends StatelessWidget {
  final List<Map> transactionError;
  const DialogTransactionError({
    super.key,
    required this.transactionError,
  });

  @override
  Widget build(BuildContext context) {
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
              const Row(
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "เลขบางตัวมีปัญหา",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: transactionError.map((transaction) {
                  if (transaction['type'] == "notSell") {
                    final lottery = transaction['data']['lottery'];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "เลข $lottery",
                        ),
                        Text(
                          "- เลขนี้ไม่เปิดขาย",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    );
                  } else {
                    // final error = {
                    //   "status": false,
                    //   "data": {"lottery": "44", "quotaRemain": 2000},
                    //   "type": "quotaExceed",
                    //   "message": "ເກີນໂຄຕ້າ"
                    // };
                    final lottery = transaction['data']['lottery'];
                    final quotaRemain = transaction['data']['quotaRemain'];
                    final message = transaction['message'];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "เลข $lottery",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "- $message เหลือโควต้าอยู่ $quotaRemain",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.amber.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  }
                  return Text(transaction['type']);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
