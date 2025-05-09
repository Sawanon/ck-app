import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/utils.dart';

class TCController extends GetxController {
  final String title =
      "ຫວຍຊີເຄ ແມ່ນຜະລິດຕະພັນຂອງ ກຸ່ມບໍລິສັດ ຊີເຄ ການຄ້າ ຂາອອກ-ຂາເຂົ້າ ຈໍາກັດຜູ້ດຽວ ຊຶ່ງເປັນແອັບ ພລີເຄຊັນ ທີ່ອໍານວຍຄວາມສະດວກຫຼາຍດ້ານໃຫ້ແກ່ການບໍລິການລູກຄ້າ ເພື່ອນໍາໃຊ້ບໍລິການສ່ຽງໂຊກຊິງລາງວັນ     (ຊື້ຫວຍ) ນໍາໃຊ້ບໍລິການກູ້ຢືມເງິນ ແລະ ເຮັດທຸລະກໍາທາງດ້ານການເງິນຜ່ານລະບົບສະຖາບັນການເງິນ ແລະ ໃຫ້ການບໍລິການອື່ນໆ ທີ່ມີຄວາມຫຼາກຫຼາຍ ແລະ ພ້ອມທັງຮັບຂໍ້ມູນຂ່າວສານກ່ຽວກັບ ກຸ່ມບໍລິສັດ ຊີເຄ ການຄ້າ ຂາອອກ-ຂາເຂົ້າ ຈໍາກັດຜູ້ດຽວ.";
  final Map<String, List> tc = {
    "th": [
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
    ],
    "en": [
      {
        "point": 1,
        "title": "Use of services",
        "text":
            "Use of this website or application must comply with the terms and conditions set by the owner of this website or application.",
      },
      {
        "point": 2,
        "title": "Copyright",
        "text":
            "The use of the content on this website or application must comply with the copyright. Copying, modifying, or doing anything that infringes on copyright is not allowed.",
      },
      {
        "point": 3,
        "title": "Responsibility",
        "text":
            "The owner of the website or application is not responsible for any damages that may occur from using the service.",
      },
      {
        "point": 4,
        "title": "Personal information",
        "text":
            "Collection and use of personal data is subject to the Privacy Policy stated herein. Users must consent to the collection and use of such data.",
      },
      {
        "point": 5,
        "title": "Cancellation and Refund",
        "text":
            "There may be cancellation or refund terms and conditions that must be followed when a user wishes to cancel a service or request a refund.",
      },
      {
        "point": 6,
        "title": "Cookie Terms",
        "text":
            "Websites or applications may use cookies to store information about users.",
      },
    ],
    "lo": [
      // {
      //   "point": 0,
      //   "title": "",
      //   "text":
      //       "",
      // },
      {
        "point": 1,
        "title": "ການນໍາໃຊ້ການບໍລິການ",
        "text":
            "ການນໍາໃຊ້ເວັບໄຊທ໌ຫຼືຄໍາຮ້ອງສະຫມັກນີ້ຕ້ອງປະຕິບັດຕາມຂໍ້ກໍານົດແລະເງື່ອນໄຂທີ່ເຈົ້າຂອງເວັບໄຊທ໌ຫຼືຄໍາຮ້ອງສະຫມັກນີ້ກໍານົດ",
      },
      {
        "point": 2,
        "title": "ລິຂະສິດ",
        "text":
            "ການນໍາໃຊ້ເນື້ອຫາຢູ່ໃນເວັບໄຊທ໌ນີ້ຫຼືຄໍາຮ້ອງສະຫມັກຕ້ອງປະຕິບັດຕາມລິຂະສິດທີ່ກ່ຽວຂ້ອງ. ບໍ່ອະນຸຍາດໃຫ້ເຮັດສຳເນົາ, ດັດແກ້ ຫຼືເຮັດຫຍັງ. ທີ່ລະເມີດລິຂະສິດ",
      },
      {
        "point": 3,
        "title": "ຄວາມຮັບຜິດຊອບ",
        "text":
            "ເຈົ້າຂອງເວັບໄຊທ໌ຫຼືແອັບພລິເຄຊັນບໍ່ຮັບຜິດຊອບຕໍ່ຄວາມເສຍຫາຍໃດໆທີ່ອາດຈະເກີດຂື້ນຈາກການບໍລິການ",
      },
      {
        "point": 4,
        "title": "ຂໍ້ມູນສ່ວນຕົວ",
        "text":
            "ການເກັບກຳ ແລະນຳໃຊ້ຂໍ້ມູນສ່ວນຕົວຈະສອດຄ່ອງກັບນະໂຍບາຍຄວາມເປັນສ່ວນຕົວທີ່ລະບຸໄວ້. ຜູ້ໃຊ້ຕ້ອງຍິນຍອມທີ່ຈະເກັບກໍາແລະນໍາໃຊ້ຂໍ້ມູນດັ່ງກ່າວ.",
      },
      {
        "point": 5,
        "title": "ການຍົກເລີກແລະການຄືນເງິນ",
        "text":
            "ອາດມີການຍົກເລີກການບໍລິການ ຫຼືເງື່ອນໄຂການຄືນເງິນທີ່ຈະຕ້ອງປະຕິບັດຕາມເມື່ອຜູ້ໃຊ້ຕ້ອງການຍົກເລີກການບໍລິການ ຫຼືຮ້ອງຂໍເງິນຄືນ.",
      },
      {
        "point": 6,
        "title": "ເງື່ອນໄຂຄຸກກີ",
        "text":
            "ເວັບໄຊທ໌ຫຼືແອັບພລິເຄຊັນອາດຈະໃຊ້ cookies ເພື່ອເກັບກໍາຂໍ້ມູນກ່ຽວກັບຜູ້ໃຊ້.",
      },
    ],
  };
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
