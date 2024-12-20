import 'package:lottery_ck/utils/common_fn.dart';

class History {
  late String date;
  late String time;
  String invoiceId;
  int amount;
  int totalAmount;
  List transactionIdList;
  List lotteryList = [];
  String createdAt;
  String? bankId;
  String status;
  String? billId;
  int? point;
  int? pointMoney;

  History({
    required this.createdAt,
    required this.invoiceId,
    required this.amount,
    required this.totalAmount,
    required this.transactionIdList,
    this.bankId,
    required this.status,
    this.billId,
    this.point,
    this.pointMoney,
  }) {
    date = CommonFn.parseDMY(DateTime.parse(createdAt).toLocal());
    time = CommonFn.parseHMS(DateTime.parse(createdAt).toLocal());
  }

  static History fromJson(Map json) {
    return History(
      createdAt: json['\$createdAt'],
      invoiceId: json["\$id"],
      amount: json["amount"],
      totalAmount: json["totalAmount"],
      transactionIdList: json["transactionId"],
      bankId: json['bankId'],
      status: json['status'],
      billId: json['billId'],
      point: json['point'],
      pointMoney: json['pointMoney'],
    );
  }

  static History get empty => History(
        createdAt: "2024-02-01T01:00:00+01:00",
        invoiceId: "i1234",
        totalAmount: 1000,
        transactionIdList: [],
        bankId: 'b1234',
        status: 'pending',
        amount: 0,
      );

  Map toJson() => {
        "createdAt": createdAt,
        "invoiceId": invoiceId,
        "totalAmount": totalAmount,
        "transactionIdList": transactionIdList,
        "bankId": bankId,
        "status": status,
        "billId": billId,
        "point": point,
        "pointMoney": pointMoney,
        "amount": amount,
      };
}
