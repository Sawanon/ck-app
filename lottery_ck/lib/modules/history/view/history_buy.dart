import 'package:flutter/material.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';

class HistoryBuyPage extends StatelessWidget {
  const HistoryBuyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // shrinkWrap: true,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
            width: 135,
            child: DropdownButton(
              padding: EdgeInsets.all(0),
              isExpanded: true,
              underline: Container(),
              // value: '05-2023',
              value: 0,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              isDense: true,
              items: List.generate(3, (index) {
                return DropdownMenuItem(
                  child: Container(
                    width: 135,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        // color: Colors.lime,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      '$index',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  value: index,
                );
              }).toList(),
              onChanged: (value) {
                logger.d(value);
              },
              // onChanged: widget.onChange,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(bottom: 8),
            // clipBehavior: Clip.none,
            shrinkWrap: true,
            children: List.generate(5, (index) {
              return Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 15,
                      offset: Offset(4, 4),
                    )
                  ],
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  shadowColor: Colors.grey.withOpacity(0.5),
                  color: Colors.white,
                  child: InkWell(
                    overlayColor: MaterialStateProperty.all<Color>(Colors.grey.shade400),
                    onTap: () {
                      print('on click list View');
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return Bill();
                      //   },
                      // );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          // color: Colors.white,
                          // borderRadius: BorderRadius.all(
                          //   Radius.circular(10),
                          // ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 1,
                          //     blurRadius: 5,
                          //     offset: Offset(0, 3),
                          //   )
                          // ],
                          ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Builder(
                                    builder: (context) {
                                      // final localDateTime =
                                      //     DateTime.parse(widget.invoiceList![index]["\$createdAt"]).toLocal();
                                      // final date =
                                      //     '${localDateTime.day.toString().padLeft(2, '0')}/${localDateTime.month.toString().padLeft(2, '0')}/${localDateTime.year}';
                                      // final time =
                                      //     '${localDateTime.hour.toString().padLeft(2, '0')}:${localDateTime.minute.toString().padLeft(2, '0')}:${localDateTime.second}';
                                      // return Text('วันที่ $date เวลาซื้อ $time');
                                      return Text('วันที่ 12 เวลาซื้อ 12:00');
                                    },
                                  ),
                                  SizedBox(height: 4),
                                  // Text('เลขที่บิลหวย: ${widget.invoiceList![index]["\$id"]}'),
                                  Text('เลขที่บิลหวย: 3403002034'),
                                ],
                              ),
                              Builder(builder: (context) {
                                // final formatter = NumberFormat('#,##,000');
                                // final totalPrice = formatter.format(widget.invoiceList![index]["totalAmount"]);
                                return Text(
                                  // totalPrice,
                                  "50,000",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(249, 49, 55, 1),
                                  ),
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('เลขที่ซื้อ'),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Builder(builder: (context) {
                                        // TODO: bug
                                        List<dynamic> lotteryArray = ['1', '2', '3', '4'];
                                        // lotteryArray.map((lottery) {
                                        //   print('per loop 153: $lottery');
                                        // });
                                        return Wrap(
                                          spacing: 8.0,
                                          runSpacing: 6.0,
                                          children: lotteryArray.map((lottery) {
                                            return Container(
                                              padding: EdgeInsets.symmetric(vertical: 8),
                                              alignment: Alignment.center,
                                              width: 74,
                                              child: Text(
                                                '$lottery',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
