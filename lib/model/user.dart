class UserApp {
  String firstName;
  String lastName;
  String phoneNumber;
  String? passcode;
  String? address;

  UserApp({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.passcode,
    this.address,
  });

  static UserApp fromJson(Map json) {
    return UserApp(
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      phoneNumber: json['phone'] as String,
      passcode: json['passcode'] as String?,
      address: json['address'] as String?,
    );
  }

  String get fullName => "$firstName $lastName";
}
