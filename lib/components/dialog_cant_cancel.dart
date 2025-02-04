import 'package:flutter/material.dart';
import 'package:lottery_ck/utils.dart';

class DialogCantCancel extends StatelessWidget {
  final Widget child;
  const DialogCantCancel({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        logger.d('didPop: $didPop');
      },
      child: child,
    );
  }
}
