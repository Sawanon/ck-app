import 'package:lottery_ck/utils/common_fn.dart';

class UserPoint {
  DateTime createdDate;
  String type;
  int point;
  String? value;

  UserPoint({
    required this.createdDate,
    required this.type,
    required this.point,
    required this.value,
  });

  static UserPoint fromJson(Map json) {
    return UserPoint(
      createdDate: DateTime.parse(json['\$createdAt']),
      type: json['type'],
      point: json['point'] ?? 0,
      value: json['value'],
    );
  }

  String get createdDateStr => CommonFn.parseDMY(createdDate);

  @override
  String toString() {
    return "${{
      "createdDate": createdDate,
      "type": type,
      "point": point,
      "value": value,
    }}";
  }
}
