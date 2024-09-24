class Promotion {
  String name;
  DateTime startDate;
  DateTime endDate;
  Condition condition;
  PromotionType type;

  Promotion({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.condition,
    required this.type,
  });
}

class Condition {
  String bonus;

  Condition({required this.bonus});
}

enum PromotionType { fixed, percent }
