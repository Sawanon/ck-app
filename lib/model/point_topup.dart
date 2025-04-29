import 'dart:convert';

class PointTopup {
  String? status;
  double? point;
  double? pointMoney;
  String? payBy;
  String? userId;
  DateTime? paidAt;

  PointTopup({
    this.status,
    this.point,
    this.pointMoney,
    this.payBy,
    this.userId,
    this.paidAt,
  });

  static fromJson(Map json) {
    return PointTopup(
      status: json['status'],
      point: json['point'] is num ? (json['point'] as num).toDouble() : 0,
      pointMoney: json['pointMoney'] is num
          ? (json['pointMoney'] as num).toDouble()
          : 0,
      payBy: json['payBy'],
      userId: json['userId'],
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
    );
  }

  Map toJson() => {
        "status": status,
        "point": point,
        "pointMoney": pointMoney,
        "payBy": payBy,
        "userId": userId,
        "paidAt": paidAt?.toString(),
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
