import 'dart:convert';

class FindInfluencer {
  String firstName;
  String lastName;
  String? profile;
  String refCode;

  FindInfluencer({
    required this.firstName,
    required this.lastName,
    this.profile,
    required this.refCode,
  });

  static FindInfluencer fromJson(Map json) => FindInfluencer(
        firstName: json['firstname'],
        lastName: json['lastname'],
        profile: json['profile'],
        refCode: json['ref_code'],
      );

  Map toJson() => {
        "firstname": firstName,
        "lastname": lastName,
        "profile": profile,
        "ref_code": refCode,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
