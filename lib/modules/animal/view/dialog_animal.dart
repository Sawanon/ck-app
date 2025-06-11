import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';
import 'package:pinput/pinput.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogAnimal extends StatefulWidget {
  final Map animal;
  final Future<void> Function(List<Map<String, dynamic>> lotterise) onClickBuy;
  const DialogAnimal({
    super.key,
    required this.animal,
    required this.onClickBuy,
  });

  @override
  State<DialogAnimal> createState() => _DialogAnimalState();
}

class _DialogAnimalState extends State<DialogAnimal> {
  bool isLoading = false;
  List<TextEditingController> listController = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  List<String> listPrice = ["1000", "1000", "1000"];
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

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  void initState() {
    for (var element in listController) {
      element.setText(CommonFn.parseMoney(1000));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          // alignment: WrapAlignment.center,
          // runAlignment:
          //     WrapAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              // color: Colors.amber,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocale.pleaseEnterPrice.getString(context),
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
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        overlayColor:
                            WidgetStateProperty.all<Color>(Colors.red.shade400),
                        borderRadius: BorderRadius.circular(100),
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
              height: 220,
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final list = widget.animal['lotteries'] as List<String>;
                  final lottery = list[index];
                  return Container(
                    margin: EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // padding: EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          width: 40,
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text(
                            '${lottery}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextFormField(
                              decoration: inputStyle,
                              controller: listController[index],
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                print('animal index: $index');
                                final animalList =
                                    widget.animal["lotteries"] as List<String>;
                                final animalThisLoop = animalList[index];
                                print('lottery is: $animalThisLoop');
                                print('value is $value');
                                final onlyNumber = value.replaceAll(",", "");
                                setState(() {
                                  listPrice[index] =
                                      value.isEmpty ? '0' : onlyNumber;
                                });
                                if (value.isEmpty) {
                                  listController[index].setText('0');
                                  return;
                                }

                                final priceInt = int.parse(onlyNumber);
                                listController[index]
                                    .setText(CommonFn.parseMoney(priceInt));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(),
                itemCount: (widget.animal['lotteries'] as List<String>).length,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              padding: const EdgeInsets.only(
                bottom: 16,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: LongButton(
                      backgroundColor: Colors.white,
                      borderSide: BorderSide(
                        width: 1,
                        color: AppColors.primary,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        AppLocale.cancel.getString(context),
                        style: TextStyle(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LongButton(
                      isLoading: isLoading,
                      onPressed: () async {
                        final listLottery =
                            widget.animal['lotteries'] as List<String>;
                        List<Map<String, dynamic>> lotteryWithPrice = [];
                        bool invalidPrice = false;
                        listLottery.asMap().forEach((index, element) {
                          logger.w(listPrice[index]);
                          final price = int.parse(listPrice[index]);
                          if (price % 1000 != 0) {
                            invalidPrice = true;
                          }
                          lotteryWithPrice.add({
                            "lottery": element,
                            "price": listPrice[index],
                          });
                        });
                        if (invalidPrice) {
                          BuyLotteryController.to.showInvalidPrice();
                          return;
                        }
                        setIsLoading(true);
                        await widget.onClickBuy(lotteryWithPrice);

                        setIsLoading(false);
                        // navigatorContext
                        //     .pop();
                      },
                      child: Text(
                        AppLocale.confirm.getString(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
