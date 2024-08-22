import 'package:lottery_ck/utils/common_fn.dart';

class History {
  late String date;
  late String time;
  String invoiceId;
  int totalAmount;
  List transactionIdList;
  List lotteryList = [];
  String createdAt;
  String bankId;

  History({
    required this.createdAt,
    required this.invoiceId,
    required this.totalAmount,
    required this.transactionIdList,
    required this.bankId,
  }) {
    date = CommonFn.parseDMY(DateTime.parse(createdAt).toLocal());
    time = CommonFn.parseHMS(DateTime.parse(createdAt).toLocal());
  }

  static History fromJson(Map json) {
    return History(
      createdAt: json['\$createdAt'],
      invoiceId: json["\$id"],
      totalAmount: json["totalAmount"],
      transactionIdList: json["transactionId"],
      bankId: json['bankId'],
    );
  }

  static History get empty => History(
        createdAt: "2024-02-01T01:00:00+01:00",
        invoiceId: "i1234",
        totalAmount: 1000,
        transactionIdList: [],
        bankId: 'b1234',
      );
}