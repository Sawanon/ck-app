import 'dart:convert';

class Bank {
  String $id;
  String name;
  String fullName;
  String? logo;
  String? downtime;
  String? detail;

  Bank({
    required this.$id,
    required this.name,
    required this.fullName,
    this.logo,
    this.downtime,
    this.detail,
  });

  static Bank fromJson(Map json) => Bank(
        $id: json['\$id'],
        name: json['name'],
        logo: json['logo'],
        fullName: json['full_name'],
        downtime: json['downtime'],
        detail: json['detail'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "logo": logo,
        "fullName": fullName,
        "downtime": downtime,
        "detail": detail,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
