// {
//      "firstname": "ດດ",
//      "lastname": "ດດ",
//      "phone": "+856111111111",
//      "profile": "user_images:67452e9800167883243a",
//      "ref_code": "173258716256975e80683",
//      "isAccept": true
//    }
import 'dart:convert';

class ListMyFriendsUser {
  String firstName;
  String lastName;
  String phone;
  String? profile;
  String refCode;
  bool isAccept;

  ListMyFriendsUser({
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.profile,
    required this.refCode,
    required this.isAccept,
  });

  static ListMyFriendsUser fromJson(Map json) => ListMyFriendsUser(
        firstName: json['firstname'],
        lastName: json['lastname'],
        phone: json['phone'],
        profile: json['profile'],
        refCode: json['ref_code'],
        isAccept: json['isAccept'],
      );

  Map toJson() => {
        "firstname": firstName,
        "lastname": lastName,
        "phone": phone,
        "profile": profile,
        "ref_code": refCode,
        "isAccept": isAccept,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
