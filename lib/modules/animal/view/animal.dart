import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/dialog.dart';
import 'package:lottery_ck/components/header.dart';
import 'package:lottery_ck/main.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:pinput/pinput.dart';

class AnimalPage extends StatefulWidget {
  const AnimalPage({super.key});

  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
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
  void Function(List<Map<String, dynamic>> lotterise)? onClickBuy =
      Get.arguments?[0];
  final bool? disableBuy = Get.arguments?[1];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: AppLocale.animalNumber.getString(context),
              backgroundColor: AppColors.primary,
              textColor: Colors.white,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: AppColors.borderGray,
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
                                onTap: disableBuy == true
                                    ? null
                                    : () {
                                        // showSimpleNotification
                                        final navigatorContext =
                                            Navigator.of(context);
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return Material(
                                              color: Colors.transparent,
                                              child: Wrap(
                                                alignment: WrapAlignment.center,
                                                runAlignment:
                                                    WrapAlignment.center,
                                                children: [
                                                  Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    padding: EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                    ),
                                                    // color: Colors.amber,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(),
                                                        Text(
                                                          AppLocale
                                                              .pleaseEnterPrice
                                                              .getString(
                                                                  context),
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          child: Material(
                                                            color: AppColors
                                                                .errorBorder,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            child: InkWell(
                                                              overlayColor:
                                                                  WidgetStateProperty.all<
                                                                          Color>(
                                                                      Colors.red
                                                                          .shade400),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              onTap: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 240,
                                                    padding: EdgeInsets.only(
                                                        bottom: 16),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    child: ListView.separated(
                                                      itemBuilder:
                                                          (context, index) {
                                                        final list =
                                                            animal['lotteries']
                                                                as List<String>;
                                                        final lottery =
                                                            list[index];
                                                        return Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 16),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      12),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                // padding: EdgeInsets.symmetric(horizontal: 12),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width: 40,
                                                                height: 48,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: AppColors
                                                                        .primary,
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2),
                                                                ),
                                                                child: Text(
                                                                  '${lottery}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child:
                                                                      TextFormField(
                                                                    decoration:
                                                                        inputStyle,
                                                                    controller:
                                                                        listController[
                                                                            index],
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    onChanged:
                                                                        (value) {
                                                                      print(
                                                                          'animal index: $index');
                                                                      final animalList = animal[
                                                                              "lotteries"]
                                                                          as List<
                                                                              String>;
                                                                      final animalThisLoop =
                                                                          animalList[
                                                                              index];
                                                                      print(
                                                                          'lottery is: $animalThisLoop');
                                                                      print(
                                                                          'value is $value');
                                                                      setState(
                                                                          () {
                                                                        listPrice[index] =
                                                                            value;
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                        // listController
                                                      },
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              SizedBox(),
                                                      itemCount: (animal[
                                                                  'lotteries']
                                                              as List<String>)
                                                          .length,
                                                    ),
                                                    // child: Column(
                                                    //   children: (animal['lotteries'] as List<String>).map((e) {
                                                    //     return Container(
                                                    //       margin: EdgeInsets.only(top: 16),
                                                    //       padding: const EdgeInsets.symmetric(horizontal: 12),
                                                    //       child: Row(
                                                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //         crossAxisAlignment: CrossAxisAlignment.center,
                                                    //         children: [
                                                    //           Container(
                                                    //             // padding: EdgeInsets.symmetric(horizontal: 12),
                                                    //             alignment: Alignment.center,
                                                    //             width: 40,
                                                    //             decoration: BoxDecoration(
                                                    //               border: Border.all(
                                                    //                 color: AppColors.primary,
                                                    //                 width: 1,
                                                    //               ),
                                                    //               borderRadius: BorderRadius.circular(2),
                                                    //             ),
                                                    //             child: Text(
                                                    //               '$e',
                                                    //               style: TextStyle(
                                                    //                 fontSize: 16,
                                                    //                 fontWeight: FontWeight.bold,
                                                    //               ),
                                                    //             ),
                                                    //           ),
                                                    //           Expanded(
                                                    //             child: Padding(
                                                    //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    //               child: TextFormField(
                                                    //                 decoration: inputStyle,
                                                    //               ),
                                                    //             ),
                                                    //           )
                                                    //         ],
                                                    //       ),
                                                    //     );
                                                    //   }).toList(),
                                                    // ),
                                                  ),
                                                  Container(
                                                    // alignment: Alignment.center,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16),
                                                    height: 50,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Material(
                                                      color: AppColors.primary,
                                                      child: InkWell(
                                                        overlayColor:
                                                            WidgetStateProperty
                                                                .all<
                                                                        Color>(
                                                                    AppColors
                                                                        .primary),
                                                        onTap: () {
                                                          final listLottery =
                                                              animal['lotteries']
                                                                  as List<
                                                                      String>;
                                                          List<
                                                                  Map<String,
                                                                      dynamic>>
                                                              lotteryWithPrice =
                                                              [];
                                                          bool invalidPrice =
                                                              false;
                                                          listLottery
                                                              .asMap()
                                                              .forEach((index,
                                                                  element) {
                                                            final price =
                                                                int.parse(
                                                                    listPrice[
                                                                        index]);
                                                            if (price % 1000 !=
                                                                0) {
                                                              invalidPrice =
                                                                  true;
                                                            }
                                                            lotteryWithPrice
                                                                .add({
                                                              "lottery":
                                                                  element,
                                                              "price":
                                                                  listPrice[
                                                                      index],
                                                            });
                                                          });
                                                          if (invalidPrice) {
                                                            BuyLotteryController
                                                                .to
                                                                .showInvalidPrice();
                                                            return;
                                                          }
                                                          // onClickBuy(animal['lotteries'] as List<String>);
                                                          if (onClickBuy ==
                                                              null) {
                                                            return;
                                                          }
                                                          onClickBuy!(
                                                              lotteryWithPrice);
                                                          Navigator.of(context)
                                                              .pop();
                                                          navigatorContext
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            AppLocale.confirm
                                                                .getString(
                                                                    context),
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                        for (var element in listController) {
                                          element.setText('1000');
                                        }
                                        // onClickBuy(animal['lotteries'] as List<String>);
                                        // Navigator.of(context).pop();
                                      },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //   color: Color.fromRGBO(0, 117, 255, 1),
                                    //   width: 1,
                                    // ),
                                    color: disableBuy == true
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
                                      color: disableBuy == true
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
