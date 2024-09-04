class UserApp {
  String firstName;
  String lastName;
  String phoneNumber;
  String? passcode;

  UserApp({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.passcode,
  });

  static UserApp fromJson(Map json) {
    return UserApp(
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      phoneNumber: json['phone'] as String,
      passcode: json['passcode'] as String?,
    );
  }

  String get fullName => "$firstName $lastName";
}
