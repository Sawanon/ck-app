import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottery_ck/components/input_text.dart';
import 'package:lottery_ck/components/long_button.dart';
import 'package:lottery_ck/res/app_locale.dart';

class DialogEditLottery extends StatefulWidget {
  final String lottery;
  final int price;
  final Future<void> Function(int? newPrice) onSubmit;
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
  int? newPrice;

  void setIsLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void onChangePrice(String value) {
    setState(() {
      newPrice = int.parse(value);
    });
  }

  Future<void> onSubmit() async {
    setIsLoading(true);
    await widget.onSubmit(newPrice);
    setIsLoading(false);
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
                "Edit lottery",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.lottery,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              InputText(
                label: Text(
                  AppLocale.price.getString(context),
                ),
                initialValue: "${widget.price}",
                onChanged: onChangePrice,
                keyboardType: TextInputType.number,
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
