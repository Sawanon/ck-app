import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/history/controller/history_buy.controller.dart';
import 'package:lottery_ck/utils.dart';

class LotterynumberComponent extends StatelessWidget {
  final String transactionId;
  const LotterynumberComponent({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryBuyController>(
      initState: (state) {
        // logger.w("LotterynumberComponent: $transactionId");
        HistoryBuyController.to.getTransaction(transactionId);
        // state.controller?.getTransaction(transactionId);
      },
      builder: (controller) {
        return Container(
          child: Text(transactionId),
        );
      },
    );
  }
}
