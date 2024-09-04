import 'dart:convert';

class News {
  String $id;
  String name;
  DateTime? startDate;
  DateTime? endDate;
  String? link;
  String? detail;
  String? image;

  News({
    required this.$id,
    required this.name,
    required String startDate,
    required String endDate,
    this.link,
    this.detail,
    this.image,
  }) {
    this.startDate = DateTime.parse(startDate);
    this.endDate = DateTime.parse(endDate);
  }

  static News fromJson(Map<String, dynamic> json) {
    return News(
      $id: json["\$id"],
      name: json['name'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      link: json['link'],
      detail: json['detail'],
      image: json['image'],
    );
  }

  Map toJson() {
    return {
      'name': name,
      'start_date': startDate.toString(),
      'end_date': endDate.toString(),
      'link': link,
      'detail': detail,
      'image': image,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
