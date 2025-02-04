import 'package:lottery_ck/model/invoice_meta.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class History {
  late String date;
  late String time;
  String invoiceId;
  int amount;
  int quota;
  int totalAmount;
  List transactionIdList;
  List lotteryList = [];
  String createdAt;
  String? bankId;
  String status;
  String? billId;
  String? billNumber;
  int? point;
  int? pointMoney;
  int? discount;

  History({
    required this.createdAt,
    required this.invoiceId,
    required this.amount,
    required this.quota,
    required this.totalAmount,
    required this.transactionIdList,
    this.bankId,
    required this.status,
    this.billId,
    this.billNumber,
    this.point,
    this.pointMoney,
    this.discount,
  }) {
    date = CommonFn.parseDMY(DateTime.parse(createdAt).toLocal());
    time = CommonFn.parseHMS(DateTime.parse(createdAt).toLocal());
  }

  static History fromJson(Map json) {
    return History(
      createdAt: json['\$createdAt'],
      invoiceId: json["\$id"],
      amount: json["amount"],
      quota: json["quota"],
      totalAmount: json["totalAmount"],
      transactionIdList: json["transactionId"],
      bankId: json['bankId'],
      status: json['status'],
      billId: json['billId'],
      billNumber: json['billNumber'],
      point: json['point'],
      pointMoney: json['pointMoney'],
      discount: json['discount'],
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
        quota: 0,
      );

  Map toJson() => {
        "createdAt": createdAt,
        "invoiceId": invoiceId,
        "totalAmount": totalAmount,
        "transactionIdList": transactionIdList,
        "bankId": bankId,
        "status": status,
        "billId": billId,
        "billNumber": billNumber,
        "point": point,
        "pointMoney": pointMoney,
        "amount": amount,
        "discount": discount,
        "quota": quota,
      };
}
