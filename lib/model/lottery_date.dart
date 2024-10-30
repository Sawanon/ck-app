class LotteryDate {
  late DateTime dateTime;
  late DateTime startTime;
  late DateTime endTime;
  bool active;
  bool isEmergency;
  bool isCal;
  bool isTransfer;

  LotteryDate({
    required DateTime dateTime,
    required DateTime startTime,
    required DateTime endTime,
    required this.active,
    required this.isEmergency,
    required this.isCal,
    required this.isTransfer,
  }) {
    this.dateTime = dateTime.toLocal();
    this.startTime = startTime.toLocal();
    this.endTime = endTime.toLocal();
  }

  static LotteryDate fromJson(Map json) => LotteryDate(
        dateTime: DateTime.parse(json['datetime']),
        startTime: DateTime.parse(json['start_time']),
        endTime: DateTime.parse(json['end_time']),
        active: json['active'],
        isEmergency: json['is_emergency'],
        isCal: json['is_cal'],
        isTransfer: json['is_transfer'],
      );

  Map toJson() => {
        "datetime": dateTime,
        "start_time": startTime,
        "end_time": endTime,
        "active": active,
        "is_emergency": isEmergency,
        "is_cal": isCal,
        "is_transfer": isTransfer,
      };

  @override
  String toString() {
    return dateTime.toString();
  }
}
