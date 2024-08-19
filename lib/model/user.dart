class UserApp {
  String firstName;
  String lastName;
  String phoneNumber;

  UserApp({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  String get fullName => "$firstName $lastName";
}
