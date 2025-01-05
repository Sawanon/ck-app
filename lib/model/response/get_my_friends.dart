import 'dart:convert';

class GetMyFriends {
  int total;
  int accepted;
  GetMyFriends({
    required this.total,
    required this.accepted,
  });

  static GetMyFriends fromJson(Map json) => GetMyFriends(
        total: json['total'],
        accepted: json['accepted'],
      );

  Map toJson() => {
        "total": total,
        "accepted": accepted,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
