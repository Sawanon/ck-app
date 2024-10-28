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
  int? discount;
  String? billId;
  String? expire;
  int price;
  int quota;

  InvoiceMetaData({
    required this.lotteryDateStr,
    required this.transactions,
    required this.customerId,
    required this.phone,
    this.invoiceId,
    required this.totalAmount,
    required this.amount,
    this.bonus,
    this.discount,
    this.billId,
    this.expire,
    required this.price,
    required this.quota,
  });

  static InvoiceMetaData empty() => InvoiceMetaData(
        amount: 0,
        customerId: '',
        phone: '',
        lotteryDateStr: '',
        totalAmount: 0,
        transactions: [],
        price: 0,
        quota: 0,
      );

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
        discount: discount,
        billId: billId,
        expire: expire,
        price: price,
        quota: quota,
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
      'discount': discount,
      'billId': billId,
      'quota': quota,
    };
  }
}
