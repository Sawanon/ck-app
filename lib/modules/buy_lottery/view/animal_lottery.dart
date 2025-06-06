import 'package:flutter/material.dart';
import 'package:lottery_ck/main.dart';
import 'package:lottery_ck/res/constant.dart';

class AnimalLottery extends StatelessWidget {
  final String lottery;
  final double size;
  final bool showName;
  final bool showLottery;
  const AnimalLottery({
    super.key,
    required this.lottery,
    this.size = 28,
    this.showName = false,
    this.showLottery = false,
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
      return Row(
        children: [
          Image.asset(
            "assets/animal/${animal[0]['image']}",
            width: size,
            height: size,
          ),
          if (showName) ...[
            const SizedBox(width: 4),
            Text("${animal[0][localization.currentLocale?.languageCode]}"),
          ],
          if (showLottery) ...[
            const SizedBox(width: 4),
            Text("${(animal[0]['lotteries'] as List).join(",")}"),
          ]
        ],
      );
    }
    return const Text("");
  }
}
