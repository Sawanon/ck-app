import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/appwrite/controller/appwrite.controller.dart';

class FakeWallpaper extends StatefulWidget {
  const FakeWallpaper({super.key});

  @override
  State<FakeWallpaper> createState() => _FakeWallpaperState();
}

class _FakeWallpaperState extends State<FakeWallpaper> {
  bool isLoading = false;

  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  Future<void> showDownloadNotification(
      {required int progress, required String title}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel', // Channel ID
      'ดาวน์โหลดไฟล์', // Channel Name
      channelDescription: 'แสดงสถานะการดาวน์โหลดไฟล์',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: true,
      maxProgress: 100,
      ongoing: true, // ทำให้ notification ไม่ถูกลบ
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await FlutterLocalNotificationsPlugin().show(
      0, // Notification ID
      title, // หัวข้อ Notification
      'กำลังดาวน์โหลด... $progress%', // เนื้อหา
      platformChannelSpecifics,
      payload: 'download', // Payload หากต้องการส่งข้อมูลเพิ่มเติม
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl:
                    "https://baas-dev.moevedigital.com/v1/storage/buckets/66fa316200036c5ef9ee/files/67078bef002cfb1351c0/view?project=667afb24000fbd66b4df",
              ),
              LongButton(
                isLoading: isLoading,
                onPressed: () async {
                  setLoading(true);
                  // showDownloadNotification(progress: 50, title: '02.png');
                  // await AppWriteController.to.downLoadFile();
                  // await FlutterLocalNotificationsPlugin().cancel(0);
                  // await FlutterLocalNotificationsPlugin().show(
                  //   1,
                  //   'ดาวน์โหลดสำเร็จ',
                  //   'ไฟล์ถูกบันทึกที่: 02.png',
                  //   const NotificationDetails(
                  //     android: AndroidNotificationDetails(
                  //       'download_channel',
                  //       'ดาวน์โหลดไฟล์',
                  //       channelDescription: 'แสดงสถานะการดาวน์โหลดไฟล์',
                  //     ),
                  //   ),
                  // );
                  // final test = Uint8List(2);
                  // await AppWriteController.to.saveFiles(test, '');
                  setLoading(false);
                },
                child: Text(
                  "Download",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
