import 'package:lottery_ck/model/lottery.dart';

class InvoiceMetaData {
  String lotteryDateStr;
  List<Lottery> transactions;
  String customerId;
  String phone;
  String? invoiceId;
  int totalAmount;
  int amount;
  int? bonus;
  String? billId;

  InvoiceMetaData({
    required this.lotteryDateStr,
    required this.transactions,
    required this.customerId,
    required this.phone,
    this.invoiceId,
    required this.totalAmount,
    required this.amount,
    this.bonus,
    this.billId,
  });

  static InvoiceMetaData empty() => InvoiceMetaData(
      amount: 0,
      customerId: '',
      phone: '',
      lotteryDateStr: '',
      totalAmount: 0,
      transactions: []);

  InvoiceMetaData copyWith() => InvoiceMetaData(
        lotteryDateStr: lotteryDateStr,
        transactions:
            transactions.map((trasaction) => trasaction.copyWith()).toList(),
        customerId: customerId,
        phone: phone,
        invoiceId: invoiceId,
        totalAmount: totalAmount,
        amount: amount,
        bonus: bonus,
        billId: billId,
      );

  Map<String, dynamic> toJson(String userId) {
    return {
      'lotteryDateStr': lotteryDateStr,
      'transactions': transactions
          .map((lottery) => {...lottery.toJson(), 'userId': userId})
          .toList(),
      'customerId': customerId,
      'phone': phone,
      'invoiceId': invoiceId,
      'totalAmount': totalAmount,
      'amount': amount,
      'bonus': bonus,
      'billId': billId,
    };
  }
}

// {
//     "lotteryDateStr": "20241004",
//     "totalAmount": 9600,
//     "amount": 8000,
//     "bonus": 1600,
//     "customerId": "+856221606511",
//     "phone": "+8562054656226",
//     // "invoiceId": "66fb89d80009543b3c00",
//     "transactions": [
//         // {
//         //     //    "$id": "66fb89da000cb8af416f",
//         //     "lottery": "234",
//         //     "digit_1": null,
//         //     "digit_2": null,
//         //     "digit_3": null,
//         //     "digit_4": "2",
//         //     "digit_5": "3",
//         //     "digit_6": "4",
//         //     "lotteryType": 3,
//         //     "amount": 5000,
//         //     "bonus": 1000,
//         //     "totalAmount": 6000,
//         //     "userId": "66e9b066000956d5e74e"
//         // },
//         {
//             "$id": null,
//             "lottery": "235",
//             "digit_1": null,
//             "digit_2": null,
//             "digit_3": null,
//             "digit_4": "2",
//             "digit_5": "3",
//             "digit_6": "5",
//             "lotteryType": 3,
//             "amount": 3000,
//             "bonus": 600,
//             "totalAmount": 3600,
//             "userId": "66e9b066000956d5e74e"
//         }
//     ]
// }