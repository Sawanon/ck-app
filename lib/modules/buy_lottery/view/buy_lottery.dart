import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/buy_lottery/controller/buy_lottery.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class BuyLottery extends StatelessWidget {
  const BuyLottery({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuyLotteryController>(builder: (controller) {
      return Stack(
        children: [
          Container(
            // color: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            height: 144,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.borderGray,
                      width: 1,
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          // color: Colors.blue.shade200,
                          child: Row(
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcon.animal,
                                      width: 24,
                                      height: 24,
                                    ),
                                    Text(
                                      "ตำรา",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        height: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcon.shuffle,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      width: 24,
                                      height: 24,
                                    ),
                                    Text(
                                      "ສຸ່ມ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        height: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                child: Text(
                                  "2345",
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                onTap: () {
                                  logger.d("onTap");
                                  showBottomSheet(
                                    backgroundColor: Colors.red.shade100,
                                    context: context,
                                    // enableDrag: false,
                                    builder: (context) {
                                      return Container(
                                        width: double.infinity,
                                        height: 400,
                                        // color: Colors.red.shade900,
                                        child: Column(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                navigator?.pop();
                                              },
                                              child: Text("Close"),
                                            ),
                                            Text("data"),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  width: 1,
                                  color: AppColors.borderGray,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(),
                                  child: Text(
                                    '1000',
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    logger.d("message");
                                  },
                                  child: Container(
                                    height: 52,
                                    width: 52,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SvgPicture.asset(
                                      AppIcon.add,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                      width: 36,
                                      height: 36,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  // color: Colors.amber,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: AppColors.borderGray,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ລວມທັງໝົດ',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '0',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            logger.d("confirm");
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "ຢືນຢັນ",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () {
              if (!controller.isUserLoggedIn.value) {
                return Container(
                  height: 144,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      controller.gotoLoginPage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      );
    });
  }
}
