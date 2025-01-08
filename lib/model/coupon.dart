import 'dart:convert';

class Coupon {
  String couponId;
  // String userId; // userId not used
  String promotionId;
  bool? isUse;
  DateTime? useDate;
  DateTime? expireDate;
  Map? promotion;

  Coupon({
    required this.couponId,
    required this.promotionId,
    // required this.useId, // userId not used
    this.isUse,
    this.useDate,
    this.expireDate,
    this.promotion,
  });

  static Coupon fromJson(Map json) {
    final useDate =
        json['use_date'] != null ? DateTime.parse(json['use_date']) : null;
    final expireDate = json['expire_date'] != null
        ? DateTime.parse(json['expire_date'])
        : null;
    return Coupon(
      couponId: json['couponId'],
      promotionId: json['promotionId'],
      isUse: json['is_use'],
      useDate: useDate,
      expireDate: expireDate,
    );
  }

  Map toJson() => {
        "couponId": couponId,
        "promotionId": promotionId,
        "is_use": isUse,
        "use_date": useDate?.toIso8601String(),
        "expire_date": expireDate?.toIso8601String(),
        "promotion": promotion,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
