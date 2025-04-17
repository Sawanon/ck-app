import 'dart:convert';

import 'package:lottery_ck/model/lottery.dart';

class CouponResponse {
  String couponId;
  String reason;
  bool status;
  CouponResponse({
    required this.couponId,
    required this.reason,
    required this.status,
  });

  static CouponResponse fromJson(Map json) => CouponResponse(
        couponId: json['couponId'],
        reason: json['message'],
        status: json['success'],
      );

  Map toJson() => {
        "couponId": couponId,
        "message": reason,
        "success": status,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

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
  List? couponIds;
  int? receivePoint;
  CouponResponse? couponResponse;
  int? point;
  int? pointMoney;
  List? promotionIds;
  int? pointBank;

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
    this.couponIds,
    this.receivePoint,
    this.couponResponse,
    this.point,
    this.pointMoney,
    this.promotionIds,
    this.pointBank,
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
        invoiceId: null,
        point: 0,
        pointMoney: 0,
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
        couponIds: couponIds,
        receivePoint: receivePoint,
        couponResponse: couponResponse,
        point: point,
        pointMoney: pointMoney,
        promotionIds: promotionIds,
        pointBank: pointBank,
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
      'couponId': couponIds,
      'receive_point': receivePoint,
      'point': point,
      'pointMoney': pointMoney,
      'promotionId': promotionIds,
      'pointBank': pointBank,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson("fake"));
  }
}
