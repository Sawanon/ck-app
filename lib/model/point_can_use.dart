import 'dart:convert';

class PointCanUse {
  int percent;

  PointCanUse({
    required this.percent,
  });

  static PointCanUse fromJson(Map json) {
    int percent = 0;
    try {
      percent = int.parse(json['percent']);
    } catch (e) {
      percent = json['percent'];
    }
    return PointCanUse(
      percent: percent,
    );
  }

  Map toJson() => {
        "percent": percent,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
