import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/modules/layout/controller/layout.controller.dart';
import 'package:lottery_ck/res/icon.dart';

class CartComponent extends StatelessWidget {
  const CartComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyLotteryController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() {
              if (controller.invoiceRemainExpireStr.value == "") {
                return const SizedBox.shrink();
              }
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.invoiceRemainExpireStr.value != ""
                        ? controller.invoiceRemainExpireStr.value
                        : "",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              );
            }),
            GestureDetector(
              onTap: () {
                LayoutController.to.changeTab(TabApp.lottery);
              },
              child: SizedBox(
                width: 24,
                height: 24,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SvgPicture.asset(
                      AppIcon.shoppingCart,
                      colorFilter: ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    Obx(
                      () {
                        if (controller.invoiceMeta.value.transactions.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Text(
                              "${controller.invoiceMeta.value.transactions.length}",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                height: 1,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
