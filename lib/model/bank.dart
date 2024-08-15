import 'dart:convert';

class Bank {
  String $id;
  String name;
  String? logo;
  // TODO: what is this - sawanon:20240813

  Bank({
    required this.$id,
    required this.name,
    this.logo,
  });

  static Bank fromJson(Map json) => Bank(
        $id: json['\$id'],
        name: json['name'],
        logo: json['logo'],
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
