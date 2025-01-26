import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';
import 'package:lottery_ck/utils.dart';
import 'package:lottery_ck/utils/common_fn.dart';

class DialogEditLottery extends StatefulWidget {
  final String lottery;
  final int price;
  final Future<void> Function(String? lottery, int? newPrice) onSubmit;
  const DialogEditLottery({
    super.key,
    required this.lottery,
    required this.price,
    required this.onSubmit,
  });

  @override
  State<DialogEditLottery> createState() => _DialogEditLotteryState();
}

class _DialogEditLotteryState extends State<DialogEditLottery> {
  bool isLoading = false;
  String? newLottery;
  int? newPrice;
  TextEditingController priceController = TextEditingController();

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void onChangePrice(String value) {
    logger.d(value);
    if (value == "") {
      setState(() {
        newPrice = null;
      });
      // priceController.text = "";
      return;
    }
    final onlyNumber = value.replaceAll(",", "");
    logger.d("onlyNumber: $onlyNumber");
    final priceInt = int.parse(onlyNumber);
    priceController.text = CommonFn.parseMoney(priceInt);
    setState(() {
      newPrice = int.parse(value);
    });
  }

  void onChangeLottery(String value) {
    setState(() {
      newLottery = value;
    });
  }

  Future<void> onSubmit() async {
    if (newLottery == "") {
      Get.rawSnackbar(message: AppLocale.pleaseFillLottery.getString(context));
      return;
    }
    if (newLottery == null && newPrice == null) {
      Get.rawSnackbar(message: AppLocale.pleaseEnterPrice.getString(context));
      return;
    }
    final priceValue =
        (newLottery != null && newPrice == null) ? widget.price : newPrice;
    setIsLoading(true);
    await widget.onSubmit(newLottery, priceValue);
    setIsLoading(false);
  }

  void setup() {
    // priceController.text = CommonFn.parseMoney(widget.price);
    onChangePrice(widget.price.toString());
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocale.editLottery.getString(context),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              InputText(
                maxLength: 6,
                counterText: "",
                label: Text(
                  AppLocale.lottery.getString(context),
                ),
                initialValue: widget.lottery,
                onChanged: onChangeLottery,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              Stack(
                alignment: Alignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  InputText(
                    controller: priceController,
                    maxValue: 999999999,
                    label: Text(
                      AppLocale.price.getString(context),
                    ),
                    // initialValue: "${widget.price}",
                    onChanged: onChangePrice,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  Positioned(
                    right: 8,
                    child: Text(
                      AppLocale.lak.getString(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LongButton(
                isLoading: isLoading,
                onPressed: () {
                  onSubmit();
                },
                child: Text(
                  AppLocale.confirm.getString(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
