import 'package:lottery_ck/model/lottery.dart';

class CommonFn {
  static String parseDMY(DateTime datetime) {
    return "${datetime.day.toString().padLeft(2, '0')}-${datetime.month.toString().padLeft(2, '0')}-${datetime.year}";
  }

  static String parseYMD(DateTime datetime) {
    return "${datetime.year}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}";
  }

  static String parseHMS(DateTime datetime) {
    return "${datetime.hour.toString().padLeft(2, "0")}:${datetime.minute.toString().padLeft(2, "0")}:${datetime.second.toString().padLeft(2, "0")}";
  }

  static int calculateTotalPrice(List<Lottery> lotteryList) {
    return lotteryList.fold(
        0, (previousValue, element) => previousValue + element.price);
  }
}
