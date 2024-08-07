import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/utils.dart';

class TurnstileMiddleware extends GetMiddleware {
  @override
  int? get priority => 0;

  @override
  RouteSettings? redirect(String? route) {
    logger.f("middleware: redirect");
    return super.redirect(route);
  }

  // @override
  // Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
  //   logger.f("middleware: redirectDelegate");
  //   return super.redirectDelegate(route);
  // }

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) async {
    logger.f("middleware: redirectDelegate");
    return await super.redirectDelegate(route);
  }
}
