import 'package:flutter/material.dart';
import 'package:lottery_ck/res/constant.dart';

class AnimalLottery extends StatelessWidget {
  final String lottery;
  const AnimalLottery({
    super.key,
    required this.lottery,
  });

  @override
  Widget build(BuildContext context) {
    final lastTwo =
        lottery.length > 2 ? lottery.substring(lottery.length - 2) : lottery;
    final animal = AppConst.animalDatas.where((animal) {
      final lotteries = animal['lotteries'] as List<String>;
      final result = lotteries.where((_lottery) => _lottery == lastTwo);
      return result.isNotEmpty;
    }).toList();
    if (animal.isNotEmpty) {
      return Image.asset(
        "assets/animal/${animal[0]['image']}",
        width: 28,
        height: 28,
      );
    }
    return const Text("");
  }
}
