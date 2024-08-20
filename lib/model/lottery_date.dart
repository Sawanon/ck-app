class LotteryDate {
  late DateTime dateTime;
  late DateTime startTime;
  late DateTime endTime;

  LotteryDate({
    required DateTime dateTime,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    this.dateTime = dateTime.toLocal();
    this.startTime = startTime.toLocal();
    this.endTime = endTime.toLocal();
  }

  static LotteryDate fromJson(Map json) => LotteryDate(
        dateTime: DateTime.parse(json['datetime']),
        startTime: DateTime.parse(json['start_time']),
        endTime: DateTime.parse(json['end_time']),
      );

  @override
  String toString() {
    return dateTime.toString();
  }
}
