import 'package:lottery_ck/model/lottery.dart';
import 'package:lottery_ck/utils.dart';

class ResponseInvoiceAddTransaction {
  MapInvoice invoice;
  Map<String, ResponseTransactionAddTransaction> transaction;

  ResponseInvoiceAddTransaction({
    required this.invoice,
    required this.transaction,
  });

  static ResponseInvoiceAddTransaction fromJson(Map json) {
    return ResponseInvoiceAddTransaction(
      invoice: MapInvoice.fromJson(json['invoice']),
      transaction:
          (json['transaction'] as Map<String, dynamic>).map((key, value) {
        return MapEntry(key, ResponseTransactionAddTransaction.fromJson(value));
      }),
    );
  }
}

class MapInvoice {
  String? status;
  int totalAmount;
  int? bonus;
  String userId;
  String billId;
  List transactionId;
  String $id;

  MapInvoice({
    this.status,
    required this.totalAmount,
    required this.userId,
    required this.billId,
    required this.transactionId,
    required this.$id,
    this.bonus,
  });

  static MapInvoice fromJson(Map json) {
    return MapInvoice(
      status: json['status'],
      totalAmount: json['totalAmount'],
      bonus: json['bonus'],
      userId: json['userId'],
      billId: json['billId'],
      transactionId: json['transactionId'],
      $id: json['\$id'],
    );
  }
}

class ResponseTransactionAddTransaction {
  bool status;
  String message;
  MapTransaction data;

  ResponseTransactionAddTransaction({
    required this.status,
    required this.message,
    required this.data,
  });

  static ResponseTransactionAddTransaction fromJson(Map json) {
    return ResponseTransactionAddTransaction(
      status: json['status'],
      message: json['message'],
      data: MapTransaction.fromJson(json['data']),
    );
  }
}

class MapTransaction {
  String? $id;
  String lottery;
  int? lotteryType;
  String? digit_1;
  String? digit_2;
  String? digit_3;
  String? digit_4;
  String? digit_5;
  String? digit_6;
  int? amount;
  int? bonus;
  int? quotaRemain;

  MapTransaction({
    this.$id,
    required this.lottery,
    this.lotteryType,
    this.digit_1,
    this.digit_2,
    this.digit_3,
    this.digit_4,
    this.digit_5,
    this.digit_6,
    this.amount,
    this.bonus,
    this.quotaRemain,
  });

  static MapTransaction fromJson(Map<String, dynamic> json) {
    return MapTransaction(
      lottery: json['lottery'],
      lotteryType: json['lotteryType'],
      $id: json['\$id'],
      digit_1: json['digit_1'],
      digit_2: json['digit_2'],
      digit_3: json['digit_3'],
      digit_4: json['digit_4'],
      digit_5: json['digit_5'],
      digit_6: json['digit_6'],
      amount: json['amount'],
      bonus: json['bonus'],
      quotaRemain: json['quotaRemain'],
    );
  }
}
