class ResponseVerifyPasscode {
  bool pass;
  String message;
  RemainVerifyPasscode? data;

  ResponseVerifyPasscode({
    required this.pass,
    required this.message,
    this.data,
  });

  static ResponseVerifyPasscode fromJson(Map json) => ResponseVerifyPasscode(
        pass: json['pass'],
        message: json['message'],
        data: json['data'] == null
            ? null
            : RemainVerifyPasscode.fromJson(json['data']),
      );

  Map toMap() => {
        "pass": pass,
        "message": message,
        "data": data?.toMap(),
      };
}

//  "blockUntil": 1729671953021,
// "utilDate": "2024-10-23 15:25:53"
class RemainVerifyPasscode {
  int? remain;
  DateTime? blockUntil;

  RemainVerifyPasscode({
    this.remain,
    int? blockUntil,
  }) {
    if (blockUntil != null) {
      this.blockUntil = DateTime.fromMillisecondsSinceEpoch(blockUntil);
    }
  }

  static RemainVerifyPasscode fromJson(Map json) => RemainVerifyPasscode(
        remain: json['remain'],
        blockUntil: json['blockUntil'],
      );

  Map toMap() => {
        "remain": remain,
        'blockUntil': blockUntil,
      };
}
