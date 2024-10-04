import 'package:lottery_ck/model/lottery.dart';

class Bill {
  String firstName;
  String lastName;
  String phoneNumber;
  DateTime dateTime;
  String lotteryDateStr;
  List<Lottery> lotteryList;
  String totalAmount;
  String invoiceId;
  String bankName;
  String customerId;

  Bill({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.dateTime,
    required this.lotteryDateStr,
    required this.lotteryList,
    required this.totalAmount,
    required this.invoiceId,
    required this.bankName,
    required this.customerId,
  });
}
