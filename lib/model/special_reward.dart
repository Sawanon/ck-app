import 'dart:convert';

class SpecialReward {
  String? digit1;
  String? digit2;
  String? digit3;
  String? digit4;
  String? digit5;
  String? digit6;

  SpecialReward({
    this.digit1,
    this.digit2,
    this.digit3,
    this.digit4,
    this.digit5,
    this.digit6,
  });

  static SpecialReward fromJson(Map json) {
    return SpecialReward(
      digit1: json['digit_1'],
      digit2: json['digit_2'],
      digit3: json['digit_3'],
      digit4: json['digit_4'],
      digit5: json['digit_5'],
      digit6: json['digit_6'],
    );
  }

  Map toJson() => {
        "digit_1": digit1,
        "digit_2": digit2,
        "digit_3": digit3,
        "digit_4": digit4,
        "digit_5": digit5,
        "digit_6": digit6,
      };

  bool isMatch(String lotteryNumber) {
    final l1 = lotteryNumber.length > 5 ? lotteryNumber.substring(5, 6) : null;
    final l2 = lotteryNumber.length > 4 ? lotteryNumber.substring(4, 5) : null;
    final l3 = lotteryNumber.length > 3 ? lotteryNumber.substring(3, 4) : null;
    final l4 = lotteryNumber.length > 2 ? lotteryNumber.substring(2, 3) : null;
    final l5 = lotteryNumber.length > 1 ? lotteryNumber.substring(1, 2) : null;
    final l6 = lotteryNumber.isNotEmpty ? lotteryNumber.substring(0, 1) : null;

    bool win = false;
    if (digit1 != null) {
      win = l1 == digit1;
    }
    if (digit2 != null) {
      win = l2 == digit2;
    }
    if (digit3 != null) {
      win = l3 == digit3;
    }
    if (digit4 != null) {
      win = l4 == digit4;
    }
    if (digit5 != null) {
      win = l5 == digit5;
    }
    if (digit6 != null) {
      win = l6 == digit6;
    }

    return win;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
