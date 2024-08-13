import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottery_ck/modules/buy_lottery/view/buy_lottery.dart';
import 'package:lottery_ck/modules/home/controller/home.controller.dart';
import 'package:lottery_ck/res/color.dart';
import 'package:lottery_ck/res/icon.dart';
import 'package:lottery_ck/res/logo.dart';
import 'package:lottery_ck/route/route_name.dart';
import 'package:lottery_ck/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 144),
              child: ListView(
                clipBehavior: Clip.none,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.2),
                            offset: Offset(4, 4),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text('Images'),
                      // height: 200,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        // height: 30,
                        width:
                            (MediaQuery.of(context).size.width / 2) - (16 * 2),
                        child: Logo.ck,
                      ),
                      Text(
                        "Lottery date 08-Jul-2024",
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow.withOpacity(0.2),
                          offset: const Offset(4, 4),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 4),
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "1",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                'Day',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 4),
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "23",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                'Hour',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 4),
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "59",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                'Minute',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 4),
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "59",
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                'Second',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: ((MediaQuery.of(context).size.width / 3) * 2) -
                            16 -
                            8,
                        height: ((MediaQuery.of(context).size.width / 3) * 2) -
                            16 -
                            8,
                        // child: Text('${((MediaQuery.of(context).size.width / 3) * 2) - 16 - 8}'),
                        child: Image.asset(
                          "assets/image1.png",
                          width: double.infinity,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery.of(context).size.width / 3 - 16,
                            height: MediaQuery.of(context).size.width / 3 - 16,
                            // child: Text(
                            //     '${MediaQuery.of(context).size.width / 3 - 16}'),
                            child: Image.asset(
                              "assets/image2.png",
                              width: double.infinity,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: MediaQuery.of(context).size.width / 3 - 16,
                            height: MediaQuery.of(context).size.width / 3 - 16,
                            // child: Text(
                            //     '${MediaQuery.of(context).size.width / 3 - 16}'),
                            child: Image.asset(
                              "assets/image3.png",
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Container(
                  //   color: Colors.red.shade100,
                  //   height: 200,
                  //   width: 200,
                  // ),
                ],
              ),
            ),
            Align(
              alignment: controller.lotteryAlinment,
              child: BuyLottery(),
            ),
          ],
        ),
      );
    });
  }
}
