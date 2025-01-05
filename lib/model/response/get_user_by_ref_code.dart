import 'dart:convert';

class ResponseGetUserByRefCode {
  String firstName;
  String lastName;
  String phone;
  String? profile;

  ResponseGetUserByRefCode({
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.profile,
  });

  static ResponseGetUserByRefCode fromJson(Map json) {
    return ResponseGetUserByRefCode(
      firstName: json['firstname'],
      lastName: json['lastname'],
      phone: json['phone'],
      profile: json['profile'],
    );
  }

  Map toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "profile": profile,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
