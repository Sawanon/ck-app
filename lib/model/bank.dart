import 'dart:convert';

class Bank {
  String $id;
  bool status;
  String name;
  double transaction;
  double monthly;
  double winPrice;
  String? logo;
  // TODO: what is this - sawanon:20240813

  Bank({
    required this.$id,
    required this.status,
    required this.name,
    required this.transaction,
    required this.monthly,
    required this.winPrice,
    this.logo,
  });

  static Bank fromJson(Map json) => Bank(
        $id: json['\$id'],
        status: json['status'],
        name: json['name'],
        transaction: double.parse(json['transaction'].toString()),
        monthly: double.parse(json['monthly'].toString()),
        winPrice: double.parse(json['winPrice'].toString()),
        logo: json['logo'],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "name": name,
        "logo": logo,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
