import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/main.dart';
import 'package:lottery_ck/modules/animal/view/dialog_animal.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/utils.dart';
import 'package:pinput/pinput.dart';

class AnimalComponent extends StatefulWidget {
  final EdgeInsets? padding;
  final Future<void> Function(List<Map<String, dynamic>> lotterise)? onClickBuy;
  final bool? disableBuy;
  final void Function()? onBack;
  const AnimalComponent({
    super.key,
    this.onClickBuy,
    this.disableBuy,
    this.onBack,
    this.padding,
  });

  @override
  State<AnimalComponent> createState() => _AnimalComponentState();
}

class _AnimalComponentState extends State<AnimalComponent> {
  final animalDatas = [
    {
      "name": "ปลาน้อย",
      "th": "ปลาน้อย",
      "lo": "ປານ້ອຍ",
      "en": "Little Fish",
      "key": "smallFish",
      "image": "fish.png",
      "lotteries": ["01", "41", "81"],
    },
    {
      "name": "หอยทาก",
      "th": "หอยทาก",
      "lo": "ຫອຍທາກ",
      "en": "Snail",
      "image": "shell.png",
      "lotteries": ["02", "42", "82"],
    },
    {
      "name": "ห่าน",
      "th": "ห่าน",
      "lo": "ຂວານ",
      "en": "Goose",
      "image": "goose.png",
      "lotteries": ["03", "43", "83"],
    },
    {
      "name": "นกยูง",
      "th": "นกยูง",
      "lo": "ນົກຢູງ",
      "en": "Peacock",
      "image": "peacock.png",
      "lotteries": ["04", "44", "84"],
    },
    {
      "name": "สิงโต",
      "th": "สิงโต",
      "lo": "ສິງໂຕ",
      "en": "Lion",
      "image": "lion.png",
      "lotteries": ["05", "45", "85"],
    },
    {
      "name": "เสือ",
      "th": "เสือ",
      "lo": "ເສືອ",
      "en": "Tiger",
      "image": "tiger.png",
      "lotteries": ["06", "46", "86"],
    },
    {
      "name": "หมู",
      "th": "หมู",
      "lo": "ໝູ",
      "en": "Pig",
      "image": "pig.png",
      "lotteries": ["07", "47", "87"],
    },
    {
      "name": "กระต่าย",
      "th": "กระต่าย",
      "lo": "ກະຕ່າຍ",
      "en": "Rabbit",
      "image": "rabbit.png",
      "lotteries": ["08", "48", "88"],
    },
    {
      "name": "ควาย",
      "th": "ควาย",
      "lo": "ຄວາຍ",
      "en": "Buffalo",
      "image": "buffalo.png",
      "lotteries": ["09", "49", "89"],
    },
    {
      "name": "นาก",
      "th": "นาก",
      "lo": "ນາກ",
      "en": "Otter",
      "image": "otter.png",
      "lotteries": ["10", "50", "90"],
    },
    {
      "name": "หมา",
      "th": "หมา",
      "lo": "ໝາ",
      "en": "Dog",
      "image": "dog.png",
      "lotteries": ["11", "51", "91"],
    },
    {
      "name": "ม้า",
      "th": "ม้า",
      "lo": "ມ້າ",
      "en": "Horse",
      "image": "horse.png",
      "lotteries": ["12", "52", "92"],
    },
    {
      "name": "ช้าง",
      "th": "ช้าง",
      "lo": "ຊ້າງ",
      "en": "Elephant",
      "image": "elephant.png",
      "lotteries": ["13", "53", "93"],
    },
    {
      "name": "แมวบ้าน",
      "th": "แมวบ้าน",
      "lo": "ແມວບ້ານ",
      "en": "Domestic Cat",
      "image": "cat.png",
      "lotteries": ["14", "54", "94"],
    },
    {
      "name": "หนู",
      "th": "หนู",
      "lo": "ໜູ",
      "en": "Rat",
      "image": "rat.png",
      "lotteries": ["15", "55", "95"],
    },
    {
      "name": "ผึ้ง",
      "th": "ผึ้ง",
      "lo": "ເຜິ້ງ",
      "en": "Bee",
      "image": "bee.png",
      "lotteries": ["16", "56", "96"],
    },
    {
      "name": "นกกระยาง",
      "th": "นกกระยาง",
      "lo": "ນົກກະຍາງ",
      "en": "Egret",
      "image": "egret.png",
      "lotteries": ["17", "57", "97"],
    },
    {
      "name": "แมวป่า",
      "th": "แมวป่า",
      "lo": "ແມວປ່າ",
      "en": "Wild Cat",
      "image": "catforest.png",
      "lotteries": ["18", "58", "98"],
    },
    {
      "name": "ผีเสื้อ",
      "th": "ผีเสื้อ",
      "lo": "ຜີເສື້ອ",
      "en": "Butterfly",
      "image": "butterfly.png",
      "lotteries": ["19", "59", "99"],
    },
    {
      "name": "ตะขาบ",
      "th": "ตะขาบ",
      "lo": "ຕະຂາບ",
      "en": "Centipede",
      "image": "centipede.png",
      "lotteries": ["00", "20", "60"],
    },
    {
      "name": "นกนางแอ่น",
      "th": "นกนางแอ่น",
      "lo": "ນົກນາງແອ່ນ",
      "en": "Swallow",
      "image": "swallow2.png",
      "lotteries": ["21", "61"],
    },
    {
      "name": "นกแกนแก",
      "th": "นกแกนแก",
      "lo": "ນົກແກ້ນແກ",
      "en": "Pigeon",
      "image": "pigeon.png",
      // "lotteries": ["92", "51", "21"],
      "lotteries": ["22", "62"],
    },
    {
      "name": "ลิง",
      "th": "ลิง",
      "lo": "ລິງ",
      "en": "Monkey",
      "image": "monkey.png",
      "lotteries": ["23", "63"],
    },
    {
      "name": "กบ",
      "th": "กบ",
      "lo": "ກົບ",
      "en": "Frog",
      "image": "fog.png",
      "lotteries": ["24", "64"],
    },
    {
      "name": "เหยี่ยว",
      "th": "เหยี่ยว",
      "lo": "ເຫຍີ່ວ",
      "en": "Hawk",
      "image": "hawk.png",
      "lotteries": ["25", "65"],
    },
    {
      "name": "มังกร",
      "th": "มังกร",
      "lo": "ມັງກອນ",
      "en": "Dragon",
      "image": "dragon.png",
      "lotteries": ["26", "66"],
    },
    {
      "name": "เต่า",
      "th": "เต่า",
      "lo": "ເຕົ່າ",
      "en": "Turtle",
      "image": "turtle.png",
      "lotteries": ["27", "67"],
    },
    {
      "name": "ไก่",
      "th": "ไก่",
      "lo": "ໄກ່",
      "en": "Chicken",
      "image": "chicken.png",
      "lotteries": ["28", "68"],
    },
    {
      "name": "ปลาไหล",
      "th": "ปลาไหล",
      "lo": "ປາໄຫຼ",
      "en": "Eel",
      "image": "eel.png",
      "lotteries": ["29", "69"],
    },
    {
      "name": "ปลาใหญ่",
      "th": "ปลาใหญ่",
      "lo": "ປາໃຫຍ່",
      "en": "Big Fish",
      "image": "bigfish.png",
      "lotteries": ["30", "70"],
    },
    {
      "name": "กุ้ง",
      "th": "กุ้ง",
      "lo": "ກຸ້ງ",
      "en": "Shrimp",
      "image": "shrimp.png",
      "lotteries": ["31", "71"],
    },
    {
      "name": "งู",
      "th": "งู",
      "lo": "ງູ",
      "en": "Snake",
      "image": "snake.png",
      "lotteries": ["32", "72"],
    },
    {
      "name": "แมงมุม",
      "th": "แมงมุม",
      "lo": "ແມງມຸມ",
      "en": "Spider",
      "image": "spiderman.png",
      "lotteries": ["33", "73"],
    },
    {
      "name": "กวาง",
      "th": "กวาง",
      "lo": "ກວາງ",
      "en": "Deer",
      "image": "deer.png",
      "lotteries": ["34", "74"],
    },
    {
      "name": "แพะ",
      "th": "แพะ",
      "lo": "ແພະ",
      "en": "Goat",
      "image": "goat.png",
      "lotteries": ["35", "75"],
    },
    {
      "name": "อีเห็น",
      "th": "อีเห็น",
      "lo": "ອີເຫັນ",
      "en": "Weasel",
      "image": "weasel.png",
      "lotteries": ["36", "76"],
    },
    {
      "name": "ตัวนิ่ม",
      "th": "ตัวนิ่ม",
      "lo": "ຕົວນິ່ມ",
      "en": "Armadillo",
      "image": "armadillo.png",
      "lotteries": ["37", "77"],
    },
    {
      "name": "เม่น",
      "th": "เม่น",
      "lo": "ເມ່ນ",
      "en": "Porcupine",
      "image": "porcupine.png",
      "lotteries": ["38", "78"],
    },
    {
      "name": "ปู",
      "th": "ปู",
      "lo": "ປູ",
      "en": "Crab",
      "image": "crab.png",
      "lotteries": ["39", "79"],
    },
    {
      "name": "อินทรี",
      "th": "อินทรี",
      "lo": "ອິນທຣີ",
      "en": "Eagle",
      "image": "eagle.png",
      "lotteries": ["40", "80"],
    },
  ];
  bool isLoading = false;
  final inputStyle = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 4,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: AppColors.borderGray,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 1,
        color: Colors.black.withOpacity(0.6),
      ),
    ),
  );
  List<TextEditingController> listController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  List<String> listPrice = ["1000", "1000", "1000"];

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zinZaeBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Header(
            //   title: AppLocale.animalNumber.getString(context),
            //   backgroundColor: AppColors.primary,
            //   textColor: Colors.white,
            // ),
            Container(
              color: AppColors.zinZaeBackground,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: widget.onBack,
                    child: Container(
                      color: AppColors.zinZaeBackground,
                      padding: const EdgeInsets.all(6),
                      width: 48,
                      height: 48,
                      child: SvgPicture.asset(
                        AppIcon.x,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: widget.padding,
                  // color: AppColors.borderGray,
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height * 0.6,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    direction: Axis.horizontal,
                    children: animalDatas.map((animal) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width * 0.5 - 4 - 10,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image(
                                  image: AssetImage(
                                      'assets/animalphoto/${animal['image']}'),
                                  height: 48,
                                  width: 48,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  // '${animal['name']}',
                                  "${animal['${localization.currentLocale}']}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: (animal['lotteries'] as List<String>)
                                  .map((lottery) {
                                return Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    // padding: EdgeInsets.symmetric(horizontal: 12),
                                    // width: fullWidth - 20,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(
                                      '$lottery',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 8),
                            Material(
                              child: InkWell(
                                onTap: widget.disableBuy == true
                                    ? null
                                    : () {
                                        // showSimpleNotification
                                        Get.dialog(
                                          DialogAnimal(
                                            animal: animal,
                                            onClickBuy: (lotterise) async {
                                              logger.d("lotterise: $lotterise");
                                              await Future.delayed(
                                                const Duration(seconds: 2),
                                              );
                                              if (widget.onClickBuy == null) {
                                                return;
                                              }
                                              widget.onClickBuy!(lotterise);
                                            },
                                          ),
                                        );
                                        for (var element in listController) {
                                          element.setText('1000');
                                        }
                                      },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //   color: Color.fromRGBO(0, 117, 255, 1),
                                    //   width: 1,
                                    // ),
                                    color: widget.disableBuy == true
                                        ? AppColors.disable
                                        : AppColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    AppLocale.buy.getString(context),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: widget.disableBuy == true
                                          ? Colors.black.withOpacity(0.6)
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList()
                    // Container(
                    //   color: Colors.lime,
                    //   child: Text('data'),
                    //   width: MediaQuery.of(context).size.width * 0.5 - 6 - 10,
                    // ),
                    // Container(
                    //   color: Colors.amber,
                    //   child: Text('data'),
                    //   width: MediaQuery.of(context).size.width * 0.5 - 6 - 10,
                    // ),
                    // Container(
                    //   color: Colors.amber,
                    //   child: Text('data'),
                    //   width: MediaQuery.of(context).size.width * 0.5 - 6 - 10,
                    // ),
                    ,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
