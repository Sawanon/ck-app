import 'dart:convert';

import 'package:lottery_ck/utils.dart';

class NotificationDataModel {
  List<NotificationModel> data;
  int totalItems;
  int totalPages;
  int currentPage;
  int limit;

  NotificationDataModel({
    required this.data,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  static NotificationDataModel fromJson(Map json) {
    return NotificationDataModel(
      data: (json['data'] as List)
          .map((data) => NotificationModel.fromJson(data))
          .toList(),
      totalItems: json['totalItems'],
      totalPages: json['totalPages'],
      currentPage: json['currentPage'],
      limit: json['limit'],
    );
  }
}

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
    logger.w({
      "_id": json['_id'],
      "title": json['title'],
      "body": json['body'],
      "link": json['link'],
      "isRead": json['isRead'],
    });
    logger.w(json);
    final createdAt = DateTime.parse(json['createdAt']);
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
