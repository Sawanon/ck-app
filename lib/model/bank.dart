import 'dart:convert';

class Bank {
  String $id;
  String name;
  String fullName;
  String? logo;
  String? downtime;
  // TODO: what is this - sawanon:20240813

  Bank({
    required this.$id,
    required this.name,
    required this.fullName,
    this.logo,
    this.downtime,
  });

  static Bank fromJson(Map json) => Bank(
        $id: json['\$id'],
        name: json['name'],
        logo: json['logo'],
        fullName: json['full_name'],
        downtime: json['downtime'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "logo": logo,
        "fullName": fullName,
        "downtime": downtime,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
