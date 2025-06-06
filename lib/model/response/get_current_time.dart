class GetCurrentTime {
  DateTime dateTime;

  GetCurrentTime({
    required this.dateTime,
  });

  static GetCurrentTime fromJson(Map json) => GetCurrentTime(
        dateTime: DateTime.parse(json['dateTime']),
      );
}
