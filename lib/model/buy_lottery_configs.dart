class BuyLotteryConfigs {
  int lotteryType;
  int? min;
  int? max;

  BuyLotteryConfigs({
    required this.lotteryType,
    this.min,
    this.max,
  });

  static fromJson(Map json) {
    return BuyLotteryConfigs(
      lotteryType: json['lotteryType'] as int,
      min: json['min'] as int?,
      max: json['max'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lotteryType': lotteryType,
      'min': min,
      'max': max,
    };
  }

  @override
  String toString() {
    return 'BuyLotteryConfigs{lotteryType: $lotteryType, min: $min, max: $max}';
  }
}
