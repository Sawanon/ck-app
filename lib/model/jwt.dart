class AppJWT {
  String jwt;
  DateTime expire;

  AppJWT({
    required this.jwt,
    required this.expire,
  });

  static AppJWT fromJSON(Map json) {
    return AppJWT(
      jwt: json['jwt'],
      expire: DateTime.parse(json['expire']),
    );
  }

  Map toMap() {
    return {
      "jwt": jwt,
      "expire": expire,
    };
  }
}
