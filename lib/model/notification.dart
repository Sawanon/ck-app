import 'dart:convert';

class NotificationModel {
  String id;
  String title;
  String body;
  String? link;
  bool isRead;
  DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.link,
    required this.isRead,
    required this.createdAt,
  });

  static NotificationModel fromJson(Map json) {
    final createdAt = DateTime.parse(json['createAt']);
    return NotificationModel(
      id: json['_id'],
      title: json['title'],
      body: json['body'],
      link: json['link'],
      isRead: json['isRead'],
      createdAt: createdAt,
    );
  }

  Map toJson() => {
        "_id": id,
        "title": title,
        "body": body,
        "link": link,
        "isRead": isRead,
        "createdAt": createdAt.toIso8601String(),
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
