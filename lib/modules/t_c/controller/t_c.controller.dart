import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/utils.dart';

class TCController extends GetxController {
  final tc = [
    {
      "point": 1,
      "title": "การใช้บริการ",
      "text":
          "การใช้บริการเว็บไซต์หรือแอปพลิเคชันนี้ต้องปฏิบัติตามข้อกำหนดและเงื่อนไขที่กำหนดโดยเจ้าของเว็บไซต์หรือแอปพลิเคชันนี้",
    },
    {
      "point": 2,
      "title": "ลิขสิทธิ์",
      "text":
          "การใช้เนื้อหาในเว็บไซต์หรือแอปพลิเคชันนี้ต้องเป็นไปตามลิขสิทธิ์ที่เป็นที่ตั้งไว้ ไม่อนุญาตให้ทำสำเนา, ดัดแปลง, หรือกระทำการใดๆ ที่ละเมิดลิขสิทธิ์",
    },
    {
      "point": 3,
      "title": "ความรับผิดชอบ",
      "text":
          "เจ้าของเว็บไซต์หรือแอปพลิเคชันไม่รับผิดชอบในความเสียหายที่อาจเกิดขึ้นจากการใช้บริการ",
    },
    {
      "point": 4,
      "title": "ข้อมูลส่วนบุคคล",
      "text":
          "การเก็บรวบรวมและใช้ข้อมูลส่วนบุคคลจะเป็นไปตามนโยบายความเป็นส่วนตัวที่ระบุไว้ ผู้ใช้ต้องให้ความยินยอมในการเก็บรวบรวมและใช้ข้อมูลดังกล่าว",
    },
    {
      "point": 5,
      "title": "การยกเลิกและการคืนเงิน",
      "text":
          "อาจมีเงื่อนไขการยกเลิกบริการหรือการคืนเงินที่ต้องปฏิบัติตามเมื่อผู้ใช้ต้องการยกเลิกบริการหรือขอคืนเงิน",
    },
    {
      "point": 6,
      "title": "ข้อกำหนดการใช้คุกกี้",
      "text":
          "เว็บไซต์หรือแอปพลิเคชันอาจใช้คุกกี้เพื่อเก็บข้อมูลเกี่ยวกับผู้ใช้",
    },
  ];
  bool isLoading = false;

  void listKYC() async {
    logger.d("listKYC");
  }

  void onAccept() async {
    try {
      final onAccept = Get.arguments['onAccept'];
      if (onAccept is Function) {
        isLoading = true;
        update();
        await onAccept();
      }
    } catch (e) {
      logger.e("$e");
      Get.dialog(
        DialogApp(
          title: const Text("Something went wrong"),
          details: Text("$e"),
        ),
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  @override
  void onInit() {
    listKYC();
    super.onInit();
  }
}
