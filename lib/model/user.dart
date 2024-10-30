class UserApp {
  String firstName;
  String lastName;
  String phoneNumber;
  String? passcode;
  String? address;
  String? customerId;
  String userId;
  DateTime birthDate;
  String? birthTime;
  int? topupPoint;
  int point;
  String? profile;
  String? gender;
  String? idCard;
  bool? isKYC;

  UserApp({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.passcode,
    this.address,
    this.customerId,
    required this.userId,
    required this.birthDate,
    this.birthTime,
    this.topupPoint,
    required this.point,
    this.profile,
    this.gender,
    this.idCard,
    this.isKYC,
  });

  static UserApp fromJson(Map json) {
    return UserApp(
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      phoneNumber: json['phone'] as String,
      passcode: json['passcode'] as String?,
      address: json['address'] as String?,
      customerId: json['customerId'] as String?,
      userId: json['userId'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      birthTime: json['birthTime'] as String?,
      topupPoint: json['topup_point'] as int?,
      point: json['point'] as int,
      profile: json['profile'] as String?,
      gender: json['gender'] as String?,
      idCard: json['idCard'] as String?,
      isKYC: json['isKYC'] as bool?,
    );
  }

  String get fullName => "$firstName $lastName";
}
