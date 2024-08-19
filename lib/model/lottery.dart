import 'package:lottery_ck/utils.dart';

class Lottery {
  String lottery;
  int price;

  Lottery({
    required this.lottery,
    required this.price,
  }) {
    if (lottery.isEmpty || lottery.length > 6) {
      throw "invalid lottery format";
    }
  }

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
      price: json['amount'],
    );
  }
}
