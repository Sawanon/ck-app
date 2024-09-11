import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      "name": "ตัวนิ่ม",
      "image": "armadillo.png",
      "lotteries": ["37", "77"],
    },
    {
      "name": "ผึ้ง",
      "image": "bee.png",
      "lotteries": ["16", "56", "96"],
    },
    {
      "name": "ปลาใหญ่",
      "image": "bigfish.png",
      "lotteries": ["30", "70"],
    },
    {
      "name": "งูใหญ่",
      "image": "bigsnake.png",
      "lotteries": ["00", "00", "00"],
    },
    {
      "name": "นกแกนแก",
      "image": "birdgangare.png",
      // "lotteries": ["92", "51", "21"],
      "lotteries": ["00", "00", "00"],
    },
    {
      "name": "ควาย",
      "image": "buffalo.png",
      "lotteries": ["09", "49", "89"],
    },
    {
      "name": "ผีเสื้อ",
      "image": "butterfly.png",
      "lotteries": ["19", "59", "99"],
    },
    {
      "name": "แมว",
      "image": "cat.png",
      "lotteries": ["14", "54", "94"],
    },
    {
      "name": "แมวป่า",
      "image": "catforest.png",
      "lotteries": ["18", "58", "98"],
    },
    {
      "name": "ตะขาบ",
      "image": "centipede.png",
      "lotteries": ["00", "20", "60"],
    },
    {
      "name": "ไก่",
      "image": "chicken.png",
      "lotteries": ["28", "68"],
    },
    {
      "name": "ปู",
      "image": "crab.png",
      "lotteries": ["39", "79"],
    },
    {
      "name": "กวาง",
      "image": "deer.png",
      "lotteries": ["34", "74"],
    },
    {
      "name": "หมา",
      "image": "dog.png",
      "lotteries": ["11", "51", "91"],
    },
    {
      "name": "อินทรีย์",
      "image": "eagle.png",
      "lotteries": ["40", "80"],
    },
    {
      "name": "นกกระยาง",
      "image": "egret.png",
      "lotteries": ["17", "57", "97"],
    },
    {
      "name": "ช้าง",
      "image": "elephant.png",
      "lotteries": ["13", "53", "93"],
    },
    {
      "name": "ปลา",
      "image": "fish.png",
      "lotteries": ["01", "41", "81"],
    },
    {
      "name": "กบ",
      "image": "fog.png",
      "lotteries": ["24", "64"],
    },
    {
      "name": "แพะ",
      "image": "goat.png",
      "lotteries": ["35", "75"],
    },
    {
      "name": "ห่าน",
      "image": "goose.png",
      "lotteries": ["03", "43", "83"],
    },
    {
      "name": "เหยี่ยว",
      "image": "hawk.png",
      "lotteries": ["25", "65"],
    },
    {
      "name": "ม้า",
      "image": "horse.png",
      "lotteries": ["12", "52", "92"],
    },
    {
      "name": "สิงโต",
      "image": "lion.png",
      "lotteries": ["05", "45", "85"],
    },
    {
      "name": "ลิง",
      "image": "monkey.png",
      "lotteries": ["23", "63"],
    },
    {
      "name": "นาก",
      "image": "otter.png",
      "lotteries": ["10", "50", "90"],
    },
    {
      "name": "นกยู",
      "image": "peacock.png",
      "lotteries": ["04", "44", "84"],
    },
    {
      "name": "หมู",
      "image": "pig.png",
      "lotteries": ["07", "47", "87"],
    },
    {
      "name": "เม่น",
      "image": "porcupine.png",
      "lotteries": ["38", "78"],
    },
    {
      "name": "กระต่าย",
      "image": "rabbit.png",
      "lotteries": ["08", "48", "88"],
    },
    {
      "name": "หนู",
      "image": "rat.png",
      "lotteries": ["15", "55", "95"],
    },
    {
      "name": "แมวน้ำ",
      "image": "seal.png",
      "lotteries": ["10", "50", "90"],
    },
    {
      "name": "หอย",
      "image": "shell.png",
      "lotteries": ["02", "42", "82"],
    },
    {
      "name": "กุ้ง",
      "image": "shrimp.png",
      "lotteries": ["31", "71"],
    },
    {
      "name": "งู",
      "image": "snake.png",
      "lotteries": ["32", "72"],
    },
    {
      "name": "แมงมุม",
      "image": "spiderman.png",
      "lotteries": ["33", "73"],
    },
    {
      "name": "นกนางแอ่น",
      "image": "swallow.png",
      "lotteries": ["00", "00", "00"],
    },
    {
      "name": "เสือ",
      "image": "tiger.png",
      "lotteries": ["06", "46", "86"],
    },
    {
      "name": "เต่า",
      "image": "turtle.png",
      "lotteries": ["27", "67"],
    },
    {
      "name": "อีเห็น",
      "image": "weasel.png",
      "lotteries": ["00", "00", "00"],
    },
  ];
  void Function(List<Map<String, dynamic>> lotterise) onClickBuy =
      Get.arguments[0];
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: Center(
          child: Text(
            'ตำราสัตว์',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          Material(
            borderRadius: BorderRadius.circular(32),
            color: Colors.red,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              overlayColor: WidgetStateProperty.all<Color>(
                Colors.red.shade700,
              ),
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: 32,
                height: 32,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
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
                          ),
                          SizedBox(width: 10),
                          Text(
                            '${animal['name']}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: (animal['lotteries'] as List<String>)
                            .map((lottery) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
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
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 8),
                      Material(
                        child: InkWell(
                          onTap: () {
                            // showSimpleNotification
                            final navigatorContext = Navigator.of(context);
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Material(
                                  color: Colors.transparent,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    runAlignment: WrapAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                        ),
                                        // color: Colors.amber,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(),
                                            Text(
                                              'กรุณาระบุราคา',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              width: 30,
                                              height: 30,
                                              child: Material(
                                                color: AppColors.errorBorder,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: InkWell(
                                                  overlayColor:
                                                      WidgetStateProperty.all<
                                                              Color>(
                                                          Colors.red.shade400),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 240,
                                        padding: EdgeInsets.only(bottom: 16),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: ListView.separated(
                                          itemBuilder: (context, index) {
                                            final list = animal['lotteries']
                                                as List<String>;
                                            final lottery = list[index];
                                            return Container(
                                              margin: EdgeInsets.only(top: 16),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    // padding: EdgeInsets.symmetric(horizontal: 12),
                                                    alignment: Alignment.center,
                                                    width: 40,
                                                    height: 48,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            AppColors.primary,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                    ),
                                                    child: Text(
                                                      '${lottery}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8.0),
                                                      child: TextFormField(
                                                        decoration: inputStyle,
                                                        controller:
                                                            listController[
                                                                index],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onChanged: (value) {
                                                          print(
                                                              'animal index: $index');
                                                          final animalList =
                                                              animal["lotteries"]
                                                                  as List<
                                                                      String>;
                                                          final animalThisLoop =
                                                              animalList[index];
                                                          print(
                                                              'lottery is: $animalThisLoop');
                                                          print(
                                                              'value is $value');
                                                          setState(() {
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
                                          separatorBuilder: (context, index) =>
                                              SizedBox(),
                                          itemCount: (animal['lotteries']
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
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Material(
                                          color: AppColors.primary,
                                          child: InkWell(
                                            overlayColor:
                                                WidgetStateProperty.all<Color>(
                                                    AppColors.primary),
                                            onTap: () {
                                              final listLottery =
                                                  animal['lotteries']
                                                      as List<String>;
                                              List<Map<String, dynamic>>
                                                  lotteryWithPrice = [];
                                              listLottery
                                                  .asMap()
                                                  .forEach((index, element) {
                                                lotteryWithPrice.add({
                                                  "lottery": element,
                                                  "price": listPrice[index],
                                                });
                                              });

                                              print('list of price $listPrice');
                                              print(
                                                  "result 521: $lotteryWithPrice");
                                              // onClickBuy(animal['lotteries'] as List<String>);
                                              onClickBuy(lotteryWithPrice);
                                              Navigator.of(context).pop();
                                              navigatorContext.pop();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'ยืนยัน',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
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
                              border: Border.all(
                                color: Color.fromRGBO(0, 117, 255, 1),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 6),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              'ซื้อ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
    );
  }
}
