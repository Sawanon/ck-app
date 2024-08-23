import 'dart:convert';

class Bank {
  String $id;
  String name;
  String fullName;
  String? logo;
  // TODO: what is this - sawanon:20240813

  Bank({
    required this.$id,
    required this.name,
    required this.fullName,
    this.logo,
  });

  static Bank fromJson(Map json) => Bank(
        $id: json['\$id'],
        name: json['name'],
        logo: json['logo'],
        fullName: json['full_name'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "logo": logo,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
