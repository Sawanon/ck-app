enum BonusType { fix, percentage }

enum DiscountType { fix, percentage }

class Lottery {
  String lottery;
  int amount;
  int lotteryType;
  String? id;
  int? bonus;
  BonusType? bonusType;
  int? discount;
  DiscountType? discountType;
  int? totalAmount;
  int quota;

  Lottery({
    required this.lottery,
    required this.amount,
    required this.lotteryType,
    this.id,
    this.bonus,
    this.totalAmount,
    required this.quota,
    this.bonusType,
    this.discount,
    this.discountType,
  }) {
    if (lottery.isEmpty || lottery.length > 6) {
      throw "invalid lottery format";
    }
  }

  int get price => quota;

  Lottery copyWith() => Lottery(
        lottery: lottery,
        amount: amount,
        lotteryType: lotteryType,
        id: id,
        bonus: bonus,
        totalAmount: totalAmount,
        quota: quota,
        bonusType: bonusType,
        discount: discount,
        discountType: discountType,
      );

  int get type => lottery.length;

  Map<String, String?> toDigit() {
    Map<String, String?> digitMap = {
      "digit_1": null,
      "digit_2": null,
      "digit_3": null,
      "digit_4": null,
      "digit_5": null,
      "digit_6": null,
    };

    for (var i = 1; i <= type; i++) {
      int digit = 6 - type + i;
      digitMap.update("digit_$digit", (value) => lottery[i - 1]);
    }
    return digitMap;
  }

  static Lottery fromJson(Map json) {
    return Lottery(
      lottery: json['lottery'],
      amount: json['amount'],
      lotteryType: json['lotteryType'],
      id: json['\$id'],
      bonus: json['bonus'],
      totalAmount: json['totalAmount'],
      quota: json['quota'],
      bonusType: json['bonusType'],
      discount: json['discount'],
      discountType: json['discountType'],
    );
  }

  Map<String, dynamic> toJson() => {
        "\$id": id,
        "lottery": lottery,
        ...toDigit(),
        "lotteryType": type,
        "amount": amount,
        "bonus": bonus,
        "totalAmount": totalAmount,
        "quota": quota,
        "discount": discount,
      };

  void remove() {
    quota = 0;
    amount = 0;
  }
}
